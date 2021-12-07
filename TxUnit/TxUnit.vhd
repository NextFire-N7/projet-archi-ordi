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
    choixReposEmission
  );

  signal etatsUniteEmission : etatsPossiblesUniteEmission;

  -- A la base le registre et le buffer sont libres
  signal registreLibre : std_logic;
  signal bufferLibre   : std_logic;

begin

  regE <= registreLibre;
  bufE <= bufferLibre;

  process (clk, reset)

    variable bufferT, registerT : std_logic_vector(7 downto 0);
    variable cpt                : integer;
    variable parite             : std_logic;

  begin

    if (reset = '0') then
      -- reset variables
      registreLibre      <= '1';
      bufferLibre        <= '1';
      txd                <= '1';
      etatsUniteEmission <= auRepos;

    elsif rising_edge(clk) then
      case(etatsUniteEmission) is
        when auRepos => -- 000
        if (ld = '1') then
          -- preparation de l'emission
          bufferT := data;
          bufferLibre        <= '0';
          etatsUniteEmission <= preparationEmission;
        end if;

        when preparationEmission => -- 001
        registerT := bufferT;
        bufferLibre        <= '1';
        registreLibre      <= '0';
        etatsUniteEmission <= envoiBitDeStart;

        when envoiBitDeStart => -- 010 possible remettre données dans registre
        -- Vérification nouvelles données en attente
        if (ld = '1' and bufferLibre = '1') then
          bufferT := data;
          bufferLibre <= '0';
        end if;
        if (enable = '1') then
          txd <= '0';
          cpt    := 7;
          parite := '0';
          etatsUniteEmission <= emissionOctet;
        end if;

        when emissionOctet => -- 011 possible remettre données dans registre
        -- Vérification nouvelles données en attente
        if (ld = '1' and bufferLibre = '1') then
          bufferT := data;
          bufferLibre <= '0';
        end if;
        if (enable = '1') then
          txd <= registerT(cpt);
          parite := parite xor registerT(cpt);
          if (cpt = 0) then
            registreLibre      <= '1';
            etatsUniteEmission <= emissionBitsPariteStop;
          else
            cpt := cpt - 1;
          end if;
        end if;

        when emissionBitsPariteStop => -- 100 possible remettre données dans registre
        -- Vérification nouvelles données en attente
        if (ld = '1' and bufferLibre = '1') then
          bufferT := data;
          bufferLibre <= '0';
        end if;
        -- émission des bits de parité et de stop
        if (enable = '1') then
          txd                <= parite;
          etatsUniteEmission <= choixReposEmission;
        end if;

        when choixReposEmission => -- 101 possible remettre données dans registre
        -- Vérification nouvelles données en attente (???)
        if (ld = '1' and bufferLibre = '1') then
          bufferT := data;
          bufferLibre <= '0';
        end if;
        -- choix du branchement si quelque chose est déjà présent dans le buffer
        if (enable = '1') then
          txd <= '1';
          if (bufferLibre = '1') then
            -- retour en idle
            etatsUniteEmission <= auRepos;
          else
            -- suite émission
            etatsUniteEmission <= preparationEmission;
          end if;
        end if;

      end case;
    end if;

  end process;

end behavorial;