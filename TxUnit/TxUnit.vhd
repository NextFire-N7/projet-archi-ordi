library IEEE;
use IEEE.std_logic_1164.all;

entity TxUnit is
  port (
    clk, reset : in std_logic;
    enable     : in std_logic;
    ld         : in std_logic;
    txd        : out std_logic;
    regE       : out std_logic;
    bufE       : out std_logic;
    data       : in std_logic_vector(7 downto 0));
end TxUnit;

architecture behavorial of TxUnit is

  type etatsPossiblesUniteEmission is (
    auRepos,
    preparationEmission,
    envoiBitDeStart,
    emissionOctet,
    emissionBitsPariteStop,
    choixReposEmission,
  );

begin

  process (clk, rst)

    variable etatsUniteEmission : etatsPossiblesUniteEmission;
    signal bufferT, registerT   : std_logic_vector(7 downto 0);

  begin

    if (reset = '0') then
      -- reset variables
      etatsUniteEmission <= auRepos;

    elsif rising_edge(clk) then
      case(etatsUniteEmission) is

        when auRepos =>

        when preparationEmission =>

        when envoiBitDeStart =>

        when emissionOctet =>

        when emissionBitsPariteStop =>

        when choixReposEmission =>

        when others =>

      end case;
    end if;

  end process;

end behavorial;