library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina is 
port(
	reloj: in std_logic;
	entradas: in unsigned(2 downto 0); -- LSB -> X else Y
	sel_trans:in unsigned(1 downto 0); -- Selecciona el salto en transformación
	salidas: out unsigned(3 downto 0);
	estado: out unsigned(3 downto 0)
);
end entity;

architecture Behavioral of maquina is
	signal liga, d, y: unsigned(3 downto 0);
	signal vect, map_out, pl, cc, vf, entrada: std_logic;
	signal prueba, instruccion: unsigned(1 downto 0);
	signal mem_salida: unsigned(12 downto 0);
begin

estado <= y;

reg_liga: process(reloj, pl)
begin
	if rising_edge(reloj) then
		if pl = '0' then
			liga <= mem_salida(12 downto 9);
		else
			liga <= "ZZZZ";
		end if;
	end if;
end process;

reg_instruccion: process(reloj)
begin
	if rising_edge(reloj) then
		instruccion <= mem_salida(8 downto 7);
	end if;
end process;

reg_prueba: process(reloj)
begin
	if rising_edge(reloj) then
		prueba <= mem_salida(6 downto 5);
	end if;
end process;

reg_vf: process(reloj)
begin
	if rising_edge(reloj) then
		vf <= mem_salida(4);
	end if;
end process;

reg_salidas: process(reloj)
begin
	if rising_edge(reloj) then
		salidas <= mem_salida(3 downto 0);
	end if;
end process;


memoria: entity work.rom
port map(
	cs => '1',
	addr => y,
	data_out => mem_salida
);

registro_inter: entity work.interrupciones
port map(
	habilitador => vect,
	int => entrada,
	estado => liga,
	salida => d
);

registro_trans: entity work.transformacion
port map(
	habilitador => map_out,
	valor => sel_trans,
	salida => d
);

secuenciador: entity work.secuenciador1
port map(
	reset => '0',
	reloj => reloj,
	d => d,
	inst => instruccion,
	cc => cc,
	y => y,
	map_out => map_out,
	vect => vect,
	pl => pl
);

d <= liga;
cc <= entrada xnor vf;
entrada <= entradas(0) when prueba = "01" else
	entradas(1) when prueba = "10" else
	entradas(2) when prueba = "11" else
	'0';
	
end Behavioral;