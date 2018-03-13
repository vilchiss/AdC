library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4 is
	Port (  sel : in STD_LOGIC_VECTOR(1 downto 0);
			  A : in STD_LOGIC;
			  B : in STD_LOGIC;
			  C : in STD_LOGIC;
			  AUX : in STD_LOGIC;
			  O  : out STD_LOGIC);
end mux4;

architecture Behavioral of mux4 is
begin
	process (sel, A, B, C, AUX)
	begin		
		if sel = "00" then 
			O <= A;
		elsif sel = "01" then 
			O <= B;
		elsif sel = "10" then 
			O <= C;
		elsif sel = "11" then 
			O <= AUX;
		end if;
	end process;
end Behavioral;