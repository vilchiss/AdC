library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

  entity stage2 is
    port(
      clk, SelRegR, SelRegW, DatoW, MemW : in std_logic;
      instr : in unsigned(35 downto 0);
      Banderas : in unsigned(5 downto 0);
      SelDir : in unsigned(2 downto 0);
      Banderas_st2 : out unsigned(5 downto 0);
      D3 : out unsigned(15 downto 0);
      OP1 : out unsigned(15 downto 0);
      OP2 : out unsigned(15 downto 0)
    );
  end stage2;

  architecture arch of stage2 is
    begin
  end architecture;
