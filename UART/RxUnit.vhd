library IEEE;
use IEEE.std_logic_1164.all;

entity RxUnit is
  port (
    clk, reset       : in std_logic;
    enable           : in std_logic;
    read             : in std_logic;
    rxd              : in std_logic;
    data             : out std_logic_vector(7 downto 0);
    Ferr, OErr, DRdy : out std_logic);
end RxUnit;

architecture RxUnit_arch of RxUnit is

  component compteur16 is
    port (
      reset  : in std_logic;
      enable : in std_logic;
      rxd    : in std_logic;
      tmpClk : out std_logic;
      tmpRxd : out std_logic
    );
  end component;

  component controleRx is
    port (
      clk    : in std_logic;
      reset  : in std_logic;
      tmpclk : in std_logic;
      tmprxd : in std_logic;
      read   : in std_logic;
      data   : out std_logic_vector(7 downto 0);
      FErr   : out std_logic;
      OErr   : out std_logic;
      DRdy   : out std_logic
    );
  end component;

  signal tmpClk, tmpRxd : std_logic;

begin

  u_compteur16 : compteur16
  port map(
    reset  => reset,
    enable => enable,
    rxd    => rxd,
    tmpClk => tmpClk,
    tmpRxd => tmpRxd
  );

  u_controleRx : controleRx
  port map(
    clk    => clk,
    reset  => reset,
    tmpclk => tmpClk,
    tmprxd => tmpRxd,
    read   => read,
    data   => data,
    FErr   => FErr,
    OErr   => OErr,
    DRdy   => DRdy
  );

end RxUnit_arch;