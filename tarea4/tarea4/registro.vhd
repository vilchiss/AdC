library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity registro is
	Port (  CLK : in STD_LOGIC;
			  RESET : in STD_LOGIC;
			  SEL : in std_logic;
			  DATA_LIGA  : in unsigned(2 downto 0);
			  DATA_MEMO  : in unsigned(2 downto 0);
			  DATA_OUT : out unsigned(2 downto 0)
			  );
			  
end registro;

architecture Behavioral of registro is
signal internal_value : unsigned (2 downto 0) := B"000";
begin
	process (CLK, RESET, DATA_LIGA, DATA_MEMO)
	begin		
		if RESET = '0' then 
			internal_value <= B"000";
		elsif rising_edge (CLK) then				
			if SEL <= '1' then			
				internal_value <= DATA_LIGA;
			else
				internal_value <= DATA_MEMO + 1;
			end if;
		end if;
	end process;
	
	process (internal_value)
	begin
		DATA_OUT <= internal_value;
	end process;
end Behavioral;