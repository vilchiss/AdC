library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

  entity stage2 is
    port(
      clk, SelBranch, VF, SelFlags, SelC : in std_logic;
      OP1 : in unsigned(15 downto 0);
      OP2 : in unsigned(15 downto 0);
      DirW : out unsigned(15 downto 0);
      Branch : out std_logic:
      DatoW : out unsigned(15 downto 0);
      Banderas : out unsigned(5 downto 0)
    );
  end stage2;

  architecture arch of stage2 is
    begin
  end architecture;
