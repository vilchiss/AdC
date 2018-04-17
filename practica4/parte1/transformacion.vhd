library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transformacion is
port(
	habilitador: in std_logic;
	valor: in unsigned(1 downto 0);
	salida: out unsigned(3 downto 0)
);
end entity;

architecture Behavioral of transformacion is
	signal s: unsigned(3 downto 0);
begin

salida <= s when habilitador = '0' else "ZZZZ";

s <= "0011" when  valor = "00" else
	"1000" when  valor = "01" else
	"1101" when  valor = "10" else
	"1111";
end architecture;