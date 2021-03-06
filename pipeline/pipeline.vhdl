library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity pipeline is
  port (
  clock, reset : in std_logic;
  switches : in unsigned(3 downto 0);
  leds : out unsigned(7 downto 0)
  );
end entity;

architecture arch of pipeline is
  -- From stage 1
  signal pc_s : unsigned(15 downto 0);
  signal instr_s : unsigned(31 downto 0);
  signal dato_w_s: unsigned(15 downto 0);
  signal branch_s : std_logic;

  -- From detention unit
  signal du_PCWrite, du_selCtrl : std_logic;
  signal du_if_id_Write : std_logic;
  signal du_selRegR : unsigned(3 downto 0);
  signal du_id_ex_selRegW, du_ex_wb_selRegW : unsigned(2 downto 0);
  signal du_Burbuja : unsigned(33 downto 0);

  -- To stage 2
  signal id_pc_s : unsigned(15 downto 0);
  signal id_instr_s : unsigned(31 downto 0);

  --From stage 2
  signal if_id_MemW, if_id_SelDir1_ext : std_logic;
  signal if_id_SelRegW : unsigned(2 downto 0);
  signal if_id_DatoW, if_id_DirW : unsigned(15 downto 0);
  signal if_id_D3, if_id_OP1, if_id_OP2 : unsigned(15 downto 0);
  signal if_id_ControlBus : unsigned(33 downto 0);

  --To stage 3
  signal id_ex_OP1, id_ex_OP2, id_ex_D3 : unsigned(15 downto 0);
  signal id_ex_ControlBus : unsigned(33 downto 0); 

  --From stage 3
  signal ex_wb_Branch : std_logic;
  signal ex_wb_Banderas : unsigned(5 downto 0);
  signal ACCA : unsigned(7 downto 0);
  signal ex_wb_DirW, ex_wb_DatoW : unsigned(15 downto 0);
  signal ex_wb_ControlBusOut : unsigned(33 downto 0); 

begin
  with switches select leds <= 
          ex_wb_ControlBusOut(7 downto 0) when "0000", 
          if_id_ControlBus(7 downto 0) when "0001", 
          if_id_D3(7 downto 0) when "0010", 
          if_id_OP1(7 downto 0) when "0011", 
          if_id_OP2(7 downto 0) when "0100", 
          if_id_DatoW(7 downto 0) when "0101", 
          if_id_DirW(7 downto 0) when "0110", 
          id_instr_s(7 downto 0) when "0111", 
          id_instr_s(15 downto 8) when "1000", 
          id_pc_s(7 downto 0) when "1001", 
          ex_wb_ControlBusOut(30 downto 23) when "1010", 
          ACCA when "1011", 
          ex_wb_DatoW(15 downto 8) when "1100", 
          ex_wb_DatoW(7 downto 0) when "1101", 
          id_ex_ControlBus(7 downto 0) when "1110", 
          du_Burbuja(7 downto 0) when "1111";


  instruction_fetch: entity work.stage1
  port map(
    clk => clock,
    reset => not(reset),
    PC => pc_s,
    PCWrite => du_PCWrite, 
    instr => instr_s,
    Branch => branch_s,  -- Regresar*
    DatoW => dato_w_s -- Regresar*
  );

  IF_ID : process(clock, reset)
  begin
    if not(reset) = '1' then
       id_pc_s <= (others => '0');
       id_instr_s <= (others => '0');
    elsif rising_edge(clock) then
        if du_if_id_Write = '1' then
          id_pc_s <= pc_s;
          id_instr_s <= instr_s;
        end if;
    end if;
  end process;

  instruction_decode: entity work.stage2
  port map(
    clk => clock,
    reset => not(reset),
    MemW => if_id_MemW,  -- Regresara *
    SelCtrl => du_selCtrl,
    Burbuja => du_Burbuja, 
    SelDir1_ext => if_id_SelDir1_ext,  -- Regresara *  
    SelRegW => if_id_SelRegW,  -- Regresara*    
    instr => id_instr_s,  -- Usado de la etapa anterior*    
    PC => id_pc_s,  -- Usado de la etapa anterior*
    DatoW => if_id_DatoW,  -- Regresara *
    DirW => if_id_DirW,    -- Regresar *
    D3 => if_id_D3,
    OP1 => if_id_OP1,
    OP2 => if_id_OP2,    
	 ACCA => ACCA,
    ControlBus => if_id_ControlBus   
  );

  ID_EX : process(clock, reset)
  begin
    if not(reset) = '1' then
      id_ex_OP1 <= (others => '0');
      id_ex_OP2 <= (others => '0');
      id_ex_D3 <= (others => '0');
      id_ex_ControlBus <= (others => '0');
    elsif rising_edge(clock) then
      id_ex_OP1 <= if_id_OP1;
      id_ex_OP2 <= if_id_OP2;
      id_ex_D3 <= if_id_D3;
      id_ex_ControlBus <= if_id_ControlBus;
    end if;
  end process;

  execution : entity work.stage3
  port map(
    clk => clock,
    reset => not(reset),
    ControlBusIn => id_ex_ControlBus,   
    OP1 => id_ex_OP1,
    OP2 => id_ex_OP2,
    D3 => id_ex_D3,   
    Branch => ex_wb_Branch,   
    DirW => ex_wb_DirW,
    DatoW => ex_wb_DatoW,   
    Banderas => ex_wb_Banderas,   
    ControlBusOut => ex_wb_ControlBusOut
  );

  EX_WB : process(clock, reset)
  begin
    if not(reset) = '1' then
      branch_s <= '0';
      dato_w_s <= (others => '0');
      if_id_DatoW <= (others => '0');
      if_id_DirW <= (others => '0');
      if_id_SelDir1_ext <= '0';
      if_id_SelRegW <= (others => '0');
      if_id_MemW <= '0';
    elsif rising_edge(clock) then
      branch_s <= ex_wb_Branch;
      dato_w_s <= ex_wb_DatoW;
      if_id_DatoW <= ex_wb_DatoW;
      if_id_DirW <= ex_wb_DirW;
      if_id_SelDir1_ext <= ex_wb_ControlBusOut(29);
      if_id_SelRegW <= ex_wb_ControlBusOut(3 downto 1);
      if_id_MemW <= ex_wb_ControlBusOut(0);
    end if;
  end process ;

  D_U: entity work.detention_unit
  port map(
    reg_st1_write => du_if_id_Write,
    selRegR => du_selRegR,
    selRegW_st3 => id_ex_ControlBus(3 downto 1),
    selRegW_st4 => if_id_SelRegW,
    selCtrl => du_selCtrl,
    PCWrite => du_PCWrite,
    Burbuja => du_Burbuja
  );
end architecture;
