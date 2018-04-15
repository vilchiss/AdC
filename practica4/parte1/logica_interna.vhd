library ieee;

use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity logica_interna is
	Port(
		instruccion: in unsigned(1 downto 0);
		cc: in std_logic;
		selector: out std_logic;
		pl: out std_logic;
		map_out: out std_logic;
		vect : out std_logic
	);
end entity;


architecture Behavioral of logica_interna is
begin
	selector <= (not(instruccion(0)) and instruccion(1)) or (instruccion(0) and not(cc));
	pl       <= instruccion(1) or not(instruccion(0));
	map_out  <= instruccion(0) or not(instruccion(1));
	vect     <= not(instruccion(0) and instruccion(1));
end Behavioral;