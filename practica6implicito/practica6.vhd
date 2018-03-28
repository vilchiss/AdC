-- Copyright (c) 2018 Emilio Cabrera
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

entity practica6 is
  port (
    clock     : in  std_logic;
    boton     : in  std_logic;
    entradas  : in  unsigned(1 downto 0);
    salidas   : out unsigned(3 downto 0)
  );
end entity;

architecture arch of practica6 is
  signal carga_s, vf_s, ent_s, clk_s: std_logic;
  signal prueba_s: unsigned(1 downto 0);
  signal liga_s, salv_s, salf_s, dir_s: unsigned(3 downto 0);
  signal sal_mem_s: unsigned(14 downto 0);
begin
  sensa_e: entity work.sensa_boton port map(
    boton => boton,
    clk   => clock,
    reloj => clk_s
  );

  cont_e: entity work.contador port map(
    clock => clk_s,
    data  => liga_s,
    load  => carga_s,
    count => dir_s
  );

  rom_e: entity work.rom port map(
    cs        => '1',
    addr      => dir_s,
    data_out  => sal_mem_s
  );

  reg_outv_p: process(clk_s) begin
    if rising_edge(clk_s) then
			salv_s <= sal_mem_s(7 downto 4);
		end if;
	end process;

  reg_outf_p: process(clk_s) begin
    if rising_edge(clk_s) then
			salf_s <= sal_mem_s(3 downto 0);
		end if;
	end process;

  prueba_s <= sal_mem_s(14 downto 13);
  vf_s     <= sal_mem_s(12);
  liga_s   <= sal_mem_s(11 downto 8);
  carga_s  <= ent_s xnor vf_S;

  with prueba_s select
    ent_s <=  entradas(0) when  "00",
              entradas(1) when  "01",
              '1'         when  "11",
              '1'         when  others;

  salidas <= salf_s when vf_s = '0' else salv_s;

end architecture;
