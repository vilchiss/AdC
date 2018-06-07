library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity stage2 is
    port(
        clk, SelRegW, MemW : in std_logic;
        SelDir: in unsigned(1 downto 0);
        instr : in unsigned(31 downto 0);
        PC, DatoW, DirW : in unsigned(15 downto 0);
        D3, OP1, OP2 : out signed(15 downto 0);
        ControlBus : out unsigned(31 downto 0) 
    );
end stage2;

architecture arch of stage2 is
    signal sel_dir: unsigned(1 downto 0);
    signal sel_s1_mux : signed(15 downto 0);
    signal d1, d2, d3, d4, d5, ind_inc, reg_int, ext_signo : signed(15 downto 0);
    signal control_bus: unsigned(31 downto 0);
begin

    ------ Entidades ------ 
    -- Unidad de Control
    controlu: entity work.control_unit port map (
        instr       => instr(31 downto 16),
        SelRegR     => control_bus(31 downto 28);
        SelS1       => control_bus(27); 
        SR          => control_bus(26);
        Cin         => control_bus(25);
        SelS2       => control_bus(24);
        SelScrs     => control_bus(23 downto 21);
        SelDato     => control_bus(20);
        SelDir      => control_bus(19);
        SelOp       => control_bus(18 downto 15);
        SelResult   => control_bus(14);
        SelC        => control_bus(13);
        Cadj        => control_bus(12);
        SelFlags    => control_bus(11 downto 8);
        SelBranch   => control_bus(7);
        VF          => control_bus(6);
        SelRegW     => control_bus(5 downto 3);
        MemW        => control_bus(2);
        SelDir      => control_bus(1 downto 0);
    );
    ControlBus <= control_bus;
    
    -- Registros Internos
    regf: entity work.internal_registers port map(
        clk     => clk,
        reset   => reset,
        DatoW   => DatoW,
        SelRegR => control_bus(31 downto 28),
        SelRegW => SelRegW
    );


    ------ Sumador ------
    ind_inc <= signed(sel_s1_mux) + signed(d2) + Cin when control_bus(26) = 1 else unsigned(sel_s1_mux) - unsigned(d4) - Cin;


    ------ Extensión de Signo ------
    ext_signo <= to_signed(instr(7 downto 0), 16);


    ------ Muxes ------
    
    -- sel_dir es manejada por dos señales distintas D;
    sel_dir <= SelDir;
    sel_dir <= control_bus(1 downto 0);

    -- Mux SelS1
    sel_s1_mux <= X"0000" when control_bus(27) = '0' else instr(15 downto 0);

    -- Mux SelS2
    d2 <= reg_int when control_bus(24) = '0' else PC;

    -- Mux SelDir
    D3 <=   ind_inc when sel_dir = 0 else
            instr(15 downto 0) when sel_dir = 1 else
            DirW when sel_dir = 2;

    -- Mux SelDato
    d5 <= ext_signo when control_bus(20) = '0' else instr(15 downto 0);

    --Mux SelSrcs (OP1)
    OP1 <= X"0000" when control_bus(23 downto 21) = 0 else
                d1 when control_bus(23 downto 21) = 1 or control_bus(23 downto 21) = 2 or control_bus(23 downto 21) = 3 else
                d4 when control_bus(23 downto 21) = 4 else
                d2 when control_bus(23 downto 21) = 5 or control_bus(23 downto 21) = 6;

    -- Mux SelSrcs (OP2)
    OP2 <= X"0000" when control_bus(23 downto 21) = 0 else
                d2 when control_bus(23 downto 21) = 1 else
                d4 when control_bus(23 downto 21) = 2 or control_bus(23 downto 21) = 6 else
                d5 when control_bus(23 downto 21) = 3 or control_bus(23 downto 21) = 5 else
                D3 when control_bus(23 downto 21) = 4;

 

end architecture;

