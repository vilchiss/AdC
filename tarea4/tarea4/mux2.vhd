library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2 is
	Port (  sel : in STD_LOGIC;
			  SI : in STD_LOGIC_VECTOR(4 downto 0);
			  SC : in STD_LOGIC_VECTOR(4 downto 0);
			  O : out STD_LOGIC_VECTOR(4 downto 0));
end mux2;

architecture Behavioral of mux2 is
begin
	process (sel, SI, SC)
	begin		
		if sel = '0' then 
			O <= SI;
		elsif sel = '1' then 
			O <= SC;
		end if;
	end process;
end Behavioral;