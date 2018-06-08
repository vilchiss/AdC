-- Descripción de la Unidad de Procesos Aritmética

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;


entity upa is
 port(
	Acarreo	: in std_logic;
	SelOp	: in unsigned(3 downto 0);
	OP1, OP2 : in signed(15 downto 0);
	ResultUPA: out signed(15 downto 0);
	N, Z, V, C, H : out std_logic
 );
end upa;

architecture arch of upa is
	signal op_1, op_2, acarreo_ext, acarreo_ext_neg, resultado: signed(16 downto 0);
	signal r: std_logic_vector(16 downto 0);  -- Para usar las funciones x_reduce
begin
 
	op_1 <= '0'&OP1;
	op_2 <= '0'&OP2;
	-- TODO: buscar mejor forma de sumar y restar el acarreo
	acarreo_ext <= "0000000000000000"&Acarreo;
	acarreo_ext_neg <= "0000000000000000"&not(Acarreo);
	
	process(SelOP, op_1, op_2, Acarreo)
	begin
		case SelOP is
			when "0001" =>
				resultado <= op_1 + op_2 + acarreo_ext;
			when "0010" =>
				resultado <= op_1 - op_2 - acarreo_ext_neg;
			when "0011" =>
				resultado <= op_1 and op_2;
			when "0100" =>
				resultado <= op_1 or op_2;
			when "0101" => 
				resultado <= op_1 xor op_2;
			when "0110" => 
				resultado <= op_1(15 downto 0)&'0'; -- corrimiento a la izquierda con 0
			when "0111" =>
				resultado <= '0'&op_1(15)&op_1(15 downto 1); -- corrimiento a la derecha con b15
			when "1000" => 
				resultado <= op_2 - op_1 - acarreo_ext_neg;
			when "1001" => 
				resultado <= "00"&op_1(15 downto 1); -- corrimiento a la derecha con 0
			when "1010" =>
				resultado <= op_1(15 downto 0)&Acarreo; -- rotación a la izquierda con b0=Cccr
			when "1011" =>
				resultado <= '0'&Acarreo&op_1(15 downto 1); -- rotación a la derecha con b15=Cccr
			when others =>
				null;
		end case;
	end process;
	
	
	ResultUPA <= resultado(15 downto 0);
	r <= std_logic_vector(resultado);
	
	-- Banderas
	N <= resultado(15);
	Z <= nor_reduce(r(15 downto 0));
	C <= resultado(16);
	H <= resultado(8);
	
	process(OP1, OP2, resultado)
	begin
		if OP1(15) = '1' and OP2(15) = '1' and resultado(15) = '0' then
			V <= '1';
		elsif OP1(15) = '0' and OP2(15) = '0' and resultado(15) = '1'then
			V <= '1';
		else
			V <= '0';
		end if;
	end process;
	
end architecture;