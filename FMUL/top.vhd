LIBRARY ieee;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

library UNISIM;
use UNISIM.VComponents.all;

ENTITY FMUL_top IS
  port ( MCLK1 : in STD_LOGIC;
         RS_TX : out STD_LOGIc);
END FMUL_top;

ARCHITECTURE top OF FMUL_top IS 
  -- Component Declaration for the Unit Under Test (UUT)
  COMPONENT FMUL 
    Port (
      CLK     : in  STD_LOGIC;
      input_a  : in  STD_LOGIC_VECTOR (31 downto 0);
      input_b  : in  STD_LOGIC_VECTOR (31 downto 0);
      output  : out STD_LOGIC_VECTOR (31 downto 0));
  END COMPONENT;


  COMPONENT serialif 
    port (
      serialO : out std_logic;
      dataIN  : in  std_logic_vector(7 downto 0);
      send    : in  std_logic;
      full    : out std_logic;
      clk     : in  std_logic);
  END COMPONENT;

  type rom_t is array(0 to 7) of std_logic_vector(31 downto 0); 
  signal rom_addr : std_logic_vector(2 downto 0) := (others => '0');
  signal clk,iclk: std_logic;
  signal uart_send: std_logic := '0';
  signal uart_full: std_logic := '0';
  signal inp1: std_logic_vector (31 downto 0);
  signal inp2: std_logic_vector (31 downto 0);
  signal answer: std_logic_vector (7 downto 0);
  signal added : std_logic_vector (31 downto 0);
  signal added_a : std_logic_vector (31 downto 0);
  constant data1 : rom_t := ( "10110111100100111000001110010001",
                              "01001110001100101111001110011000",
                              "01000000101111010000001000100110",
                              "11101001000000010101010011001011",
                              "01101000100010010010110100000010",
                              "11101000100001000000000000110111",
                              "10110101001010100001011101111101",
                              "11001001111101101100101000101001");

  constant data2 : rom_t := ( "11101100111100111011100000111001",
                              "01011110101111000011101101010010",
                              "10111100000000101010000010011111",
                              "11001111011000100001101110111001",
                              "01010011110110110111110110111000",
                              "11001110000010001011110000000011",
                              "01011000110011101110000111101110",
                              "11010000100110110111110001100111");

  constant added_rom : rom_t := ( "01100101000011000111000000001010",
                               "01101101100000111001010001011011",
                               "10111101010000001110001101011100",
                               "01111000111001000111010110111001",
                               "01111100111010110011100110111101",
                               "01110111000011010000001000011110",
                               "11001110100010010111010100000011",
                               "01011011000101011110010001010100");



BEGIN
  ib: IBUFG port map (
    i=>MCLK1,
    o=>iclk);
  bg: BUFG port map (
    i=>iclk,
    o=>clk);

  faddr: FMUL 
    port map (
      CLK   =>clk,
      input_a=>inp1,
      input_b=>inp2,
      output=>added);


  serial: serialif --generic map (wtime =>x"1ADB")
    port map (
      serialO=>RS_TX,
      dataIN=>answer,
      send=>uart_send,
      full=>uart_full,
      clk=>clk);

  rom_if : process(clk)
  begin
    if rising_edge(clk) then
      inp1 <= data1(conv_integer(rom_addr));
      inp2 <= data2(conv_integer(rom_addr));
      added_a <= added_rom(conv_integer(rom_addr));
    end if;
  end process;

  comp : process(clk)
  begin
    if rising_edge(clk) then
      if added = added_a then
        answer <= x"84";
      else
        answer <= x"70";
      end if;
    end if;
  end process;

  send_meg : process(clk)
  begin
    if rising_edge(clk) then
      if uart_full='0' and uart_send='0' then
         uart_send<='1';
         rom_addr <= rom_addr+1;
      else
        uart_send<='0';
      end if;
    end if;
  end process;
end top; 
       
