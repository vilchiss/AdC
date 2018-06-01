library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity micro is
    port (
        bt0     :   in std_logic;
        bt1     :   in std_logic;
        switch  :   in unsigned(3 downto 0);
        leds    :   out unsigned(7 downto 0)
    );
end entity;

architecture arch of micro is
    --Memoria
    --data_out_s    : unsigned(7 downto 0);
    signal data_out_X0_s :   unsigned(7 downto 0);
    signal data_out_X1_s :   unsigned(7 downto 0);
    signal data_out_X2_s :   unsigned(7 downto 0);
    -- Procesador
    signal clk_s         :   std_logic;
    signal reset_s       :   std_logic;
    signal nIRQ_s        :   std_logic;
    signal nXIRQ_s       :   std_logic;
    signal Data_in_s     :   unsigned(7 downto 0);
    signal Data_out_s    :   unsigned(7 downto 0); -- Bus de datos de 8 bits
    signal Dir_s         :   unsigned(15 downto 0); -- Bus de direcciones de 16 bits
    signal nRW_s         :   std_logic := '1'; -- Señal para escribir en memoria
    -- Debug
    signal PC_low_s      :   unsigned(7 downto 0);
    signal e_presente_s  :   unsigned(7 downto 0);
    signal A_s           :   unsigned(7 downto 0);
    signal B_s           :   unsigned(7 downto 0);
    signal X_low_s       :   unsigned(7 downto 0);
    signal X_high_s      :   unsigned(7 downto 0);
    signal Y_low_s       :   unsigned(7 downto 0);
    signal Y_high_s      :   unsigned(7 downto 0);
    signal flags_s       :   unsigned(7 downto 0);

begin

    mem: entity work.memoria_programa port map(
        dir         => Dir_s,
        data_in     => Data_out_s,
        data_out    => Data_in_s,
        nRW         => nRW_S,
        data_out_X0 => data_out_X0_s,
        data_out_X1 => data_out_X1_s,
        data_out_X2 => data_out_X2_s
    );

    micro: entity work.micro68HC11 port map(
        clk             => clk_s,
        reset           => reset_s,
        nXIRQ           => nXIRQ_s,
        nIRQ            => nIRQ_s,
        Data_in         => Data_in_s,
        Data_out        => Data_out_s,
        Dir             => Dir_s,
        nRW             => nRW_s,
        PC_low_out      => PC_low_s,
        e_presente_out  => e_presente_s,
        A_out           => A_s,
        B_out           => B_s,
        X_low_out       => X_low_s,
        X_high_out		=> X_high_s,
        Y_low_out       => Y_low_s,
        flags           => flags_s
    );


    -- Botones
    clk_s     <= bt1;

    switch_p : process(switch)
    begin
            case (switch) is
                when "1000" =>
                    nIRQ_s  <= bt0;
                    nXIRQ_s <= '1';
                    reset_s <= '1';
                when "1100" =>
                    nXIRQ_s <= bt0;
                    nIRQ_s  <= '1';
                    reset_S <= '1';
                when others =>
                    reset_S <= bt0;
                    nXIRQ_s <= '1';
                    nIRQ_s  <= '1';
            end case;

            case (switch) is
                when "0000" =>
                    leds <= Data_in_s;
                when "0001" =>
                    leds <= Data_out_s;
                when "0010" =>
                    leds <= Dir_s(7 downto 0);
                when "0011" =>
                    leds <= Dir_s(15 downto 8);
                when "0100" =>
                    leds <= PC_low_s;
                when "0101" =>
                    leds <= e_presente_s;
                when "0110" =>
                    leds <= A_s;
                when "0111" =>
                    leds <= B_s;
                when "1000" =>
                    leds <= X_low_s;
                when "1001" =>
                    leds <= X_high_s;
                when "1010" =>
                    leds <= Y_low_s;
                when "1011" =>
                    leds <= Y_high_s;
                when "1100" =>
                    leds <= data_out_X0_s;
                when "1101" =>
                    leds <= data_out_X1_s;
                when "1110" =>
                    leds <= data_out_X2_s;
                when "1111" =>
                    leds <= flags_s;
                when others =>
                    leds <= (others => '1');
            end case;
    end process;


end architecture;
