-- Copyright (c) 2016 - 2018 Emilio Cabrera
--
-- MIT License
--
-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:
--
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
-- LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
-- OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity rom is
  port(
    cs        : in  std_logic;
    addr      : in  unsigned(3 downto 0);
    data_out  : out unsigned(14 downto 0)
  );
end rom;

architecture arch of rom is
    subtype   word          is  unsigned(14 downto 0);
    type      memory        is  array(0 to 13) of word;
    signal    rom           :   memory;
    attribute ram_init_file :   string;
    attribute ram_init_file of  rom: signal is "rom_file.mif";
    signal    data          :   unsigned(14 downto 0);
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
