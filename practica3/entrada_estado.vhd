library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity entrada_estado is
	Port (
			reloj: in std_logic;
			entradas: in unsigned(1 downto 0); -- Bit menos significativo representa Si, else Sd
			salidas: out unsigned(3 downto 0)
			);
end entity;

architecture Behavioral of entrada_estado is
signal prueba: unsigned(1 downto 0);
signal sv, sf, lf, lv, salidas_mem, registro_mem, selector_liga, selector_salidas: unsigned(3 downto 0);
signal selector_entradas: std_logic;
signal mem_salida : unsigned(17 downto 0);

begin

-- Instancia de la memoria
memoria: entity work.memoria_ee
	port map(
		direccion => to_integer(registro_mem),
		salidas => mem_salida
	);

-- Multiplexor que elige la entrada
mux_entradas: selector_entradas <= entradas(0) when prueba = "00" else
											  entradas(1) when prueba = "01" else
											  '1';
-- Multiplexor que elige entre liga falsa y verdadera
mux_liga: selector_liga <= lf when selector_entradas = '0' else lv;
-- Multiplexor que elige entre salidas verdaderas o falsas
mux_salidas: selector_salidas <= sf when selector_entradas = '0' else sv;

-- Asignaciones de la salida de la memoria
-- Salidas falsa y verdadera
sf <= mem_salida(3 downto 0);
sv <= mem_salida(7 downto 4);
-- Liga falsa y verdadera
lf <= mem_salida(11 downto 8);
lv <= mem_salida(15 downto 12);
-- Prueba
prueba <= mem_salida(17 downto 16);

-- Registro que direcciona la memoria
reg_mem: process(reloj)
begin
	if rising_edge(reloj) then
		registro_mem <= selector_liga;
	end if;
end process;

-- Registro de las salidas
reg_salida: process(reloj)
begin
	if rising_edge(reloj) then
		salidas <= selector_salidas;
	end if;
end process;

end Behavioral;