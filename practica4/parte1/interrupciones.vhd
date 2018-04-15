library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interrupciones is
port(
	habilitador, int: in std_logic;
	estado: in unsigned(3 downto 0);
	salida: out unsigned(3 downto 0)
);
end entity;

architecture Behavioral of interrupciones is
	signal s: unsigned(3 downto 0);
begin

salida <= s when habilitador = '1' else "ZZZZ";

s <= "0101" when  (estado = "0100" and int = '0') else
     "0110" when  (estado = "0100" and int = '1') else
	 "1010" when  (estado = "1001" and int = '0') else
	 "1011" when  (estado = "1001" and int = '1') else
	 "1111";
end architecture;
