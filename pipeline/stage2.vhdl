library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity stage2 is
  port(
    clk, sel_reg_w, sel_dir_ext, mem_w : in std_logic;
    instr : in unsigned(31 downto 0);
    pc, dato_w, dir_w : in unsigned(15 downto 0);
    d3, op1, op2 : out unsigned(15 downto 0)
  );
end stage2;

architecture arch of stage2 is
  signal sel_s_1, sel_s_2, sel_dato, sel_srcs : std_logic;
  signal sel_s_mux : unsigned(15 downto 0);
  signal d1, d2, d3, d4, d5, ind_inc, reg_int, ext_signo : unsigned(15 downto 0);

  -- Mux SelS1
  sel_s_mux <= X"0000" when sel_s_1 = '0' else instr(15 downto 0);

  -- Mux SelS2
  d2 <= reg_int when sel_s_2 = '0' else pc;

  -- Mux SelDir
  d3 <= ind_inc when sel_dir_ext = 0 else
        instr(15 downto 0) when sel_dir_ext = 1 else
        dir_w when sel_dir_ext = 2;

  -- Mux SelDato
  d5 <= ext_signo when sel_dato = '0' else instr(15 downto 0);

  --Mux SelSrcs (OP1)
  op1 <= X"0000" when sel_srcs = 0 else
         d1 when sel_srcs = 1 or sel_srcs = 2 or sel_srcs = 3 else
         d4 when sel_srcs = 4 else
         d2 when sel_srcs = 5 or sel_srcs = 6;

  -- Mux SelSrcs (OP2)
  op2 <= X"0000" when sel_srcs = 0 else
         d2 when sel_srcs = 1 else
         d4 when sel_srcs = 2 or sel_srcs = 6 else
         d5 when sel_srcs = 3 or sel_srcs = 5 else
         d3 when sel_srcs = 4;

  begin
end architecture;
