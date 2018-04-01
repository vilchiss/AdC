library ieee;
  use ieee.std_logic_1164.all;

entity sensa_boton is
  port (
    boton     : in      std_logic;
    clk       : in      std_logic;
    reloj     : out     std_logic;
    epresente : buffer  std_logic
  );
end sensa_boton;

architecture Behavioral of sensa_boton is
  signal esiguiente : std_logic;
begin

  process (esiguiente, boton) begin
    if rising_edge (clk) then
      case esiguiente is
        when '0'=>
          reloj <= '0';
          if boton = '0' then
            esiguiente <= '0';
          else
            esiguiente <= '1';
          end if;
        when '1'=>
          if boton = '1' then
            esiguiente <= '1';
            reloj      <= '0';
          else
            esiguiente <= '0';
            reloj      <= '1';
          end if;
        when others => null;
      end case;
    end if;
    epresente <= esiguiente;
  end process;

end Behavioral;
