library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity memoria_programa is
	Port( dir : in std_logic_vector(15 downto 0);
			data_in : in std_logic_vector(7 downto 0);
			nRW : in std_logic;
			data_out : out std_logic_vector(7 downto 0);
			data_out_X0 : out std_logic_vector(7 downto 0);
			data_out_X1 : out std_logic_vector(7 downto 0);
			data_out_X2 : out std_logic_vector(7 downto 0);
			data_out_P7 : out std_logic_vector(7 downto 0);
			data_out_P8 : out std_logic_vector(7 downto 0);
			data_out_P9 : out std_logic_vector(7 downto 0);
			data_out_P10 : out std_logic_vector(7 downto 0);
			data_out_P11 : out std_logic_vector(7 downto 0);
			data_out_P12 : out std_logic_vector(7 downto 0);
			data_out_P13 : out std_logic_vector(7 downto 0);
			data_out_P14 : out std_logic_vector(7 downto 0);
			data_out_P15 : out std_logic_vector(7 downto 0)
			);
end memoria_programa;

architecture Behavioral of memoria_programa is
	type memory is array(0 to 255) of std_logic_vector(7 downto 0);
	signal memoria : memory;
	
	-- La pila empieza en la última posición de la memoria 255 = FF, entonces la direccion es 00FF
	-- El tamaño de la pila es de 16 bytes (arbitrario)
	-- La pila termina en EF
	begin
		process(dir,nRW)
			begin
			
			-- Programa HARDCODE PRUEBAS
			memoria(20) <= X"86"; -- LDAA
			memoria(21) <= X"FF"; 
			memoria(22) <= X"C6"; -- LDAB
			memoria(23) <= X"01";
			memoria(24) <= X"CE"; -- LDX
			memoria(25) <= X"00";
			memoria(26) <= X"10";
			memoria(27) <= X"1B"; -- ABA
			memoria(28) <= X"26"; -- BNE
			memoria(29) <= X"04";
			memoria(30) <= X"A7"; -- STAA
			memoria(31) <= X"00";
			memoria(32) <= X"20"; -- BRA
			memoria(33) <= X"02";
			memoria(34) <= X"E7"; -- STAB  -- ET1
			memoria(35) <= X"00";
			memoria(36) <= X"86"; -- LDAA  -- ET2
			memoria(37) <= X"07"; 
			memoria(38) <= X"C6"; -- LDAB
			memoria(39) <= X"02";
			memoria(40) <= X"3D"; -- MUL
			memoria(41) <= X"A7"; -- STAA
			memoria(42) <= X"01";
			memoria(43) <= X"E7"; -- STAB
			memoria(44) <= X"02";
			memoria(45) <= X"20"; -- BRA  -- FIN
			memoria(46) <= X"FE";
			
			-- DRIVERS DE INTERRUPCIONES
			-- Driver X Externo (0064 H)
			memoria(100) <= X"CE"; -- LDX
			memoria(101) <= X"00";
			memoria(102) <= X"20";
			memoria(103) <= X"B6"; -- LDAA Dir_6_bits
			memoria(104) <= X"00";
			memoria(105) <= X"30";
			memoria(106) <= X"A7"; -- STAA
			memoria(107) <= X"00";
			memoria(108) <= X"3B"; -- RTI
			
			-- Driver Y Interno (006D H)
			memoria(109) <= X"CE"; -- LDX
			memoria(110) <= X"00";
			memoria(111) <= X"30";
			memoria(112) <= X"F6"; -- LDAB Dir_6_bits
			memoria(113) <= X"00";
			memoria(114) <= X"20";
			memoria(115) <= X"E7"; -- STAB
			memoria(116) <= X"00";
			memoria(117) <= X"3B"; -- RTI
			
			--FUNCION DE LA MEMORIA
			if(nRW = '0') then -- Modo escritura
				memoria(conv_integer(unsigned(dir))) <= data_in;
			else -- Modo lectura
				data_out <= memoria(conv_integer(unsigned(dir)));
			end if;
			
			-- DEBUG
			data_out_X0 <= memoria(16);  -- X"0010"
			data_out_X1 <= memoria(17);  -- X"0010" + 1
			data_out_X2 <= memoria(18);  -- X"0010" + 2
			
			-- PILA
			data_out_P7 <= memoria(247);
			data_out_P8 <= memoria(248);
			data_out_P9 <= memoria(249);
			data_out_P10 <= memoria(250);
			data_out_P11 <= memoria(251);
			data_out_P12 <= memoria(252);
			data_out_P13 <= memoria(253);
			data_out_P14 <= memoria(254);
			data_out_P15 <= memoria(255);
		end process;
end Behavioral;
