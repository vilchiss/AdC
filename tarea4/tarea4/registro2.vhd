library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity registro2 is
	Port (  CLK : in STD_LOGIC;
			  RESET : in STD_LOGIC;			  
			  DATA_IN  : in unsigned(4 downto 0);			  
			  DATA_OUT : out unsigned(4 downto 0)
			  );
			  
end registro2;

architecture Behavioral of registro2 is
signal internal_value : unsigned (4 downto 0) := B"00000";
begin
	process (CLK, RESET, DATA_IN)
	begin		
		if RESET = '0' then 
			internal_value <= B"00000";
		elsif rising_edge (CLK) then							
				internal_value <= DATA_IN;
		end if;
	end process;
	
	process (internal_value)
	begin
		DATA_OUT <= internal_value;
	end process;
end Behavioral;