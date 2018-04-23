library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux2_4 is
	Port (  sel : in STD_LOGIC;
			  mPC : in STD_LOGIC_VECTOR(3 downto 0);
			  D : in STD_LOGIC_VECTOR(3 downto 0);
			  O : out STD_LOGIC_VECTOR(3 downto 0));
end mux2_4;

architecture Behavioral of mux2_4 is
begin
	process (sel, mPC, D)
	begin		
		if sel = '0' then 
			O <= mPC;
		elsif sel = '1' then 
			O <= D;
		end if;
	end process;
end Behavioral;