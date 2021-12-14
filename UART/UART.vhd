library IEEE;
use IEEE.std_logic_1164.all;

entity UARTunit is
  port (
    clk, reset : in std_logic;
    cs, rd, wr : in std_logic;
    RxD        : in std_logic;
    TxD        : out std_logic;
    IntR, IntT : out std_logic;
    addr       : in std_logic_vector(1 downto 0);
    data_in    : in std_logic_vector(7 downto 0);
    data_out   : out std_logic_vector(7 downto 0));
end UARTunit;

architecture UARTunit_arch of UARTunit is

  -- a completer avec l'interface des differents composants
  -- de l'UART

  component clkUnit
    port (
      clk, reset : in std_logic;
      enableTX   : out std_logic;
      enableRX   : out std_logic
    );
  end component;

  component ctrlUnit
    port (
      clk, reset       : in std_logic;
      rd, cs           : in std_logic;
      DRdy, FErr, OErr : in std_logic;
      BufE, RegE       : in std_logic;
      IntR             : out std_logic;
      IntT             : out std_logic;
      ctrlReg          : out std_logic_vector(7 downto 0));
  end component;

  component TxUnit
    port (
      clk, reset : in std_logic;
      enable     : in std_logic;
      ld         : in std_logic;
      txd        : out std_logic;
      regE       : out std_logic;
      bufE       : out std_logic;
      data       : in std_logic_vector(7 downto 0));
  end component;

  component RxUnit
    port (
      clk, reset       : in std_logic;
      enable           : in std_logic;
      read             : in std_logic;
      rxd              : in std_logic;
      data             : out std_logic_vector(7 downto 0);
      Ferr, OErr, DRdy : out std_logic);
  end component;

  signal lecture, ecriture : std_logic;
  signal donnees_recues    : std_logic_vector(7 downto 0);
  signal registre_controle : std_logic_vector(7 downto 0);

  -- a completer par les signaux internes manquants

  signal enableTX, enableRX : std_logic; -- clkUnit
  signal Ferr, OErr, DRdy   : std_logic; -- RxUnit (vers ctrlUnit)
  signal BufE, RegE         : std_logic;

begin -- UARTunit_arch

  lecture  <= '1' when cs = '0' and rd = '0' else '0';
  ecriture <= '1' when cs = '0' and wr = '0' else '0';
  data_out <= donnees_recues when lecture = '1' and addr = "00"
    else registre_controle when lecture = '1' and addr = "01"
    else "00000000";

  -- a completer par la connexion des differents composants

  u_clkUnit : clkUnit
  port map(
    clk      => clk,
    reset    => reset,
    enableTX => enableTX,
    enableRX => enableRX
  );

  u_ctrlUnit : ctrlUnit
  port map(
    clk     => clk,
    reset   => reset,
    rd      => rd,
    cs      => cs,
    DRdy    => DRdy,
    FErr    => FErr,
    OErr    => OErr,
    BufE    => BufE,
    RegE    => RegE,
    IntR    => IntR,
    IntT    => IntT,
    ctrlReg => registre_controle
  );

  u_TxUnit : TxUnit
  port map(
    clk    => clk,
    reset  => reset,
    enable => enableTX,
    ld     => ecriture,
    txd    => txd,
    regE   => RegE,
    bufE   => BufE,
    data   => data_in
  );

  u_RxUnit : RxUnit
  port map(
    clk    => clk,
    reset  => reset,
    enable => enableRX,
    read   => lecture,
    rxd    => rxd,
    data   => donnees_recues,
    Ferr   => Ferr,
    OErr   => OErr,
    DRdy   => DRdy
  );

end UARTunit_arch;