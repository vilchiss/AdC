library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity memoria is
	Port( dir : in std_logic_vector(2 downto 0);
			data : out std_logic_vector(15 downto 0)
			);
end memoria;

architecture arch of memoria is
	type mem is array(0 to 7) of std_logic_vector(15 downto 0);
	signal internal_mem : mem;
	
	begin
		internal_mem(0) <= "0110100100001100";
		internal_mem(1) <= "1110111001110011";
		internal_mem(2) <= "0011000100100001";
		internal_mem(3) <= "1000010100101000";
		internal_mem(4) <= "1110000001100011";
		
		
		process(dir)
			begin
				data <= internal_mem(conv_integer(unsigned(dir)));
		end process;
end architecture;
