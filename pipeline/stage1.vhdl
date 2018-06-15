library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity stage1 is
    port(
        clk, Branch, reset, PCWrite: in std_logic;
        DatoW: in unsigned(15 downto 0);
        PC: out unsigned(15 downto 0);
        instr: out unsigned(31 downto 0)
    );
end stage1;

architecture arch of stage1 is
    signal out_mux : unsigned(15 downto 0);
    signal out_pc : unsigned(15 downto 0) := (others => '0');
    signal out_incr : unsigned(15 downto 0);

 begin
    -- Mux de branch
    out_mux <= out_incr when Branch = '0' else DatoW;

    -- Contador de programa
    process(clk, reset) begin
        if reset = '1' then
            out_pc <= (others => '0');
        else
            if rising_edge(clk) and PCWrite = '1' then
                out_pc <= out_mux;
            end if;
        end if;
    end process;

    -- Memoria de instrucciones
    prog_mem: entity work.ram
    generic map (
        word_size => 32,
        addr_size => 16,
        memory_size => 256,
        memory_file => "ram_file.mif"  -- TODO: create data file
    )
    port map(
        clock    => clk,
        we       => '0', -- no escribimos en esta memoria
        addr     => out_pc,
        data_in  => (others => '0'), -- no escribimos en esta memoria
        data_out => instr
    );

    -- Incrementador
    out_incr <= out_pc + 1;

    PC <= out_incr;

end architecture;
