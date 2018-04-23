library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Reg_Trans is
	Port (  CLK : in STD_LOGIC;
			  RESET : in STD_LOGIC;
			  ENA : in STD_LOGIC;
			  DATA_IN  : in STD_LOGIC_VECTOR(1 downto 0);
			  DATA_OUT : out STD_LOGIC_VECTOR(3 downto 0));
end Reg_Trans;

architecture Behavioral of Reg_Trans is
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
	
	process (ENA, internal_value)
	begin
	
		if ENA = '0' then
			if internal_value = "00" then 
				DATA_OUT <= "0011";
			elsif internal_value = "01" then 
				DATA_OUT <= "1000";
			elsif internal_value = "10" then 
				DATA_OUT <= "1101";
			elsif internal_value = "11" then 
				DATA_OUT <= "0011";
			end if;
		elsif ENA = '1' then
			DATA_OUT <= "ZZZZ";
		end if;
		
	end process;
end Behavioral;