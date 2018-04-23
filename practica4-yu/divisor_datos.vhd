library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divisor_datos is
	Port ( entrada : in STD_LOGIC_VECTOR (12 downto 0);
			 liga : out STD_LOGIC_VECTOR (3 downto 0);
			 mInst : out STD_LOGIC_VECTOR (1 downto 0);
			 prueba : out STD_LOGIC_VECTOR (1 downto 0);
			 vf : out STD_LOGIC_VECTOR (0 downto 0);			 
			 salida : out STD_LOGIC_VECTOR (3 downto 0));

end divisor_datos;

architecture Behavioral of divisor_datos is
begin
	process(entrada)
	begin
		liga <= entrada(12 downto 9);
		mInst <= entrada(8 downto 7);
		prueba <= entrada(6 downto 5);
		vf <= entrada(4 downto 4);
		salida <= entrada(3 downto 0);
	end process;
end Behavioral;