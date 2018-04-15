library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity secuenciador1 is

port(
	reset: in std_logic;
	reloj: in std_logic;
	d: in unsigned(3 downto 0);
	inst: in unsigned(1 downto 0);
	cc: in std_logic;
	y: out unsigned(3 downto 0);
	map_out: out std_logic;
	vect: out std_logic;
	pl: out std_logic
);
end entity;

architecture Behavioral of secuenciador1 is
	signal incremento, registro_salida: unsigned(3 downto 0);
	signal selector: std_logic;
	signal salida: unsigned(3 downto 0);
begin

-- Registro uPC
registro_upc: process(reloj)
begin
	if rising_edge(reloj) then
		registro_salida <= incremento;
	end if;
end process;

-- Multiplexor que elige entre D o incremento
salida <= registro_salida when selector = '0' else d;

-- Asignación de la salida y
y <= salida;

-- Incrementador
incremento <= salida + 1;

-- Lógica interna
logica: entity work.logica_interna
port map(
		instruccion => inst,
		cc => cc,
		selector => selector,
		pl => pl,
		map_out => map_out,
		vect => vect
);

end Behavioral;