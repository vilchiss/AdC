library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity control_unit is
    port(
        inst:   in  unsigned(15 downto 0);
        SelS1, SR, Cin, SelS2, SelDato, SelDir, SelResult, SelC,
        Cadj, SelBranch, VF, MemW:  out std_logic;
        SelReg, SelOp, SelFlags:    out unsigned(3 downto 0);
        SelScrs, SelRegW:           out unsigned(2 downto 0);
        SelDir: out unsigned(1 downto 0)
    );
end control_unit;

architecture arch of control_unit is
begin
    process (all)
    begin
        case inst is
            when x"001B" =>
                SelRegR     <=  x"1";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"1";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"1";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"2";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"1";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"183A" =>
                SelRegR     <=  x"3";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"1";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"1";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"0";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"3";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"00D9" =>
                SelRegR     <=  x"5";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"2";
                SelDato     <=   '1';
                SelDir      <=   '1';
                SelOp       <=  x"1";
                SelResult   <=   '1';
                SelC        <=   '0';
                Cadj        <=   '0';
                SelFlags    <=  x"2";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"4";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"00B4" =>
                SelRegR     <=  x"4";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"2";
                SelDato     <=   '1';
                SelDir      <=   '1';
                SelOp       <=  x"3";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"1";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"1";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"00F4" =>
                SelRegR     <=  x"5";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"2";
                SelDato     <=   '1';
                SelDir      <=   '1';
                SelOp       <=  x"3";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"1";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"4";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"00E4" =>
                SelRegR     <=  x"2";
                SelS1       <=   '1';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"2";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"3";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"1";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"4";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"1868" =>
                SelRegR     <=  x"A";
                SelS1       <=   '1';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"4";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"6";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"3";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"0";
                MemW        <=   '1';
                SelDir      <= 2x"2";

            when x"0067" =>
                SelRegR     <=  x"9";
                SelS1       <=   '1';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"4";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"7";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"3";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"0";
                MemW        <=   '1';
                SelDir      <= 2x"2";

            when x"0057" =>
                SelRegR     <=  x"5";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"1";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"7";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"3";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"4";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"0024" =>
                SelRegR     <=  x"0";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '1';
                SelScrs     <=  o"5";
                SelDato     <=   '0';
                SelDir      <=   '0';
                SelOp       <=  x"1";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"0";
                SelBranch   <=   '1';
                VF          <=   '0';
                SelRegW     <=  o"0";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"0085" =>
                SelRegR     <=  x"4";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"3";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"3";
                SelResult   <=   '0';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"1";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"0";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"0020" =>
                SelRegR     <=  x"0";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '1';
                SelScrs     <=  o"5";
                SelDato     <=   '0';
                SelDir      <=   '0';
                SelOp       <=  x"1";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"0";
                SelBranch   <=   '0';
                VF          <=   '0';
                SelRegW     <=  o"0";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"0011" =>
                SelRegR     <=  x"1";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"1";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"2";
                SelResult   <=   '0';
                SelC        <=   '1';
                Cadj        <=   '1';
                SelFlags    <=  x"3";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"0";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"007F" =>
                SelRegR     <=  x"0";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"2";
                SelDato     <=   '1';
                SelDir      <=   '1';
                SelOp       <=  x"3";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"3";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"0";
                MemW        <=   '1';
                SelDir      <= 2x"2";

            when x"00D1" =>
                SelRegR     <=  x"5";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"2";
                SelDato     <=   '1';
                SelDir      <=   '1';
                SelOp       <=  x"2";
                SelResult   <=   '0';
                SelC        <=   '1';
                Cadj        <=   '1';
                SelFlags    <=  x"3";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"0";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"0063" =>
                SelRegR     <=  x"9";
                SelS1       <=   '1';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"2";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"2";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"B";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"0";
                MemW        <=   '1';
                SelDir      <= 2x"2";

            when x"0053" =>
                SelRegR     <=  x"5";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"1";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"8";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"B";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"4";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"18AC" =>
                SelRegR     <=  x"A";
                SelS1       <=   '1';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"6";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"2";
                SelResult   <=   '0';
                SelC        <=   '1';
                Cadj        <=   '1';
                SelFlags    <=  x"3";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"0";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"007A" =>
                SelRegR     <=  x"0";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"2";
                SelDato     <=   '1';
                SelDir      <=   '1';
                SelOp       <=  x"8";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"C";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"0";
                MemW        <=   '1';
                SelDir      <= 2x"2";

            when x"0034" =>
                SelRegR     <=  x"B";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"1";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"8";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"0";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"6";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"005C" =>
                SelRegR     <=  x"5";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"1";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"1";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '1';
                SelFlags    <=  x"C";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"4";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"0086" =>
                SelRegR     <=  x"0";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"3";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"4";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"1";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"1";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"18EE" =>
                SelRegR     <=  x"A";
                SelS1       <=   '1';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"2";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"4";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"1";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"3";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"0070" =>
                SelRegR     <=  x"0";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"2";
                SelDato     <=   '1';
                SelDir      <=   '1';
                SelOp       <=  x"2";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '1';
                SelFlags    <=  x"3";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"0";
                MemW        <=   '1';
                SelDir      <= 2x"2";

            when x"0001" =>
                SelRegR     <=  x"0";
                SelS1       <=   '0';
                SR          <=   '0';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"0";
                SelDato     <=   '0';
                SelDir      <=   '0';
                SelOp       <=  x"0";
                SelResult   <=   '0';
                SelC        <=   '0';
                Cadj        <=   '0';
                SelFlags    <=  x"0";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"0";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"1866" =>
                SelRegR     <=  x"A";
                SelS1       <=   '1';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"4";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"B";
                SelResult   <=   '1';
                SelC        <=   '0';
                Cadj        <=   '0';
                SelFlags    <=  x"3";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"0";
                MemW        <=   '1';
                SelDir      <= 2x"2";

            when x"00C2" =>
                SelRegR     <=  x"5";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"3";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"2";
                SelResult   <=   '1';
                SelC        <=   '0';
                Cadj        <=   '0';
                SelFlags    <=  x"3";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"4";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"00B7" =>
                SelRegR     <=  x"4";
                SelS1       <=   '1';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"1";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"4";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"1";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"0";
                MemW        <=   '1';
                SelDir      <= 2x"2";

            when x"00EF" =>
                SelRegR     <=  x"9";
                SelS1       <=   '1';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"1";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"4";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"1";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"0";
                MemW        <=   '1';
                SelDir      <= 2x"2";

            when x"186D" =>
                SelRegR     <=  x"A";
                SelS1       <=   '1';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"2";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"8";
                SelResult   <=   '0';
                SelC        <=   '1';
                Cadj        <=   '1';
                SelFlags    <=  x"3";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"0";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"0030" =>
                SelRegR     <=  x"B";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"1";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"1";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '1';
                SelFlags    <=  x"0";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"2";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when x"1835" =>
                SelRegR     <=  x"A";
                SelS1       <=   '0';
                SR          <=   '1';
                Cin         <=   '0';
                SelS2       <=   '0';
                SelScrs     <=  o"1";
                SelDato     <=   '1';
                SelDir      <=   '0';
                SelOp       <=  x"8";
                SelResult   <=   '1';
                SelC        <=   '1';
                Cadj        <=   '0';
                SelFlags    <=  x"0";
                SelBranch   <=   '0';
                VF          <=   '1';
                SelRegW     <=  o"6";
                MemW        <=   '0';
                SelDir      <= 2x"0";

            when others =>
                SelRegR     <= (others => '0');
                SelS1       <= (others => '0');
                SR          <= (others => '0');
                Cin         <= (others => '0');
                SelS2       <= (others => '0');
                SelScrs     <= (others => '0');
                SelDato     <= (others => '0');
                SelDir      <= (others => '0');
                SelOp       <= (others => '0');
                SelResult   <= (others => '0');
                SelC        <= (others => '0');
                Cadj        <= (others => '0');
                SelFlags    <= (others => '0');
                SelBranch   <= (others => '0');
                VF          <= (others => '0');
                SelRegW     <= (others => '0');
                MemW        <= (others => '0');
                SelDir      <= (others => '0');

        end case;
    end process;
end architecture;
