library IEEE;
use IEEE.std_logic_1164.all;

entity clkUnit is
  port (
    clk, reset : in std_logic;
    enableTX   : out std_logic;
    enableRX   : out std_logic
  );

end clkUnit;

architecture behavorial of clkUnit is

  component diviseurClk is
    generic (facteur : natural);
    port (
      clk, reset : in std_logic;
      nclk       : out std_logic);
  end component;

begin

  -- Facteur 16 : l'horloge est de base à 155kHz ici;
  --              Le facteur sera de 645 pour l'UART et sur la carte
  -- enableTX a une horloge 16 fois moins rapide que enableRX
  u_diviseurClk : diviseurClk
  generic map(16)
  port map(
    -- ports
    clk   => clk,
    reset => reset,
    nclk  => enableTX
  );

  -- enableRX est directement branchée sur nclk ( ~= même fréquence )
  enableRX <= clk when (reset = '1') else '0';

end behavorial;