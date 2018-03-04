library IEEE;
use iEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity carta_asm_2 is

	Port( RELOJ: in STD_LOGIC;
			RESET: in STD_LOGIC;
			S: in std_logic_vector(1 downto 0); --Donde el bit más significativo es Si y el menos significativo es Sd
			atras: out STD_LOGIC;
			adelante: out STD_LOGIC;
			giro_der: out STD_LOGIC;
			giro_izq: out STD_LOGIC;
			out_epresente: out std_logic_vector(3 downto 0));
			
end carta_asm_2;

architecture Behavioral of carta_asm_2 is

signal esiguiente: std_logic_vector(3 downto 0):=B"0000";

constant s0:  std_logic_vector(3 downto 0):=X"0";
constant s1:  std_logic_vector(3 downto 0):=X"1";
constant s2:  std_logic_vector(3 downto 0):=X"2";
constant s3:  std_logic_vector(3 downto 0):=X"3";
constant s4:  std_logic_vector(3 downto 0):=X"4";
constant s5:  std_logic_vector(3 downto 0):=X"5";
constant s6:  std_logic_vector(3 downto 0):=X"6";
constant s7:  std_logic_vector(3 downto 0):=X"7";
constant s8:  std_logic_vector(3 downto 0):=X"8";
constant s9:  std_logic_vector(3 downto 0):=X"9";
constant s10:  std_logic_vector(3 downto 0):=X"A";
constant s11:  std_logic_vector(3 downto 0):=X"B";

begin


process(RELOJ, reset, esiguiente, S)
begin
	if reset='0' then esiguiente <= s0;
	elsif rising_edge(RELOJ) then
		case esiguiente is
			when s0 =>
				atras <= '0';
				giro_izq <= '0';
				giro_der <= '0';
				if S=X"0" then
					adelante <= '1';
					esiguiente <= s0;
				elsif S=X"1" then
					esiguiente <= s1;
					adelante <= '0';
				elsif S=X"2" then
					esiguiente <= s3;
					adelante <= '0';
				elsif S=X"3" then
					esiguiente <= s5;
					adelante <= '0';
				end if;
			when s1 =>
				adelante <= '0';
				atras <= '1';
				giro_izq <= '0';
				giro_der <= '0';
				esiguiente <= s2;
			when s2 =>
				adelante <= '0';
				atras <= '0';
				giro_izq <= '1';
				giro_der <= '0';
				esiguiente <= s0;
			when s3 =>
				adelante <= '0';
				atras <= '1';
				giro_izq <= '0';
				giro_der <= '0';
				esiguiente <= s4;
			when s4 =>
				adelante <= '0';
				atras <= '0';
				giro_izq <= '0';
				giro_der <= '1';
				esiguiente <= s0;
			when s5 =>
				adelante <= '0';
				atras <= '1';
				giro_izq <= '0';
				giro_der <= '0';
				esiguiente <= s6;
			when s6 =>
				adelante <= '0';
				atras <= '0';
				giro_izq <= '1';
				giro_der <= '0';
				esiguiente <= s7;
			when s7 =>
				adelante <= '0';
				atras <= '0';
				giro_izq <= '1';
				giro_der <= '0';
				esiguiente <= s8;
			when s8 =>
				adelante <= '1';
				atras <= '0';
				giro_izq <= '0';
				giro_der <= '0';
				esiguiente <= s9;
			when s9 =>
				adelante <= '1';
				atras <= '0';
				giro_izq <= '0';
				giro_der <= '0';
				esiguiente <= s10;
			when s10 =>
				adelante <= '0';
				atras <= '0';
				giro_izq <= '0';
				giro_der <= '1';
				esiguiente <= s11;	
			when s11 =>
				adelante <= '0';
				atras <= '0';
				giro_izq <= '0';
				giro_der <= '1';
				esiguiente <= s0;
			when others => null;
		end case;
		out_epresente <= esiguiente;
	end if;
end process;

end Behavioral;