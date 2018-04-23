library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg2 is
	Port (  CLK : in STD_LOGIC;
			  RESET : in STD_LOGIC;
			  DATA_IN  : in STD_LOGIC_VECTOR(1 downto 0);
			  DATA_OUT : out STD_LOGIC_VECTOR(1 downto 0));
end reg2;

architecture Behavioral of reg2 is
signal internal_value : std_logic_vector (1 downto 0) := B"00";
begin
	process (CLK, RESET, DATA_IN)
	begin		
		if RESET = '0' then 
			internal_value <= B"00";
		elsif rising_edge (CLK) then
			internal_value <= DATA_IN;
		end if;
	end process;
	
	process (internal_value)
	begin
		DATA_OUT <= internal_value;
	end process;
end Behavioral;