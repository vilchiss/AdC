library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity micro is
  port (
    bt0, bt1: in std_logic;
    switch: in std_logic_vector(3 downto 0);
    led: out std_logic_vector(7 downto 0)
  );
end entity;

architecture arch of micro is
    --Memoria
    data_out     : std_logic_vector(7 downto 0);
    data_out_X0  : std_logic_vector(7 downto 0);
    data_out_X1  : std_logic_vector(7 downto 0);
    data_out_X2  : std_logic_vector(7 downto 0);
    -- Procesador
    Data_s        :   unsigned(7 downto 0); -- Bus de datos de 8 bits
    Dir_s         :   unsigned(15 downto 0); -- Bus de direcciones de 16 bits
    nRW_s         :   std_logic := '1'; -- Señal para escribir en memoria
    -- Debug
    PC_low_s      :   unsigned(7 downto 0);
    e_presente_s  :   unsigned(7 downto 0);
    A_s           :   unsigned(7 downto 0);
    B_s           :   unsigned(7 downto 0);
    X_low_s       :   unsigned(7 downto 0);
    X_high_s      :   unsigned(7 downto 0);
    Y_low_s       :   unsigned(7 downto 0);
    D_s           :   unsigned(15 downto 0);
    flags_s       :   std_logic_vector(7 downto 0);

    entity work.

    case( switch ) is

        when "0000" =>
            ;
        when "0001" =>
            ;
        when "0010" =>
            ;
        when "0011" =>
            ;
        when "0100" =>
            ;
        when "0101" =>
            ;
        when "0110" =>
            ;
        when "0111" =>
            ;
        when "1000" =>
            ;
        when "1001" =>
            ;
        when "1010" =>
            ;
        when "1011" =>
            ;
        when "1100" =>
            ;

        when others =>
            ;

    end case;

end architecture;