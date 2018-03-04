library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sensa_boton is
    Port ( boton : in  STD_LOGIC;
			  clk : in  STD_LOGIC; reloj : out  STD_LOGIC; epresente:  buffer  STD_LOGIC);		
end sensa_boton;

architecture Behavioral of sensa_boton is
signal esiguiente: STD_LOGIC;
begin
	process (esiguiente,boton)
		begin
			if rising_edge (clk)  then
				case esiguiente is
					when '0'=> 
						reloj <= '0'; 
						if   boton ='0' then
							esiguiente <= '0';
						else
							esiguiente <= '1';
						end if;
					when '1'=> 
						if  boton ='1' then 
							esiguiente <= '1'; 
							reloj <= '0';
						else 
							esiguiente <= '0'; 
							reloj <= '1';
						end if;
					when others=> 
						null;
				end case;
			end if;
		epresente <= esiguiente;
	end process;
 end Behavioral;