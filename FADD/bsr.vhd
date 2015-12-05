library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BarrelShifterRight25 is
port(
  Data    : in STD_LOGIC_VECTOR (24 downto 0);
  Shift   : in STD_LOGIC_VECTOR (4  downto 0);
  q       : out STD_LOGIC_VECTOR (27 downto 0)
);
end BarrelShifterRight25;

architecture RTL of BarrelShifterRight25 is

  signal Parameter1 : std_logic_vector (27 downto 0);
  signal Parameter2 : std_logic_vector (27 downto 0);
  signal Round      : std_logic_vector (3  downto 0);

begin
-- shiftの下位2bitを見てDataをシフト
  Parameter1 <= Data & "000" when Shift(1 downto 0) = "00" else
                '0' & Data & "00" when Shift (1 downto 0) = "01" else
                "00" & Data & '0' when Shift (1 downto 0) = "10" else
                "000" & Data when shift(1 downto 0) = "11";

  Round(0) <= '1' when Parameter1 (4 downto 0) /= "00000" else '0';

-- shiftの3bit目を見てDataをシフト
  Parameter2 <= Parameter1 when Shift(2) = '0'
           else "0000" & Parameter1 (27 downto 5) & Round(0);

  Round(1) <= '0' when Parameter2 (8  downto 0) = "000000000" else '1';
  Round(2) <= '0' when Parameter2 (16 downto 0) = "00000000000000000" else '1';
  Round(3) <= '0' when Parameter2 (24 downto 0) = "0000000000000000000000000" else '1';

  q        <= Parameter2 when Shift (4 downto 3) = "00"
         else "00000000" & Parameter2 (27 downto 9) & Round(1)
                         when Shift (4 downto 3) = "01"
         else "0000000000000000" & Parameter2 (27 downto 17) & Round(2)
                         when Shift (4 downto 3) = "10"
         else "000000000000000000000000" & Parameter2 (27 downto 25) & Round(3)
                         when Shift (4 downto 3) = "11";


  end RTL;

