LIBRARY IEEE, STD;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.std_logic_textio.ALL;
USE STD.TEXTIO.ALL;

ENTITY FMUL_testbench IS
END FMUL_testbench;

ARCHITECTURE testbench OF FMUL_testbench IS 
  -- Component Declaration for the Unit Under Test (UUT)
  COMPONENT FMUL 
    port(
      CLK     : in  STD_LOGIC;
      input_a  : in  STD_LOGIC_VECTOR (31 downto 0);
      input_b  : in  STD_LOGIC_VEcTOR (31 downto 0);
      output : out  STD_LOGIC_VECTOR (31  downto 0)); 
  END COMPONENT;

  file inv1  : text is in "/home/yamashita-takuma/CPU/fmul/a1_in.txt";
  file inv2  : text is in "/home/yamashita-takuma/CPU/fmul/a2_in.txt";
  file outv  : text is out "/home/yamashita-takuma/CPU/fmul/a_s_out.txt";

  --Inputs
  signal tb_input_a1  : std_logic_vector(31 downto 0) := x"3f800000";
  signal tb_input_a2  : std_logic_vector(31 downto 0) := x"3f800000";
  signal tb_output :  std_logic_vector(31 downto 0);

  --Simulation
  signal simclk : std_logic := '0';
BEGIN
  unit : FMUL PORT MAP (
    CLK    => simclk,
    input_a => tb_input_a1,
    input_b => tb_input_a2,
    output => tb_output);

  this_loops_forever : process(simclk)
    variable li1, li2, lo : line;
    variable vinp_a1, vinp_a2 : std_logic_vector(31 downto 0);
  begin
    if rising_edge(simclk) then
      readline(inv1, li1);
      readline(inv2, li2);
      read(li1, vinp_a1);
      read(li2, vinp_a2);
      tb_input_a1 <= vinp_a1;
      tb_input_a2 <= vinp_a2;
      write(lo,tb_output, LEFT,32);
      writeline(outv, lo);
    end if;
  end process; 
 
  -- generate clock for the simulation
  clockgen : process
  variable v : std_logic_vector(16 downto 0) := "00000000000000000";
  begin
    simclk <= '0';
    wait for 10 ns;
    simclk <= '1';
    wait for 10 ns;
    v := v + 1;
    if(v = "11000011010100101") then
      wait;
    end if;
  end process;
END;
