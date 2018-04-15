library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina is 
port(
	reloj: in std_logic;
	entradas: in unsigned(1 downto 0); -- LSB -> X else Y
	sel_trans:in unsigned(1 downto 0); -- Selecciona el salto en transformación
	salidas: out unsigned(3 downto 0);
	mem_out: out unsigned(12 downto 0);
	y_debug: out unsigned(3 downto 0)
);
end entity;

architecture Behavioral of maquina is
	signal liga, d, y: unsigned(3 downto 0);
	signal vect, map_out, pl, cc, vf, entrada: std_logic;
	signal prueba, instruccion: unsigned(1 downto 0);
	signal mem_salida: unsigned(12 downto 0);
begin

-- Asginación de las señales de la salida de la memoria
-- si pl esta desactivado se mandan a alta impedancia
liga <= mem_salida(12 downto 9) when pl = '0' else "ZZZZ" ;
instruccion <= mem_salida(8 downto 7);
prueba <= mem_salida(6 downto 5);
vf <= mem_salida(4) when pl = '0';
salidas <= mem_salida(3 downto 0);

memoria: entity work.rom
port map(
	cs => '1',
	addr => y,
	data_out => mem_salida
);

mem_out <= mem_salida;
y_debug <= y;
registro_inter: entity work.interrupciones
port map(
	habilitador => vect,
	int => cc,
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
cc <= entrada xor vf;
entrada <= entradas(0) when prueba = "01" else
	entradas(1) when prueba = "10" else
	'0';
	
end Behavioral;