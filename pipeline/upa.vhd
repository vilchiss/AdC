-- Descripción de la Unidad de Procesos Aritmética

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;


entity upa is
 port(
	Acarreo	: in std_logic;
	SelOp	: in unsigned(3 downto 0);
	OP1, OP2 : in unsigned(15 downto 0);
	ResultUPA: out unsigned(15 downto 0);
	N, Z, V, C, H : out std_logic
 );
end upa;

architecture arch of upa is
	signal op_1_suma_l, op_1_resta_l, op_1_resta_r, op_2_suma_l, op_2_resta, resultado: signed(17 downto 0);
	signal r: std_logic_vector(16 downto 0);  -- Para usar las funciones x_reduce
begin
 
	op_1_suma_l <= signed(OP1(15) & OP1 & '1');
	op_1_resta_l <= signed(OP1(15) & OP1 & '0');
	op_1_resta_r <= signed(OP1(15) & OP1 & '0');
	op_2_suma_l <= signed(OP2(15) & OP2 & Acarreo);
	op_2_resta <= signed(OP2(15) & OP2 & not(Acarreo));

	process(SelOP, op_1_suma_l, op_2_suma_l, Acarreo)
	begin
		case SelOP is
			when "0001" =>
				resultado <= op_1_suma_l + op_2_suma_l;
			when "0010" =>
				resultado <= op_1_resta_r - op_2_resta;
			when "0011" =>
				resultado <= op_1_suma_l and op_2_suma_l;
			when "0100" =>
				resultado <= op_1_suma_l or op_2_suma_l;
			when "0101" => 
				resultado <= op_1_suma_l xor op_2_suma_l;
			when "0110" => 
				resultado <= op_1_suma_l(17 downto 2) & "00"; -- corrimiento a la izquierda con 0
			when "0111" =>
				resultado <= "000" & op_1_suma_l(15) & op_1_suma_l(15 downto 2); -- corrimiento a la derecha con b15
			when "1000" => 
				resultado <= op_2_suma_l - op_1_suma_l;
			when "1001" => 
				resultado <= "000"&op_1_suma_l(15 downto 1); -- corrimiento a la derecha con 0
			when "1010" =>
				resultado <= '0'&op_1_suma_l(15 downto 0)&Acarreo; -- rotación a la izquierda con b0=Cccr
			when "1011" =>
				resultado <= "00"&Acarreo&op_1_suma_l(15 downto 1); -- rotación a la derecha con b15=Cccr
			when others =>
				null;
		end case;
	end process;
	
	
	ResultUPA <= unsigned(resultado(15 downto 0));
	r <= std_logic_vector(resultado(16 downto 0));
	
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