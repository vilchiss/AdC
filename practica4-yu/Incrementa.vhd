library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Incrementa is
	Port ( 
			  DATA_IN  : in STD_LOGIC_VECTOR(3 downto 0);
			  DATA_OUT : out STD_LOGIC_VECTOR(3 downto 0));
end Incrementa;

architecture Behavioral of Incrementa is
begin
	process (DATA_IN)
	begin		
	
	DATA_OUT<=DATA_IN+1;
	end process;
	
	
end Behavioral;