library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registro4 is
Port ( 
 ENA : in STD_LOGIC;
 RELOJ : in STD_LOGIC;
 RESET : in STD_LOGIC;
 ENTRADA : in STD_LOGIC_VECTOR(3 downto 0);
 SALIDA : out STD_LOGIC_VECTOR(3 downto 0));
end registro4;

architecture Behavioral of registro4 is
signal valor_interno : std_logic_vector (3 downto 0) := B"0000";

begin
process (RELOJ, RESET, ENTRADA)
begin

if RESET = '0' then
valor_interno <= B"0000";
elsif rising_edge (RELOJ) then
valor_interno <= ENTRADA;
end if;
end process;

process (ENA, valor_interno)
begin
if ENA = '0' then
SALIDA <= valor_interno;
elsif ENA = '1' then
SALIDA <= "ZZZZ";
end if;
end process;
end Behavioral;