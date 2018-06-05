library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity stage1 is
  port(
      clk, branch, reset, load : in std_logic;
      dato_w : in unsigned(15 downto 0);
      PC : out unsigned(15 downto 0);
      instr : out unsigned(31 downto 0)
  );
end stage1;

architecture arch of stage1 is
 signal out_mux : unsigned(15 downto 0);
 signal out_PC : unsigned(15 downto 0);
 signal out_incr : unsigned(15 downto 0);

 begin
   -- Mux de branch
   process(branch, dato_w, out_incr)
    begin
      if branch = '0' then
        out_mux <= dato_w;
      else
        out_mux <= out_incr;
      end if;
    end process;

   -- Contador de programa
   process(clk, reset, load, out_mux)
    begin
      if reset = '1' then
        out_PC <= "0000000000000000";
      else
        if rising_edge(clk) then
          if load = '1' then
            out_PC <= out_mux;
          else
            out_PC <= out_PC;
          end if;
        end if;
      end if;
   end process;

   -- Memoria de instrucciones

   -- Incrementador
   process(clk, out_PC)
    begin
      if rising_edge(clk) then
        out_incr <= out_PC + 1;
      end if;
    end process;

    process(out_incr)
     begin
       PC <= out_incr;
    end process;

end architecture;
