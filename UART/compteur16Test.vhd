--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:58:09 01/04/2022
-- Design Name:   
-- Module Name:   /home/nvu/projet-archi-ordi/UART/compteur16Test.vhd
-- Project Name:  uart
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: compteur16
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

entity compteur16Test is
end compteur16Test;

architecture behavior of compteur16Test is

  -- Component Declaration for the Unit Under Test (UUT)

  component compteur16
    port (
      reset  : in std_logic;
      enable : in std_logic;
      rxd    : in std_logic;
      tmpClk : out std_logic;
      tmpRxd : out std_logic
    );
  end component;

  --Inputs
  signal reset  : std_logic := '0';
  signal rxd    : std_logic := '0';
  signal enable : std_logic;

  --Outputs
  signal tmpClk : std_logic;
  signal tmpRxd : std_logic;

  -- Clock period definitions
  constant enable_period : time := 10 ns;
begin

  -- Instantiate the Unit Under Test (UUT)
  uut : compteur16 port map(
    reset  => reset,
    enable => enable,
    rxd    => rxd,
    tmpClk => tmpClk,
    tmpRxd => tmpRxd
  );

  -- Clock process definitions
  enable_process : process
  begin
    enable <= '0';
    wait for enable_period/2;
    enable <= '1';
    wait for enable_period/2;
  end process;
  -- Stimulus process
  stim_proc : process

    variable loop1, loop2 : integer;

  begin
    -- hold reset state for 100 ns.
    wait for 100 ns;
    reset <= '1';
    loop1 := 0;
    loop2 := 0;

    -- Réception du bit de start
    rxd <= '0';
    wait for enable_period * 8;
    -- 8 bits pour la touche tapée au clavier
    for loop1 in 0 to 3 loop
      rxd <= '1';
      wait for enable_period * 16;
    end loop;
    for loop2 in 0 to 3 loop
      rxd <= '0';
      wait for enable_period * 16;
    end loop;

    -- 1 bit de parité
    rxd <= '1';
    wait for enable_period * 16;

    -- Bit de stop
    rxd <= '1';
    wait for enable_period * 16;
    wait;
  end process;

end;