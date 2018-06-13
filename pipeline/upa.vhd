-- Descripción de la Unidad de Procesos Aritmética
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity upa is
    port(
	    Acarreo	        : in std_logic;
        SelOp	        : in unsigned(3 downto 0);
	    OP1, OP2        : in unsigned(15 downto 0);
        ResultUPA       : out unsigned(15 downto 0);
        N, Z, V, C, H   : out std_logic
    );
end upa;

architecture arch of upa is
	signal resultado: unsigned(17 downto 0);
begin

	process(all)
	begin
		case SelOP is
			when "0001" =>
				resultado <= ('0' & OP1 & '1') + ('0' & OP2 & Acarreo);
			when "0010" =>
				resultado <= ('0' & OP1 & '0') - ('0' & OP2 & not(Acarreo));
			when "0011" =>
				resultado <= ('0' & OP1 & '0') and ('0' & OP2 & '0');
			when "0100" =>
				resultado <= ('0' & OP1 & '0') or ('0' & OP2 & '0');
			when "0101" => 
				resultado <= ('0' & OP1 & '0') xor ('0' & OP2 & '0');
			when "0110" => 
				resultado <= ('0' & OP1 & '0'); -- corrimiento a la izquierda con 0
			when "0111" =>
				resultado <= ("00" & OP1(15) & OP1(15 downto 1)); -- corrimiento a la derecha con b15
			when "1000" => 
				resultado <= ('0' & OP2 & '0') - ('0' & OP1 & not(Acarreo));
			when "1001" => 
				resultado <= ("000" & OP1(15 downto 1)); -- corrimiento a la derecha con 0
			when "1010" =>
				resultado <= ('0' & OP1(15 downto 0) & Acarreo); -- rotación a la izquierda con b0=Cccr
			when "1011" =>
				resultado <= ("00" & Acarreo & OP1(15 downto 1)); -- rotación a la derecha con b15=Cccr
			when others =>
				resultado <= (others => '0');
		end case;
	end process;
	
	
	ResultUPA <= resultado(16 downto 1);
	
	-- Banderas
	N <= resultado(15);
	Z <= '1' when resultado(16 downto 1) = x"0000" else '0';
	C <= resultado(16);
	H <= resultado(8);
	
	process(OP1, OP2, resultado)
	begin
		if OP1(15) = '1' and OP2(15) = '1' and resultado(15) = '0' then
			V <= '1';
		elsif OP1(15) = '0' and OP2(15) = '0' and resultado(15) = '1'then
			V <= '1';
		else
			V <= '0';
		end if;
	end process;
	
end architecture;
