library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity ram is
    port(
        clock    : in  std_logic;
        we       : in  std_logic;
        addr     : in  unsigned(31 downto 0);
        data_in  : in  unsigned(31 downto 0);
        data_out : out unsigned(31 downto 0)
    );
end entity;

architecture arch of ram is
    -- Definicion de la ram
    subtype   word          is unsigned(31 downto 0);
    type      memory        is array(0 to 255) of word;
    signal    ram           :  memory;
    attribute ram_init_file :  string;
    attribute ram_init_file of ram : signal is "ram_file.mif";

    begin
        ram_write : process(clock) begin
            if rising_edge(clock) then
                if we = '1' then
                    ram(to_integer(addr)) <= data_in;
                end if;
            end if;
        end process;
        data_out <= ram(to_integer(addr));
end arch;
