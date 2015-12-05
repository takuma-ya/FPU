library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BarrelShifterLeft23 is
port(
   Data  : in std_logic_vector (27 downto 0);
   Shift : in std_logic_vector (4 downto 0);
   q     : out std_logic_vector (22 downto 0)
  );
end BarrelShifterLeft23 ;

architecture RTL of BarrelShifterLeft23 is

  signal Parameter1 : std_logic_vector(27 downto 0); 
  signal Parameter2 : std_logic_vector(27 downto 0);

begin

  Parameter1 <= Data(27 downto 0) when Shift (4 downto 3) = "00"
    else Data(19 downto 0) & "00000000" when Shift (4 downto 3) = "01"
    else Data(11 downto 0) & "0000000000000000" when Shift (4 downto 3) = "10"
    else Data(3  downto 0) & "000000000000000000000000";

  Parameter2 <= parameter1(23 downto 0) & "0000" when Shift(2) = '1'
    else Parameter1(27 downto 0);

  q <= Parameter2 (25 downto 3) when Shift(1 downto 0) = "00"
    else Parameter2 (24 downto 2) when Shift(1 downto 0) = "01"
    else Parameter2 (23 downto 1) when Shift(1 downto 0) = "10"
    else Parameter2 (22 downto 0);

end RTL; 
