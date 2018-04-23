library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logint is
	Port ( Instruccion : in STD_LOGIC_VECTOR (1 downto 0);
			 CC : in STD_LOGIC;
			 Selector : out STD_LOGIC;
			 PL : out STD_LOGIC;			 
			 MAP0 : out STD_LOGIC;
			 VECT : out STD_LOGIC);
end logint;

architecture Behavioral of logint is
begin
process(Instruccion,CC)
	begin
	
		if Instruccion = "00" and CC = '0' then		
				Selector <= '0';
				PL 		<= '1';
				MAP0 		<= '1';
				VECT		<= '1';
		
		elsif Instruccion = "00" and CC = '1' then	
				Selector <= '0';
				PL 		<= '1';
				MAP0 		<= '1';
				VECT		<= '1';

		elsif Instruccion = "01" and CC = '0' then
				Selector <= '1';
				PL 		<= '0';
				MAP0 		<= '1';
				VECT		<= '1';
				
		elsif Instruccion = "01" and CC = '1' then	
				Selector <= '0';
				PL 		<= '0';
				MAP0 		<= '1';
				VECT		<= '1';
--
				
		elsif Instruccion = "10" and CC = '0' then	
				Selector <= '1';
				PL 		<= '1';
				MAP0 		<= '0';
				VECT		<= '1';
		
		elsif Instruccion = "10" and CC = '1' then
				Selector <= '1';
				PL 		<= '1';
				MAP0 		<= '0';
				VECT		<= '1';
				
		elsif Instruccion = "11" and CC = '0' then	
				Selector <= '1';
				PL 		<= '1';
				MAP0 		<= '1';
				VECT		<= '0';
				
		elsif Instruccion = "11" and CC = '1' then	
				Selector <= '0';
				PL 		<= '1';
				MAP0 		<= '1';
				VECT		<= '0';
		
		end if;
	end process;
	
end Behavioral;