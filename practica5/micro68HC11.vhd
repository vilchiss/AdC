library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
    use ieee.numeric_std.all;

entity micro68HC11 is
	Port(   clk				: in  STD_LOGIC;
			reset			: in  STD_LOGIC;
			nIRQ			: in  STD_LOGIC;
			nXIRQ			: in  STD_LOGIC;
			Data_in			: in  unsigned(7 downto 0);
			Data_out		: out unsigned(7 downto 0); -- Bus de datos de 8 bits
			Dir				: out unsigned(15 downto 0); -- Bus de direcciones de 16 bits
			nRW				: out STD_LOGIC:= '1'; -- Señal para escribir en memoria
			-- Debug
			PC_low_out		: out unsigned(7 downto 0);
			e_presente_out	: out unsigned(7 downto 0);
			A_out			: out unsigned(7 downto 0);
			B_out			: out unsigned(7 downto 0);
			X_low_out		: out unsigned(7 downto 0);
			X_high_out		: out unsigned(7 downto 0);
			Y_low_out		: out unsigned(7 downto 0);
			D_out 			: out unsigned (15 downto 0);
			flags			: out unsigned(7 downto 0)
			-- S X H I N Z V C
			);
end micro68HC11;

architecture Behavioral of micro68HC11 is

	-- Se aumenta un bit los estados, para el controlador de interupcciones
	signal e_presente: unsigned(12 downto 0) := '0' & X"000";
	signal e_siguiente: unsigned(12 downto 0);
	signal PC: unsigned (15 downto 0):= X"0014";
	signal estados: unsigned (7 downto 0):= X"00"; -- S X H I N Z V C
	signal A: unsigned (7 downto 0); -- Acumulador A
	signal B: unsigned (7 downto 0); -- Acumuladro B
	signal Q: unsigned (7 downto 0);
	signal Yupa: unsigned (7 downto 0);
	signal XH: unsigned (7 downto 0); -- Parte alta del registro indice X
	signal XL: unsigned (7 downto 0); -- Parte baja del registro indice X
	signal YH: unsigned (7 downto 0); -- Parte alta del registro indice Y
	signal YL: unsigned (7 downto 0); -- Parte baja del registro indice Y
	signal AuxH: unsigned (7 downto 0);
	signal AuxL: unsigned (7 downto 0);
	signal Aux: unsigned (15 downto 0);
	signal PCH: unsigned (7 downto 0) := X"00";
	signal PCL: unsigned (7 downto 0) := X"14";

	-- Memoria de 256 bytes
	shared variable SPH: unsigned (7 downto 0) := X"00"; -- Apuntador de pila parte alta: 00
	shared variable SPL: unsigned (7 downto 0) := X"FF"; -- Apuntador de pila parte baja: FF

	signal microI: unsigned (12 downto 0) := '1' & X"000" ; -- Direccion del manejador de interrupciones internas
	signal microX: unsigned (12 downto 0) := '1' & X"200" ; -- Direccion del manejador de interrupciones externas
	signal IntRI: unsigned (15 downto 0) := X"006D"; -- Direccion de memoria del driver para interupcciones Internas
	signal IntRX: unsigned (15 downto 0) := X"0064"; -- Direccion de memoria del driver para interupcciones Externas
	signal IRQ: STD_LOGIC := '0';
	signal XIRQ: STD_LOGIC := '0';
	signal DINT : std_logic := '0';
	signal HINT : std_logic := '0';
	signal INT: std_logic := '0';
	signal SET_IRQ : std_logic := '0';
	signal SET_XIRQ : std_logic := '0';

	signal startMUL: STD_LOGIC := '0';
	constant ZERO : unsigned (7 downto 0) := "00000000" ;
	constant e1 : unsigned (12 downto 0) := '0' & X"001";
	signal D: unsigned (15 downto 0); -- Acumulador D de 16 bits
	signal varRW: STD_LOGIC := '1';
	signal indY: STD_LOGIC := '0';

	begin

		process(clk, reset,e_presente,e_siguiente)
			begin
				if (reset = '0') then
					e_siguiente <= '0' & X"000";
					PC			<= X"0014";
					DINT		<= '0';
					HINT		<= '0';
					SET_IRQ		<= '0';
					SET_XIRQ	<= '0';
					indY		<= '0';
				else
					if (rising_edge(clk)) then
						case e_presente is
							when '0' & X"000" =>
								Dir <= PC;
								e_siguiente <= '0' & X"001";
							when '0' & X"001" =>
								PC <= PC + 1;
								e_siguiente <= e_presente + 1;
							when '0' & X"002" =>
								e_siguiente <= ('0' & Data_in & ZERO(3 downto 0));

							----------------------------- LDAA #DATO (Acceso Inmediato) -----------------------------
							-- Carga en el acumulador A el valor DATO
							when '0' & X"860" => -- Codigo 86
								Dir <= PC;
								e_siguiente <= e_presente + 1;
							when '0' & X"861" =>
								PC <= PC + 1;
								e_siguiente <= e_presente + 1;
							when '0' & X"862" =>
								A <= Data_in;
								-- Actualiza Bandera N
								estados(3) <= Data_in(7);
								-- Actualiza Bandera Z
								if(Data_in = ZERO) then
									estados(2) <= '1';
								else
									estados(2) <= '0';
								end if;
								-- Actualiza Bandera V = 0
								estados(1) <= '0';
								if(INT = '1') then	-- Interrupcion
									if (XIRQ = '1') then -- Si hay interrupcion externa
										e_siguiente <= microX;
									elsif (IRQ = '1') then -- Si hay interrupcion interna
										e_siguiente <= microI;
									end if;
								else
									Dir <= PC;
									e_siguiente <= e1;
								end if;

							----------------------------- LDAA DIRECCION_16_bits (Acceso Extendido) -----------------------------
							-- Carga en el acumulador A el valor que se encuentra en la direccion DIRECCION_16_bits
							when '0' & X"B60" => -- Codigo B6
								Dir <= PC;
								e_siguiente <= e_presente + 1;
							when '0' & X"B61" =>
								PC <= PC + 1;
								PCH <= Data_in; -- guarda parte alta de la direccion
								e_siguiente <= e_presente + 1;
							when '0' & X"B62" => -- Codigo B6
								Dir <= PC;
								e_siguiente <= e_presente + 1;
							when '0' & X"B63" =>
								PC <= PC + 1;
								PCL <= Data_in; -- guarda parte baja de la direccion
								e_siguiente <= e_presente + 1;
							-- Solicita contenido de PCH & PCL
							when '0' & X"B64" =>
								Dir <= PCH & PCL;
								e_siguiente <= e_presente + 1;
							when '0' & X"B65" =>
								-- Guarda el contenido en el acumulador A
								A <= Data_in;
								-- Actualiza Bandera N
								estados(3) <= Data_in(7);
								-- Actualiza Bandera Z
								if(Data_in = ZERO) then
									estados(2) <= '1';
								else
									estados(2) <= '0';
								end if;
								-- Actualiza Bandera V = 0
								estados(1) <= '0';
								if(INT = '1') then	-- Interrupcion
									if (XIRQ = '1') then -- Si hay interrupcion externa
										e_siguiente <= microX;
									elsif (IRQ = '1') then -- Si hay interrupcion interna
										e_siguiente <= microI;
									end if;
								else
									Dir <= PC;
									e_siguiente <= e1;
								end if;


							----------------------------- LDAB #DATO (Acceso Inmediato) -----------------------------
							-- Carga en el acumulador B el valor DATO
							when '0' & X"C60" => -- Codigo C6
								Dir <= PC;
								e_siguiente <= e_presente + 1;
							when '0' & X"C61" =>
								PC <= PC + 1;
								e_siguiente <= e_presente + 1;
							when '0' & X"C62" =>
								B <= Data_in;
								-- Actualiza Bandera N
								estados(3) <= Data_in(7);
								-- Actualiza Bandera Z
								if(Data_in = ZERO) then
									estados(2) <= '1';
								else
									estados(2) <= '0';
								end if;
								-- Actualiza Bandera V=0
								estados(1) <= '0';
								if(INT = '1') then	-- Interrupcion
									if (XIRQ = '1') then -- Si hay interrupcion externa
										e_siguiente <= microX;
									elsif (IRQ = '1') then -- Si hay interrupcion interna
										e_siguiente <= microI;
									end if;
								else
									Dir <= PC;
									e_siguiente <= e1;
								end if;

							----------------------------- LDAB DIRECCION_16_bits (Acceso Extendido) -----------------------------
							-- Carga en el acumulador B el valor que se encuentra en la direccion DIRECCION_16_bits
							when '0' & X"F60" => -- Codigo F6
								Dir <= PC;
								e_siguiente <= e_presente + 1;
							when '0' & X"F61" =>
								PC <= PC + 1;
								PCH <= Data_in; -- guarda parte alta de la direccion
								e_siguiente <= e_presente + 1;
							when '0' & X"F62" => -- Codigo F6
								Dir <= PC;
								e_siguiente <= e_presente + 1;
							when '0' & X"F63" =>
								PC <= PC + 1;
								PCL <= Data_in; -- guarda parte baja de la direccion
								e_siguiente <= e_presente + 1;
							-- Solicita contenido de PCH & PCL
							when '0' & X"F64" =>
								Dir <= PCH & PCL;
								e_siguiente <= e_presente + 1;
							when '0' & X"F65" =>
								-- Guarda el contenido en el acumulador B
								B <= Data_in;
								-- Actualiza Bandera N
								estados(3) <= Data_in(7);
								-- Actualiza Bandera Z
								if(Data_in = ZERO) then
									estados(2) <= '1';
								else
									estados(2) <= '0';
								end if;
								-- Actualiza Bandera V = 0
								estados(1) <= '0';
								if(INT = '1') then	-- Interrupcion
									if (XIRQ = '1') then -- Si hay interrupcion externa
										e_siguiente <= microX;
									elsif (IRQ = '1') then -- Si hay interrupcion interna
										e_siguiente <= microI;
									end if;
								else
									Dir <= PC;
									e_siguiente <= e1;
								end if;

							----------------------------- BNE Desplazamiento (Acceso Relativo) -----------------------------
							-- Salta a la direccion PC + Desplazamiento si la bandera Z = 0 (la operacion anterior fue distinta de cero)
							when '0' & X"260" => -- Codigo 26
								Dir <= PC;
								e_siguiente <= e_presente + 1;
							when '0' & X"261" =>
								PC <= PC + 1;
								e_siguiente <= e_presente + 1;
							when '0' & X"262" =>
								if(estados(2)='0') then -- Si Z=0 haz el salto
									if (Data_in(7) = '1') then -- Desplazamiento negativo
										PC <= PC - unsigned(not(Data_in-1)); -- PC - Complemento a 2 de Desplazamiento
									else  -- Desplazamiento positivo
										PC <= PC + Data_in;  -- PC + Desplazamiento
									end if;
								end if;
								e_siguiente <= e_presente + 1;
							when '0' & X"263" =>
								if(INT = '1') then	-- Interrupcion
									if (XIRQ = '1') then -- Si hay interrupcion externa
										e_siguiente <= microX;
									elsif (IRQ = '1') then -- Si hay interrupcion interna
										e_siguiente <= microI;
									end if;
								else
									Dir <= PC;
									e_siguiente <= e1;
								end if;

							----------------------------- LDX #DATO_16_bits (Acceso Inmediato) -----------------------------
							-- Carga en el registro indice X los valores de las siguientes 2 localidades de memoria (16 bits)
							when '0' & X"CE0" => -- Codigo CE LDX IMM
								Dir <= PC;
								e_siguiente <= e_presente + 1;
							when '0' & X"CE1" =>
								PC <= PC + 1;
								e_siguiente <= e_presente + 1;
							when '0' & X"CE2" => -- Carga Data_in en la parte alta del registro indice X
								XH <= Data_in;
								e_siguiente <= e_presente + 1;
							when '0' & X"CE3" =>
								Dir <= PC;
								e_siguiente <= e_presente + 1;
							when '0' & X"CE4" =>
								PC <= PC + 1;
								e_siguiente <= e_presente + 1;
							when '0' & X"CE5" => -- Carga Data_in en la parte baja del registro indice X
								XL <= Data_in;
								e_siguiente <= e_presente + 1;
							when '0' & X"CE6" =>
								-- Actualiza Bandera N
								estados(3) <= XH(7);
								-- Actualiza Bandera Z
								if(XH = ZERO) then
									if(XL = ZERO) then
										estados(2) <= '1';
									else
										estados(2) <= '0';
									end if;
								else
									estados(2) <= '0';
								end if;
								-- Actualiza Bandera V=0
								estados(1) <= '0';
								if(INT = '1') then	-- Interrupcion
									if (XIRQ = '1') then -- Si hay interrupcion externa
										e_siguiente <= microX;
									elsif (IRQ = '1') then -- Si hay interrupcion interna
										e_siguiente <= microI;
									end if;
								else
									Dir <= PC;
									e_siguiente <= e1;
								end if;

							----------------------------- ABA (A <- A + B) -----------------------------
							-- Formulas tomadas del manual de referencia del micro68HC11
							when '0' & X"1B0" => -- Codigo 1B
								Yupa <= A + B;
								e_siguiente <= e_presente + 1;
							when '0' & X"1B1" => -- Actualiza banderas
								-- Actualiza Bandera H = A3 * B3 + B3 * not Yupa 3 + not Yupa 3 * A3
								estados(5) <= (A(3) and B(3)) or (B(3) and not(Yupa(3))) or (not(Yupa(3)) and A(3));
								-- Actualiza Bandera N
								estados(3) <= Yupa(7);
								-- Actualiza Bandera Z
								if(Yupa = ZERO) then
									estados(2) <= '1';
								else
									estados(2) <= '0';
								end if;
								-- Actualiza Bandera V=A(7) x B(7) x not Yupa(7) + not A(7) x not B(7) x Yupa(7)
								estados(1) <= (A(7) and B(7) and not(Yupa(7))) or (not(A(7)) and not(B(7)) and Yupa(7));
								-- Actualiza Bandera C = A7 * B7 + B7 * not Yupa 7 + not Yupa 7 * A7
								estados(0) <= (A(7) and B(7)) or (B(7) and not(Yupa(7))) or (not(Yupa(7)) and A(7));

								e_siguiente <= e_presente + 1;
							when '0' & X"1B2" =>
								A <= Yupa;
								if(INT = '1') then	-- Interrupcion
									if (XIRQ = '1') then -- Si hay interrupcion externa
										e_siguiente <= microX;
									elsif (IRQ = '1') then -- Si hay interrupcion interna
										e_siguiente <= microI;
									end if;
								else
									Dir <= PC;
									e_siguiente <= e1;
								end if;

							----------------------------- STAA IND,X (Acceso Indexado) -----------------------------
							-- Carga en memoria el valor del acumulador A en la direccion almacenada en el registro indice X + IND
							when '0' & X"A70" => -- Codigo A7
								Dir <= PC;
								e_siguiente <= e_presente + 1;
							when '0' & X"A71" =>
								PC <= PC + 1;
								e_siguiente <= e_presente + 1;
							when '0' & X"A72" =>
								Dir <= (XH & XL) + (ZERO & data_in);
								Data_out <= A;
								e_siguiente <= e_presente + 1;
							when '0' & X"A73" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '0' & X"A74" =>
								nRw <= '1';

								-- Actualiza Bandera N
								estados(3) <= A(7);
								-- Actualiza Bandera Z
								if(A = ZERO) then
									estados(2) <= '1';
								else
									estados(2) <= '0';
								end if;
								-- Actualiza Bandera V=0
								estados(1) <= '0';

								if(INT = '1') then	-- Interrupcion
									if (XIRQ = '1') then -- Si hay interrupcion externa
										e_siguiente <= microX;
									elsif (IRQ = '1') then -- Si hay interrupcion interna
										e_siguiente <= microI;
									end if;
								else
									Dir <= PC;
									e_siguiente <= e1;
								end if;

							----------------------------- STAB IND,X (Acceso Indexado) -----------------------------
							-- Carga en memoria el valor del acumulador B en la direccion almacenada en el registro indice X + IND
							when '0' & X"E70" => -- Codigo E7
								 Dir <= PC;
								 e_siguiente <= e_presente + 1;
							when '0' & X"E71" =>
								 PC <= PC + 1;
								 e_siguiente <= e_presente + 1;
							when '0' & X"E72" =>
								 Dir <= (XH & XL) + (ZERO & data_in);
								 Data_out <= B;
								 e_siguiente <= e_presente + 1;
							when '0' & X"E73" =>
								 nRw <= '0'; -- Señal para escribir en memoria
								 e_siguiente <= e_presente + 1;
							when '0' & X"E74" =>
								 nRw <= '1';
								 -- Actualiza Bandera N
								 estados(3) <= B(7);
								 -- Actualiza Bandera Z
								 if(B = ZERO) then
									  estados(2) <= '1';
								 else
									  estados(2) <= '0';
								 end if;
								 -- Actualiza Bandera V=0
								 estados(1) <= '0';

								 if(INT = '1') then    -- Interrupcion
									  if (XIRQ = '1') then -- Si hay interrupcion externa
											e_siguiente <= microX;
									  elsif (IRQ = '1') then -- Si hay interrupcion interna
											e_siguiente <= microI;
									  end if;
								 else
									  Dir <= PC;
									  e_siguiente <= e1;
								 end if;

							----------------------------- BRA Desplazamiento (Acceso Relativo) -----------------------------
							-- Salto incondicional a PC + Desplazamiento
							when '0' & X"200" => -- Codigo 20
								Dir <= PC;
								e_siguiente <= e_presente + 1;
							when '0' & X"201" =>
								PC <= PC + 1;
								e_siguiente <= e_presente + 1;
							when '0' & X"202" =>
								if (Data_in(7) = '1') then -- Desplazamiento negativo
									PC <= PC - unsigned(not(Data_in-1)); -- PC - Complemento a 2 de Desplazamiento
								else  -- Desplazamiento positivo
									PC <= PC + Data_in;  -- PC + Desplazamiento
								end if;
								e_siguiente <= e_presente + 1;
							when '0' & X"203" =>
								if(INT = '1') then	-- Interrupcion
									if (XIRQ = '1') then -- Si hay interrupcion externa
										e_siguiente <= microX;
									elsif (IRQ = '1') then -- Si hay interrupcion interna
										e_siguiente <= microI;
									end if;
								else
									Dir <= PC;
									e_siguiente <= e1;
								end if;

							----------------------------- MUL (Acceso Inherente) -----------------------------
							-- ACCD <= ACCA * ACCB
							when '0' & X"3D0" => -- Codigo 3D
								 Yupa <= A(3 downto 0) * B(3 downto 0);
								 e_siguiente <= e_presente + 1;
							when '0' & X"3D1" =>
								 AuxL <= Yupa;
									  estados(0) <= Yupa(7); -- Actualiza banderas S X H I N Z V C
								 e_siguiente <= e_presente + 1;
							when '0' & X"3D2" =>
								 Yupa <= A(7 downto 4) * B(7 downto 4);
								 e_siguiente <= e_presente + 1;
							when '0' & X"3D3" =>
								 A <= Yupa;
								 e_siguiente <= e_presente + 1;
							when '0' & X"3D4" =>
								 B <= AuxL;
								 e_siguiente <= e_presente + 1;
							when '0' & X"3D5" =>
								 if(INT = '1') then    -- Interrupcion
									  if (XIRQ = '1') then -- Si hay interrupcion externa
											e_siguiente <= microX;
									  elsif (IRQ = '1') then -- Si hay interrupcion interna
											e_siguiente <= microI;
									  end if;
								 else
									  Dir <= PC;
									  e_siguiente <= e1;
								 end if;

							----------------------------- RTI (Acceso Inherente) -----------------------------
							-- Regresa de interrupcion
							when '0' & X"3B0" => -- Codigo 3B
								SPL := SPL + 1;
								e_siguiente <= e_presente + 1;
							when '0' & X"3B1" =>
								Dir <= (SPH & SPL);
								e_siguiente <= e_presente + 1;
							when '0' & X"3B2" => -- Obtiene los valores de las banderas
								SPL := SPL + 1;
								estados(7) <= Data_in(7); -- Bandera S
								if(Data_in(6) = '0') then --Decide si actualiza bandera X
									estados(6) <= '0';
								end if;
								estados(5) <= Data_in(5); -- Bandera H
								estados(4) <= Data_in(4); -- Bandera I
								estados(3) <= Data_in(3); -- Bandera N
								estados(2) <= Data_in(2); -- Bandera Z
								estados(1) <= Data_in(1); -- Bandera V
								estados(0) <= Data_in(0); -- Bandera C
								e_siguiente <= e_presente + 1;
							when '0' & X"3B3" =>
								Dir <= (SPH & SPL);
								e_siguiente <= e_presente + 1;
							when '0' & X"3B4" => -- Obtiene el valor del acumulador B
								SPL := SPL + 1;
								B <= Data_in;
								e_siguiente <= e_presente + 1;
							when '0' & X"3B5" =>
								Dir <= (SPH & SPL);
								e_siguiente <= e_presente + 1;
							when '0' & X"3B6" => -- Obtiene el valor del acumulador A
								SPL := SPL + 1;
								A <= Data_in;
								e_siguiente <= e_presente + 1;
							when '0' & X"3B7" =>
								Dir <= (SPH & SPL);
								e_siguiente <= e_presente + 1;
							when '0' & X"3B8" => -- Obtiene el valor de XH
								SPL := SPL + 1;
								XH <= Data_in;
								e_siguiente <= e_presente + 1;
							when '0' & X"3B9" =>
								Dir <= (SPH & SPL);
								e_siguiente <= e_presente + 1;
							when '0' & X"3BA" => -- Obtiene el valor de XL
								SPL := SPL + 1;
								XL <= Data_in;
								e_siguiente <= e_presente + 1;
							when '0' & X"3BB" =>
								Dir <= (SPH & SPL);
								e_siguiente <= e_presente + 1;
							when '0' & X"3BC" => -- Obtiene el valor de YH
								SPL := SPL + 1;
								YH <= Data_in;
								e_siguiente <= e_presente + 1;
							when '0' & X"3BD" =>
								Dir <= (SPH & SPL);
								e_siguiente <= e_presente + 1;
							when '0' & X"3BE" => -- Obtiene el valor de YL
								SPL := SPL + 1;
								YL <= Data_in;
								e_siguiente <= e_presente + 1;
							when '0' & X"3BF" =>
								Dir <= (SPH & SPL);
								e_siguiente <= '1' & X"3B0";
							when '1' & X"3B0" => -- Obtiene el valor de PCH
								SPL := SPL + 1;
								PC(15 downto 8) <= Data_in;
								e_siguiente <= e_presente + 1;
							when '1' & X"3B1" =>
								Dir <= (SPH & SPL);
								HINT <= '1';  -- Habilita las interrupciones
								e_siguiente <= e_presente + 1;
							when '1' & X"3B2" => -- Obtiene el valor de PCL
								PC(7 downto 0) <= Data_in;
								HINT <= '0';
								e_siguiente <= e_presente + 1;
							when '1' & X"3B3" =>
								if(INT = '1') then	-- Interrupcion
									if (XIRQ = '1') then -- Si hay interrupcion externa
										e_siguiente <= microX;
									elsif (IRQ = '1') then -- Si hay interrupcion interna
										e_siguiente <= microI;
									end if;
								else
									Dir <= PC;
									e_siguiente <= e1;
								end if;

							----------------------------- CONTROL DE INTERRUPCIONES EXTERNAS -----------------------------
							--Guarda PC, Y, X, A, B y Flags en la pila
							when '1' & X"200" =>
								DINT <= '1'; -- Deshabilita la atencion a interrupciones
								SET_XIRQ <= '1'; -- Indica quien genero la interrupcion que se atiende
								--PC parte baja
								Dir <= (SPH & SPL);
								Data_out <= PC(7 downto 0);
								e_siguiente <= e_presente + 1;
							when '1' & X"201" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"202" =>
								DINT <= '0';
								SET_XIRQ <= '0';
								SPL := SPL - 1;
								nRw <= '1'; -- Señal para no escribir
								e_siguiente <= e_presente + 1;
							when '1' & X"203" =>
								--PC parte alta
								Dir <= (SPH & SPL);
								Data_out <= PC(15 downto 8);
								e_siguiente <= e_presente + 1;
							when '1' & X"204" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"205" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							when '1' & X"206" =>
								--Y parte baja
								Dir <= (SPH & SPL);
								Data_out <= YL;
								e_siguiente <= e_presente + 1;
							when '1' & X"207" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"208" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							when '1' & X"209" =>
								--Y parte alta
								Dir <= (SPH & SPL);
								Data_out <= YH;
								e_siguiente <= e_presente + 1;
							when '1' & X"20A" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"20B" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							when '1' & X"20C" =>
								--X parte baja
								Dir <= (SPH & SPL);
								Data_out <= XL;
								e_siguiente <= e_presente + 1;
							when '1' & X"20D" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"20E" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							when '1' & X"20F" =>
								--X parte alta
								Dir <= (SPH & SPL);
								Data_out <= XH;
								e_siguiente <= e_presente + 1;
							when '1' & X"210" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"211" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							when '1' & X"212" =>
								--Acumulador A
								Dir <= (SPH & SPL);
								Data_out <= A;
								e_siguiente <= e_presente + 1;
							when '1' & X"213" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"214" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							when '1' & X"215" =>
								--Acumulador B
								Dir <= (SPH & SPL);
								Data_out <= B;
								e_siguiente <= e_presente + 1;
							when '1' & X"216" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"217" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							when '1' & X"218" =>
								--flags
								Dir <= (SPH & SPL);
								Data_out <= unsigned(estados);
								e_siguiente <= e_presente + 1;
							when '1' & X"219" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"21A" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							--TERMINA RESPALDO DE VARIABLES EN LA PILA
							when '1' & X"21B" =>
								PC <= IntRX;
								e_siguiente <= '0' & X"000"; -- Inicia atencion de interrupcion


							----------------------------- CONTROL DE INTERRUPCIONES Internas -----------------------------
							--Guarda PC, Y, X, A, B y Flags en la pila
							when '1' & X"000" =>
								DINT <= '1'; -- Deshabilita la atencion de interrupciones
								SET_IRQ <= '1'; -- Indica quien genero la interrupcion que se atiende
								--PC parte baja
								Dir <= (SPH & SPL);
								Data_out <= PC(7 downto 0);
								e_siguiente <= e_presente + 1;
							when '1' & X"001" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"002" =>
								DINT <= '0';
								SET_IRQ <= '0';
								SPL := SPL - 1;
								nRw <= '1'; -- Señal para no escribir
								e_siguiente <= e_presente + 1;
							when '1' & X"003" =>
								--PC parte alta
								Dir <= (SPH & SPL);
								Data_out <= PC(15 downto 8);
								e_siguiente <= e_presente + 1;
							when '1' & X"004" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"005" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							when '1' & X"006" =>
								--Y parte baja
								Dir <= (SPH & SPL);
								Data_out <= YL;
								e_siguiente <= e_presente + 1;
							when '1' & X"007" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"008" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							when '1' & X"009" =>
								--Y parte alta
								Dir <= (SPH & SPL);
								Data_out <= YH;
								e_siguiente <= e_presente + 1;
							when '1' & X"00A" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"00B" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							when '1' & X"00C" =>
								--X parte baja
								Dir <= (SPH & SPL);
								Data_out <= XL;
								e_siguiente <= e_presente + 1;
							when '1' & X"00D" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"00E" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							when '1' & X"00F" =>
								--X parte alta
								Dir <= (SPH & SPL);
								Data_out <= XH;
								e_siguiente <= e_presente + 1;
							when '1' & X"010" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"011" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							when '1' & X"012" =>
								--Acumulador A
								Dir <= (SPH & SPL);
								Data_out <= A;
								e_siguiente <= e_presente + 1;
							when '1' & X"013" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"014" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							when '1' & X"015" =>
								--Acumulador B
								Dir <= (SPH & SPL);
								Data_out <= B;
								e_siguiente <= e_presente + 1;
							when '1' & X"016" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"017" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							when '1' & X"018" =>
								--flags
								Dir <= (SPH & SPL);
								Data_out <= unsigned(estados);
								e_siguiente <= e_presente + 1;
							when '1' & X"019" =>
								nRw <= '0'; -- Señal para escribir en memoria
								e_siguiente <= e_presente + 1;
							when '1' & X"01A" =>
								nRw <= '1'; -- Señal para no escribir
								SPL := SPL - 1;
								e_siguiente <= e_presente + 1;
							--TERMINA RESPALDO DE VARIABLES EN LA PILA
							when '1' & X"01B" =>
								PC <= IntRI;
								e_siguiente <= '0' & X"000"; -- Inicia atencion de interrupcion

							---------------------------------------------------------------------------------------------------------------------
							when others =>
							e_siguiente <= '0' & X"000";
							PC <= X"0000";
						end case;
					end if;
				end if;
				e_presente <= e_siguiente;
				-- debug vals
				A_out<=A;
				B_out<=B;
				e_presente_out<=e_presente(11 downto 4);
				PC_low_out <= PC(7 downto 0);
				X_low_out <= XL;
				X_high_out <= XH;
				Y_low_out <= YL;
				D_out <= D;
				flags <= estados;
		end process;

		interrupciones: process(clk, nIRQ, nXIRQ, DINT, HINT, SET_IRQ, SET_XIRQ)
			variable atnINT : std_logic := '1';

			begin
				if (rising_edge(clk)) then
					-- Interrupciones Externas
					if(estados(6) = '0') then -- Si estan habilitadas las interrupciones externas
						if(nXIRQ = '0') then -- Si ocurrio una interrupcion externa
							XIRQ <= '1'; -- Interrupcion tipo Externa
							if(atnINT = '1') then -- Si se desea atender interrupciones
								INT <= '1';
							else
								INT <= '0';
							end if;
						elsif(DINT = '1') then -- Si se comienza a atender una interrupcion
							atnINT := '0'; -- Deshabilita la atencion a interrupciones
							if(SET_XIRQ = '1') then -- Si la interrupcion que se esta atendiendo es externa
								XIRQ <= '0'; -- Reinicia el indicador de tipo de interrupcion
							end if;
							INT <= '0';
						elsif(HINT = '1') then -- Se termino de atender una interrupcion
							atnINT := '1'; -- Habilita la atencion a interrupciones
							if(XIRQ = '1') then -- Ocurrió una interrupcion Externa mientras se atendia una interrupcion
								INT <= '1';
							end if;
						end if;
					else
						INT <= '0';
					end if;

					-- Interrupciones Internas
					if(estados(4) = '0') then -- Si estan habilitadas las interrupciones internas
						if(nIRQ = '0') then -- Si ocurrio una interrupcion interna
							IRQ <= '1'; -- Interrupcion tipo Interna
							if(atnINT = '1') then -- Si se desea atender interrupciones
								INT <= '1';
							else
								INT <= '0';
							end if;
						elsif(DINT = '1') then -- Si se comienza a atender una interrupcion
							atnINT := '0'; -- Deshabilita la atencion a interrupciones
							if(SET_IRQ = '1') then -- Si la interrupcion que se esta atendiendo es interna
								IRQ <= '0'; -- Reinicia el indicador de tipo de interrupcion
							end if;
							INT <= '0';
						elsif(HINT = '1') then -- Se termino de atender una interrupcion
							atnINT := '1'; -- Habilita la atencion a interrupciones
							if(IRQ = '1') then -- Ocurrió una interrupcion Interna mientras se atendia una interrupcion
								INT <= '1';
							end if;
						end if;
					else
						INT <= '0';
					end if;
				end if;
		end process;


end behavioral;
