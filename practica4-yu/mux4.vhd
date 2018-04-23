library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux4 is
	Port (  sel : in STD_LOGIC_VECTOR(1 downto 0);
			  Qx : in STD_LOGIC;
			  X : in STD_LOGIC;
			  Y : in STD_LOGIC;
			  INT : in STD_LOGIC;
			  O  : out STD_LOGIC);
end mux4;

architecture Behavioral of mux4 is
begin
	process (sel, Qx, X, Y, INT)
	begin		
		if sel = "00" then 
			O <= Qx;
		elsif sel = "01" then 
			O <= X;
		elsif sel = "10" then 
			O <= Y;
		elsif sel = "11" then 
			O <= INT;
		end if;
	end process;
end Behavioral;