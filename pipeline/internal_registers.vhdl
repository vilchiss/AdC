library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity internal_registers is
    port(
        clk, reset    : in std_logic;
        dato_w, d1, d2: in unsigned(15 downto 0);
        sel_reg_r     : in std_logic;
        sel_reg_w     : in std_logic;
    );
end internal_registers;

architecture arch of internal_registers is
    signal enaa, enab, enax, enay, enasp, ena_aux : std_logic;
    signal acca, accb, ix, iy, sp, aux : unsigned (16 downto 0);  
begin
    register: process (clk, reset)
    begin
        if reset = 1 then
            acca <= (others => '0');
            accb <= (others => '0');
            ix   <= (others => '0');
            iy   <= (others => '0');
            sp   <= (others => '0');
            aux  <= (others => '0');
        elsif rising_edge (clk) then
            if enaa = 1 then
                acca <= dato_w;
            end if;  
            if enab = 1 then
                accb <= dato_w;
            end if;  
            if enax = 1 then
                ix <= dato_w;
            end if;  
            if enay = 1 then
                iy <= dato_w;
            end if;  
            if enasp = 1 then
                sp <= dato_w;
            end if;  
            if ena_aux = 1 then
                aux <= dato_w;
            end if;  
        end if;
    end process;

    process (sel_reg_w)
    begin
        case sel_reg_w is
            when x"1" =>
                enaa    <= '1';
                enab    <= '0';
                enax    <= '0';
                enay    <= '0';
                enasp   <= '0';
                ena_aux <= '0';
 
            when x"2" => 
                enaa    <= '0';
                enab    <= '0';
                enax    <= '1';
                enay    <= '0';
                enasp   <= '0';
                ena_aux <= '0';

            when x"3" => 
                enaa    <= '0';
                enab    <= '0';
                enax    <= '0';
                enay    <= '1';
                enasp   <= '0';
                ena_aux <= '0';

            when x"4" => 
                enaa    <= '0';
                enab    <= '1';
                enax    <= '0';
                enay    <= '0';
                enasp   <= '0';
                ena_aux <= '0';

            when x"5" => 
                enaa    <= '0';
                enab    <= '0';
                enax    <= '0';
                enay    <= '0';
                enasp   <= '0';
                ena_aux <= '1';

            when x"6" => 
                enaa    <= '0';
                enab    <= '0';
                enax    <= '0';
                enay    <= '0';
                enasp   <= '1';
                ena_aux <= '0';

            when others =>
                enaa    <= '0';
                enab    <= '0';
                enax    <= '0';
                enay    <= '0';
                enasp   <= '0';
                ena_aux <= '0';

        end case;
    end process; 

    process (sel_reg_r)
    begin
        case sel_reg_r is
            when x"0" =>
                d1 <= (others => '0');
                d2 <= (others => '0');
            when x"1" =>
                d1 <= acca;
                d2 <= accb;
            when x"2" =>
                d1 <= accb;
                d2 <= (others => '0');
            when x"3" =>
                d1 <= accb;
                d2 <= ix;
            when x"4" =>
                d1 <= acca;
                d2 <= (others => '0');
            when x"5" =>
                d1 <= accb;
                d2 <= (others => '0');
            when x"6" =>
                d1 <= acca;
                d2 <= ix;
            when x"7" =>
                d1 <= acca;
                d2 <= iy;
            when x"8" =>
                d1 <= aux;
                d2 <= (others => '0');
            when x"9" =>
                d1 <= (others => '0');
                d2 <= ix;
            when x"A" =>
                d1 <= (others => '0');
                d2 <= iy;
            when x"B" =>
                d1 <= (others => '0');
                d2 <= sp;
            when x"C" =>
                d1 <= acca;
                d2 <= sp;
            when x"D" =>
                d1 <= accb;
                d2 <= sp;
            when x"E" =>
                d1 <= ix;
                d2 <= sp;
            when x"F" =>
                d1 <= iy;
                d2 <= sp;
            when others =>
                d1 <= (others => '0');
                d2 <= (others => '0');

        end case;
    end process;

end architecture;
