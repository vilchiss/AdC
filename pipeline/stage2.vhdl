library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity stage2 is
    port(
        clk, reset, MemW, SelDir1_ext: in std_logic;
        SelRegW: in unsigned(3 downto 0);
        instr: in unsigned(31 downto 0);
        PC, DatoW, DirW: in unsigned(15 downto 0);
        D3, OP1, OP2: out unsigned(15 downto 0);
        ControlBus: out unsigned(31 downto 0)
    );
end stage2;

architecture arch of stage2 is
    signal sel_dir: unsigned(1 downto 0);
    signal sel_s1_mux: unsigned(15 downto 0);
    signal d1, d2r, d2, d3_s, d4, d5, reg_int, ext_signo: unsigned(15 downto 0);
    signal ind_inc: unsigned(15 downto 0);
    signal control_bus: unsigned(33 downto 0);
begin

    ------ Entidades ------
    -- Unidad de Control --
    controlu: entity work.control_unit port map (
        instr       => instr(31 downto 16),
        SelRegR     => control_bus(33 downto 30),
        SelS1       => control_bus(29),
        SR          => control_bus(28),
        Cin         => control_bus(27),
        SelS2       => control_bus(26),
        SelScrs     => control_bus(25 downto 23),
        SelDato     => control_bus(22),
        SelDir      => control_bus(21 downto 20),
        SelOp       => control_bus(19 downto 16),
        SelResult   => control_bus(15 downto 14),
        SelC        => control_bus(13),
        Cadj        => control_bus(12),
        SelFlags    => control_bus(11 downto 8),
        SelBranch   => control_bus(7 downto 5),
        VF          => control_bus(4),
        SelRegW     => control_bus(3 downto 1),
        MemW        => control_bus(0)
    );
    ControlBus <= control_bus;

    -- Registros Internos --
    regf: entity work.internal_registers port map(
        clk     => clk,
        reset   => reset,
        D1      => d1,
        D2      => d2r,
        DatoW   => DatoW,
        SelRegR => control_bus(33 downto 30),
        SelRegW => SelRegW
    );

    -- Sumador --
    sumres: entity work.sumador port map(
        cin => control_bus(27),
        sr  => control_bus(28),
        a   => d2,
        b   => sel_s1_mux,
        sum => ind_inc
    );

    ------ Extensin de Signo ------
    ext_signo <= unsigned(resize(signed(instr(7 downto 0)), ext_signo'length));


    ------ Muxes ------

    -- sel_dir es manejada por dos seales distintas D;
    sel_dir <= SelDir1_ext & control_bus(17);

    -- Mux SelS1
    sel_s1_mux <= X"0000" when control_bus(29) = '0' else instr(15 downto 0);

    -- Mux SelS2
    d2 <= d2r when control_bus(27) = '0' else PC;

    -- Mux SelDir
    d3_s <= ind_inc when sel_dir = "00" else
            instr(15 downto 0) when sel_dir = "01" else
            DirW when sel_dir = "10"; -- no hay caso 3 D; sintetiza a latch

    -- Mux SelDato
    d5 <= ext_signo when control_bus(22) = '0' else instr(15 downto 0);

    --Mux SelSrcs (OP1)
    OP1 <=  d1 when control_bus(25 downto 23) = "001" else
            d1 when control_bus(25 downto 23) = "010" else
            d1 when control_bus(25 downto 23) = "011" else
            d4 when control_bus(25 downto 23) = "100" else
            d2 when control_bus(25 downto 23) = "101" else
            d2 when control_bus(25 downto 23) = "101" else
            x"0000";

    -- Mux SelSrcs (OP2)
    OP2 <=  d2 when control_bus(25 downto 23) = "001" else
            d4 when control_bus(25 downto 23) = "010" else
            d5 when control_bus(25 downto 23) = "011" else
          d3_s when control_bus(25 downto 23) = "100" else
            d5 when control_bus(25 downto 23) = "101" else
            d4 when control_bus(25 downto 23) = "110" else
            x"0000";

    D3 <= d3_s;

end architecture;
