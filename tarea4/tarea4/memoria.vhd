library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity memoria is
	Port( dir : in unsigned(2 downto 0);			
			prueba: out unsigned(1 downto 0);
			vf: out std_logic;
			liga: out unsigned(2 downto 0);
			salida_i: out unsigned(4 downto 0);
			salida_c: out unsigned(4 downto 0)
			);
end memoria;

architecture arch of memoria is
	type mem is array(0 to 7) of unsigned(15 downto 0);
	signal internal_mem : mem;
	
	begin
		internal_mem(0) <= "0110100100001100";
		internal_mem(1) <= "1110111001110011";
		internal_mem(2) <= "0011000100100001";
		internal_mem(3) <= "1000010100101000";
		internal_mem(4) <= "1110000001100011";
		
		
		process(dir)
			begin
				salida_c <= internal_mem(conv_integer(unsigned(dir)))(4 downto 0);
				salida_i <= internal_mem(conv_integer(unsigned(dir)))(9 downto 5);
				liga <= internal_mem(conv_integer(unsigned(dir)))(12 downto 10);
				vf <= internal_mem(conv_integer(unsigned(dir)))(13);
				prueba <= internal_mem(conv_integer(unsigned(dir)))(15 downto 14);
		end process;
end architecture;
