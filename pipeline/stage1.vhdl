library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity stage1 is
  port(
      clk, branch, reset : in std_logic;
      dato_w : in unsigned(15 downto 0);
      pc : out unsigned(15 downto 0);
      instr : out unsigned(31 downto 0)
  );
end stage1;

architecture arch of stage1 is
 signal out_mux : unsigned(15 downto 0);
 signal out_pc : unsigned(15 downto 0);
 signal out_incr : unsigned(15 downto 0);

 begin
   -- Mux de branch
   out_mux <= out_incr when branch = '0' else dato_w;

   -- Contador de programa
   process(clk, reset)
    begin
      if reset = '1' then
        out_pc <= (others => '0');
      else
        if rising_edge(clk) then
          out_pc <= out_mux;
        end if;
      end if;
   end process;

   -- Memoria de instrucciones
   -- TODO: Añadir memoria e instanciar
   prog_mem: entity work.ram port map(
        clock    => clk,
        we       => '0', -- no escribimos en esta memoria
        addr     => pc,
        data_in  => (others => '0'); -- no escribimos en esta memoria
        data_out => instr
   );

   -- Incrementador
    out_incr <= out_pc + 1;

    pc <= out_incr;

end architecture;
