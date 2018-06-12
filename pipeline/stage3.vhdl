library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage3 is
 port(
	clk, reset		:	in std_logic;
	ControlBusIn	:	in unsigned(33 downto 0);
	OP1, OP2, D3 	:	in signed(15 downto 0);
	Branch 			:	out std_logic;
	DirW, DatoW 	:	out unsigned(15 downto 0);
	Banderas			:	out unsigned(5 downto 0);
	ControlBusOut	:	out unsigned(33 downto 0)
 );
end stage3;

architecture arch of stage3 is
	-- Señales para obtener del bus de control las entradas de esta etapa
	signal sel_op, sel_flags	:	unsigned(3 downto 0);
	signal sel_result	:	unsigned(1 downto 0);
	signal sel_branch	:	unsigned(2 downto 0);
	signal vf, sel_c, c_adj, c_ccr	:	std_logic;
	signal bus_control	:	unsigned(31 downto 0);
	
	-- Señales internas
	signal acarreo	:	std_logic;
	signal flags_upa, flags_generador, flags_ccr	:	unsigned(5 downto 0);
	signal resultado_upa	:	signed(15 downto 0);
	
	begin
	
sel_op <= control_bus(19 downto 16);
sel_flags <= control_bus(11 downto 8);	
sel_result <= control_bus(15 downto 14);
sel_branch <= control_bus(7 downto 5);
vf <= control_bus(4);
sel_c <= control_bus(13);
c_adj <= control_bus(12);

c_ccr <= flags_ccr(3); -- TODO
	
	-- Muxes
acarreo <= c_adj when sel_c = '1' else c_ccr;

DatoW <= X"0000" when sel_result = "00" else 
			resultado_upa when sel_result = "01" else
			OP2 when sel_result = "10" else
			OP1 when sel_result = "11";

DirW <= X"0000" when sel_result = "00" else 
			D3 when "01" else
			D3 when "10" else
			D3 when "11";
			
	-- Registro
registro_ccr: process(clk)
	begin
		if rising_edge(clk) then
			flags_ccr <= flags_generador;
		end if;
end process;

	-- Módulos
generador_banderas: process(sel_flags, flags_upa)
	begin
		case sel_flags is
			when "0001" =>
				flags_generador(0) <= flags_upa(0); -- N
				flags_generador(1) <= flags_upa(1); -- Z
				flags_generador(2) <= '0'; -- V
				flags_generador(3) <= flags_ccr(3);
				flags_generador(4) <= flags_ccr(4);
				flags_generador(5) <= flags_ccr(5);
			when "0010" =>
				flags_generador(0) <= flags_upa(0); -- N
				flags_generador(1) <= flags_upa(1); -- Z
				flags_generador(2) <= flags_upa(2); -- V
				flags_generador(3) <= flags_upa(3); -- C
				flags_generador(4) <= flags_upa(4); -- H
				flags_generador(5) <= flags_ccr(5); 
			when "0011" =>
				flags_generador(0) <= flags_upa(0); -- N
				flags_generador(1) <= flags_upa(1); -- Z
				flags_generador(2) <= flags_upa(2); -- V
				flags_generador(3) <= flags_upa(3); -- C
				flags_generador(4) <= flags_ccr(4);
				flags_generador(5) <= flags_ccr(5);
			when "0100" =>
				flags_generador(1) <= flags_upa(1); -- Z
				flags_generador(0) <= flags_ccr(0);
				flags_generador(2) <= flags_ccr(2);
				flags_generador(3) <= flags_ccr(3);
				flags_generador(4) <= flags_ccr(4);
				flags_generador(5) <= flags_ccr(5);
			when "0101" =>
				flags_generador(3) <= '0'; -- C
				flags_generador(0) <= flags_ccr(0);
				flags_generador(1) <= flags_ccr(1);
				flags_generador(2) <= flags_ccr(2);
				flags_generador(4) <= flags_ccr(4);
				flags_generador(5) <= flags_ccr(5);
			when "0110" =>
				flags_generador(5) <= '0'; -- I
				flags_generador(0) <= flags_ccr(0);
				flags_generador(1) <= flags_ccr(1);
				flags_generador(2) <= flags_ccr(2);
				flags_generador(3) <= flags_ccr(3);
				flags_generador(4) <= flags_ccr(4);
			when "0111" =>
				flags_generador(2) <= '0'; -- V
				flags_generador(0) <= flags_ccr(0);
				flags_generador(1) <= flags_ccr(1);
				flags_generador(3) <= flags_ccr(3);
				flags_generador(4) <= flags_ccr(4);
				flags_generador(5) <= flags_ccr(5);
			when "1000" =>
				flags_generador(3) <= '1'; -- C
				flags_generador(0) <= flags_ccr(0);
				flags_generador(1) <= flags_ccr(1);
				flags_generador(2) <= flags_ccr(2);
				flags_generador(4) <= flags_ccr(4);
				flags_generador(5) <= flags_ccr(5);
			when "1001" =>
				flags_generador(5) <= '1'; -- I
				flags_generador(0) <= flags_ccr(0);
				flags_generador(1) <= flags_ccr(1);
				flags_generador(2) <= flags_ccr(2);
				flags_generador(3) <= flags_ccr(3);
				flags_generador(4) <= flags_ccr(4);
			when "1010" =>
				flags_generador(2) <= '1'; -- V
				flags_generador(0) <= flags_ccr(0);
				flags_generador(1) <= flags_ccr(1);
				flags_generador(3) <= flags_ccr(3);
				flags_generador(4) <= flags_ccr(4);
				flags_generador(5) <= flags_ccr(5);
			when "1011" =>
				flags_generador(0) <= flags_upa(0); -- N
				flags_generador(1) <= flags_upa(1); -- Z
				flags_generador(2) <= '0'; -- V
				flags_generador(3) <= '1'; -- C
				flags_generador(4) <= flags_ccr(4);
				flags_generador(5) <= flags_ccr(5);
			when "1100" =>
				flags_generador(0) <= flags_upa(0); -- N
				flags_generador(1) <= flags_upa(1); -- Z
				flags_generador(2) <= flags_upa(2); -- V
				flags_generador(3) <= flags_ccr(3);
				flags_generador(4) <= flags_ccr(4);
				flags_generador(5) <= flags_ccr(5);
			when others =>
				flags_generador <= flags_ccr;
		end case;
end process;

modulo_branch: process(vf, sel_branch, flags_ccr)
	begin
		case sel_branch is
			when "000" =>
				Branch <= VF xor '0';
			when "001" =>
				Branch <= VF xor flags_ccr(3); -- C
			when "010" =>
				Branch <= VF xor flags_ccr(1); -- Z
			when "011" =>
				Branch <= VF xor (flags_ccr(0) xor flags_ccr(2)); -- N xor V
			when "100" =>
				Branch <= VF xor (flags_ccr(1) or (flags_ccr(0) xor flags_ccr(2))); -- Z + (N xor V)
			when "101" =>
				Branch <= VF xor (flags_ccr(3) or flags_ccr(1)); -- C + Z
			when "110" =>
				Branch <= VF xor flags_ccr(0); -- N
			when "111" =>
				Branch <= VF xor flags_ccr(2); -- V
		end case;
end process;

UPA: entity work.upa port map (
		Acarreo	=> acarreo,
		selOp	=> sel_op,
		OP1	=> OP1,
		OP2	=> OP2,
		ResultUPA	=> resultado_upa,
		N	=> flags_upa(0),
		Z	=> flags_upa(1),
		V	=> flags_upa(2),
		C	=> flags_upa(3),
		H	=> flags_upa(4)
	);
	
ControlBusOut <= ControlBusIn;

end architecture;
