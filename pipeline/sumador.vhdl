library IEEE;
    use IEEE.std_logic_1164.ALL;
    use IEEE.numeric_std.ALL;

entity sumador is
    port (
        cin, sr: in  std_logic;
        a, b   : in  unsigned (15 downto 0);
        sum    : out unsigned (15 downto 0)
    );
end entity sumador;


architecture arch of sumador is

    signal as   : unsigned (15 downto 0);

begin

    as <= a + ("" & cin) when sr = '1' else a - ("" & not(cin));
    sum <= as + b when sr = '1' else as - b;

end arch;
