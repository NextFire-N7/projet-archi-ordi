--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:38:56 01/04/2022
-- Design Name:   
-- Module Name:   /home/nvu/projet-archi-ordi/UART/RxUnitTest.vhd
-- Project Name:  uart
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RxUnit
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

entity RxUnitTest is
end RxUnitTest;

architecture behavior of RxUnitTest is

  -- Component Declaration for the Unit Under Test (UUT)

  component RxUnit
    port (
      clk    : in std_logic;
      reset  : in std_logic;
      enable : in std_logic;
      read   : in std_logic;
      rxd    : in std_logic;
      data   : out std_logic_vector(7 downto 0);
      Ferr   : out std_logic;
      OErr   : out std_logic;
      DRdy   : out std_logic
    );
  end component;

  component clkUnit
    port (
      clk, reset : in std_logic;
      enableTX   : out std_logic;
      enableRX   : out std_logic
    );
  end component;

  --Inputs
  signal clk   : std_logic := '0';
  signal reset : std_logic := '0';
  signal read  : std_logic := '0';
  signal rxd   : std_logic := '0';

  --Outputs
  signal data : std_logic_vector(7 downto 0);
  signal Ferr : std_logic;
  signal OErr : std_logic;
  signal DRdy : std_logic;

  -- Clock period definitions
  constant clk_period : time := 10 ns;

  -- clkUnit
  signal enableTX : std_logic;
  signal enableRX : std_logic;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : RxUnit port map(
    clk    => clk,
    reset  => reset,
    enable => enableRX,
    read   => read,
    rxd    => rxd,
    data   => data,
    Ferr   => Ferr,
    OErr   => OErr,
    DRdy   => DRdy
  );

  u_clkUnit : clkUnit
  port map(
    clk      => clk,
    reset    => reset,
    enableTX => enableTX,
    enableRX => enableRX
  );

  -- Clock process definitions
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

  -- Stimulus process
  stim_proc : process
    variable message : std_logic_vector(7 downto 0);
    variable parite  : std_logic;
  begin
    -- hold reset state for 100 ns.
    wait for 100 ns;
    reset <= '1';

    -- repos
    rxd <= '1';
    wait until enableTX = '1';

    -- bit de start
    rxd <= '0';
    wait until enableTX = '0';

    message := "01110101";
    parite  := '0';

    -- message
    for i in 7 downto 0 loop
      wait until enableTX = '1';
      rxd <= message(i);
      wait until enableTX = '0';
      parite := parite xor message(i);
    end loop;
    wait until enableTX = '1';

    -- bit de parité
    rxd <= parite;
    wait until enableTX = '0';
    wait until enableTX = '1';

    -- bit de stop
    rxd <= '1';
    wait until enableTX = '0';

    wait;
  end process;

end;