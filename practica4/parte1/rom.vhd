library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity rom is
  port(
    cs        : in  std_logic;
    addr      : in  unsigned(3 downto 0);
    data_out  : out unsigned(12 downto 0)
  );
end rom;

architecture arch of rom is
    subtype   word          is  unsigned(12 downto 0);
    type      memory        is  array(0 to 14) of word;
    signal    rom           :   memory;
    attribute ram_init_file :   string;
    attribute ram_init_file of  rom: signal is "memoria.mif";
    signal    data          :   unsigned(12 downto 0);
begin

  rom_p: process(addr) begin
    data <= rom(to_integer(addr));
  end process rom_p;

  buf_p: process (data, cs) begin
    if cs = '1' then
      data_out <= data;
    else
      data_out <= (others => 'Z');
    end if;
  end process buf_p;

 end arch;
