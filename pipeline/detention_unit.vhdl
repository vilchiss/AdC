library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity detention_unit is
  port (
  selRegR : in unsigned(3 downto 0);
  selRegW_st3, selRegW_st4 : in unsigned(2 downto 0);
  selCtrl, PCWrite : out std_logic;
  reg_st1_write : out std_logic;
  bubble : out unsigned(33 downto 0)
  );
end entity;

architecture arch of detention_unit is

begin
  process(all)
  begin
    if (selRegR = x"1") and (selRegW_st3 = 1 or selRegW_st3 = 4 or selRegW_st4 = 4 or selRegW_st4 = 1) then
      PCWrite <= '0';
      reg_st1_write <= '0';
      selCtrl <= '1';
      bubble <= "0000000000000000000010000000010000";
    elsif (selRegR = x"2") and (selRegW_st3 = 2 or selRegW_st3 = 4 or selRegW_st4 = 4 or selRegW_st4 = 2) then
      PCWrite <= '0';
      reg_st1_write <= '0';
      selCtrl <= '1';
      bubble <= "0000000000000000000010000000010000";
    elsif (selRegR = x"3") and (selRegW_st3 = 3 or selRegW_st3 = 4 or selRegW_st4 = 4 or selRegW_st4 = 3) then
      PCWrite <= '0';
      reg_st1_write <= '0';
      selCtrl <= '1';
      bubble <= "0000000000000000000010000000010000";
    elsif (selRegR = x"4") and (selRegW_st3 = 1 or selRegW_st4 = 1) then
      PCWrite <= '0';
      reg_st1_write <= '0';
      selCtrl <= '1';
      bubble <= "0000000000000000000010000000010000";
    elsif (selRegR = x"5") and (selRegW_st3 = 4 or selRegW_st4 = 4) then
      PCWrite <= '0';
      reg_st1_write <= '0';
      selCtrl <= '1';
      bubble <= "0000000000000000000010000000010000";
    elsif (selRegR = x"6") and (selRegW_st3 = 1 or selRegW_st3 = 2 or selRegW_st4 = 2 or selRegW_st4 = 1) then
      PCWrite <= '0';
      reg_st1_write <= '0';
      selCtrl <= '1';
      bubble <= "0000000000000000000010000000010000";
    elsif (selRegR = x"7") and (selRegW_st3 = 1 or selRegW_st3 = 3 or selRegW_st4 = 3 or selRegW_st4 = 1) then
      PCWrite <= '0';
      reg_st1_write <= '0';
      selCtrl <= '1';
      bubble <= "0000000000000000000010000000010000";
    elsif (selRegR = x"8") and (selRegW_st3 = 5 or selRegW_st4 = 5) then
      PCWrite <= '0';
      reg_st1_write <= '0';
      selCtrl <= '1';
      bubble <= "0000000000000000000010000000010000";
    elsif (selRegR = x"9") and (selRegW_st3 = 2 or selRegW_st4 = 2) then
      PCWrite <= '0';
      reg_st1_write <= '0';
      selCtrl <= '1';
      bubble <= "0000000000000000000010000000010000";
    elsif (selRegR = x"A") and (selRegW_st3 = 3 or selRegW_st4 = 3) then
      PCWrite <= '0';
      reg_st1_write <= '0';
      selCtrl <= '1';
      bubble <= "0000000000000000000010000000010000";
    elsif (selRegR = x"B") and (selRegW_st3 = 6 or selRegW_st4 = 6) then
      PCWrite <= '0';
      reg_st1_write <= '0';
      selCtrl <= '1';
      bubble <= "0000000000000000000010000000010000";
    elsif (selRegR = x"C") and (selRegW_st3 = 1 or selRegW_st3 = 6 or selRegW_st4 = 6 or selRegW_st4 = 1) then
      PCWrite <= '0';
      reg_st1_write <= '0';
      selCtrl <= '1';
      bubble <= "0000000000000000000010000000010000";
    elsif (selRegR = x"D") and (selRegW_st3 = 6 or selRegW_st3 = 4 or selRegW_st4 = 4 or selRegW_st4 = 6) then
      PCWrite <= '0';
      reg_st1_write <= '0';
      selCtrl <= '1';
      bubble <= "0000000000000000000010000000010000";
    elsif (selRegR = x"E") and (selRegW_st3 = 2 or selRegW_st3 = 6 or selRegW_st4 = 6 or selRegW_st4 = 2) then
      PCWrite <= '0';
      reg_st1_write <= '0';
      selCtrl <= '1';
      bubble <= "0000000000000000000010000000010000";
    elsif (selRegR = x"F") and (selRegW_st3 = 3 or selRegW_st3 = 6 or selRegW_st4 = 6 or selRegW_st4 = 3) then
      PCWrite <= '0';
      reg_st1_write <= '0';
      selCtrl <= '1';
      bubble <= "0000000000000000000010000000010000";
    else
      PCWrite <= '1';
      reg_st1_write <= '1';
      selCtrl <= '0';
      bubble <= (others => '0'); -- No selecciona bubble por lo tanto no sale nada
    end if;
  end process;

end architecture;
