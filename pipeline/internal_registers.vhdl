library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity internal_registers is
    port(
        clk, reset    : in  std_logic;
        DatoW         : in  unsigned(15 downto 0);
        D1, D2        : out unsigned(15 downto 0);
        SelRegR       : in  unsigned(3 downto 0);
        SelRegW       : in  unsigned(3 downto 0)
    );
end internal_registers;

architecture arch of internal_registers is
    signal enaa, enab, enax, enay, enasp, ena_aux : std_logic;
    signal acca, accb, ix, iy, sp, aux : unsigned (15 downto 0);  
begin
    reg: process (clk, reset)
    begin
        if reset = '1' then
            acca <= (others => '0');
            accb <= (others => '0');
            ix   <= (others => '0');
            iy   <= (others => '0');
            sp   <= (others => '0');
            aux  <= (others => '0');
        elsif rising_edge (clk) then
            if enaa = '1' then
                acca <= DatoW;
            end if;  
            if enab = '1' then
                accb <= DatoW;
            end if;  
            if enax = '1' then
                ix <= DatoW;
            end if;  
            if enay = '1' then
                iy <= DatoW;
            end if;  
            if enasp = '1' then
                sp <= DatoW;
            end if;  
            if ena_aux = '1' then
                aux <= DatoW;
            end if;  
        end if;
    end process;

    process (SelRegW)
    begin
        case SelRegW is
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

    process (SelRegR)
    begin
        case SelRegR is
            when x"0" =>
                D1 <= (others => '0');
                D2 <= (others => '0');
            when x"1" =>
                D1 <= acca;
                D2 <= accb;
            when x"2" =>
                D1 <= accb;
                D2 <= (others => '0');
            when x"3" =>
                D1 <= accb;
                D2 <= ix;
            when x"4" =>
                D1 <= acca;
                D2 <= (others => '0');
            when x"5" =>
                D1 <= accb;
                D2 <= (others => '0');
            when x"6" =>
                D1 <= acca;
                D2 <= ix;
            when x"7" =>
                D1 <= acca;
                D2 <= iy;
            when x"8" =>
                D1 <= aux;
                D2 <= (others => '0');
            when x"9" =>
                D1 <= (others => '0');
                D2 <= ix;
            when x"A" =>
                D1 <= (others => '0');
                D2 <= iy;
            when x"B" =>
                D1 <= (others => '0');
                D2 <= sp;
            when x"C" =>
                D1 <= acca;
                D2 <= sp;
            when x"D" =>
                D1 <= accb;
                D2 <= sp;
            when x"E" =>
                D1 <= ix;
                D2 <= sp;
            when x"F" =>
                D1 <= iy;
                D2 <= sp;
            when others =>
                D1 <= (others => '0');
                D2 <= (others => '0');

        end case;
    end process;

end architecture;
