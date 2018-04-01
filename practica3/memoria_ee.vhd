library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria_ee is

	generic 
	(
		TAM_PALABRA : natural := 18;
		TAM_MEMORIA : natural := 14
	);

	port 
	(
		direccion	: in natural range 0 to 2**TAM_MEMORIA - 1;
		salidas		: out unsigned((TAM_PALABRA -1) downto 0)
	);

end entity;

architecture rtl of memoria_ee is
	subtype palabra_t is unsigned((TAM_PALABRA-1) downto 0);
	type memoria_t is array(TAM_MEMORIA-1 downto 0) of palabra_t;
	
	signal mem : memoria_t := (
		0 =>  "000001001000000000",
		1 =>  "010101001100000000",
		2 =>  "011100000000001000",
		3 =>  "110100010001000100",
		4 =>  "110000000000010001",
		5 =>  "110110011001000100",
		6 =>  "110111011100100010",
		7 =>  "111000100000100010",
		8 =>  "111001100110001000",
		9 =>  "111010101010001000",
		10 => "111011101100010001",
		11 => "110000000000010001",
		12 => "111101110101000100",
		13 => "110000000000100010"
	);
begin
	salidas <= mem(direccion);
end rtl;
