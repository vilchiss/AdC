library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Reg_Int is
	Port (  CLK : in STD_LOGIC;
			  RESET : in STD_LOGIC;
			  ENA : in STD_LOGIC;
			  INT : STD_LOGIC;
			  SEL: STD_LOGIC;
			  DATA_OUT : out STD_LOGIC_VECTOR(3 downto 0));
end Reg_Int;

architecture Behavioral of Reg_Int is
signal internal_value : std_logic_vector (1 downto 0) := B"00";
begin
	process (CLK, RESET)
	begin		
		if RESET = '0' then 
			internal_value <= B"00";
		elsif rising_edge (CLK) then
			internal_value <= SEL & INT;
		end if;
	end process;
	
	process (ENA, internal_value)
	begin
	
		if ENA = '0' then
			if internal_value = "00" then 
				DATA_OUT <= "0101";
			elsif internal_value = "01" then 
				DATA_OUT <= "0110";
			elsif internal_value = "10" then 
				DATA_OUT <= "1010";
			elsif internal_value = "11" then 
				DATA_OUT <= "1011";
			end if;
		elsif ENA = '1' then
			DATA_OUT <= "ZZZZ";
		end if;
		
	end process;
end Behavioral;