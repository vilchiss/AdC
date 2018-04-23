library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity memory is
	Port( dir : in std_logic_vector(3 downto 0);
			data : out std_logic_vector(12 downto 0)
			);
end memory;

architecture Behavioral of memory is
	type mem is array(0 to 63) of std_logic_vector(12 downto 0);
	signal internal_mem : mem;
	
	begin
	--0000
		internal_mem(conv_integer(unsigned'("0000"))) <= "0000000001100";
	--0001
		internal_mem(conv_integer(unsigned'("0001"))) <= "0000000000110";		
	--0010
		internal_mem(conv_integer(unsigned'("0010"))) <= "0000100000001";
	--0011
		internal_mem(conv_integer(unsigned'("0011"))) <= "0011010100010";
	--0100
		internal_mem(conv_integer(unsigned'("0100"))) <= "0000111111000";
	--0101
		internal_mem(conv_integer(unsigned'("0101"))) <= "0001010001100";
	--0110
		internal_mem(conv_integer(unsigned'("0110"))) <= "0000000000011";
	--0111
		internal_mem(conv_integer(unsigned'("0111"))) <= "0000010000001";
	--
		internal_mem(conv_integer(unsigned'("1000"))) <= "0000000001000";
	--
		internal_mem(conv_integer(unsigned'("1001"))) <= "0000111110000";
	--	
		internal_mem(conv_integer(unsigned'("1010"))) <= "0001010001100";
	--	
		internal_mem(conv_integer(unsigned'("1011"))) <= "0000000000101";
	--	
		internal_mem(conv_integer(unsigned'("1100"))) <= "0000010000001";
	--	
		internal_mem(conv_integer(unsigned'("1101"))) <= "1101011010010";
	--	
		internal_mem(conv_integer(unsigned'("1110"))) <= "1001010000000";
	--	
		--internal_mem(conv_integer(unsigned'("1111"))) <= "100000010001000";
		
		process(dir)
			begin
				data <= internal_mem(conv_integer(unsigned(dir)));
		end process;
end Behavioral;