library IEEE;
use IEEE.std_logic_1164.all;

entity compteur16 is
  port (
    reset  : in std_logic;
    enable : in std_logic; -- Horloge de réception
    rxd    : in std_logic; -- Entrée où les bits arrivent

    -- Signaux de sortie demandés sur la spécification, page 7, figure 6
    tmpClk : out std_logic;
    tmpRxd : out std_logic
  );
end compteur16;

architecture compteur16_arch of compteur16 is

  -- Etats du compteur 16 bits
  type etatsPossiblesCompteur16Coups is (
    auRepos,
    receptionBitDeStart,
    compter16Coups10fois
  );

  -- Etats utilisés pour le switch/case
  signal etatsCompteur16Coups : etatsPossiblesCompteur16Coups;

begin

  -- Notre horloge base est donc enable
  process (enable)
    -- Compteur pour la boucle IF dans l'état compter16Coups10fois
    variable compteurBoucleIf : integer;
    -- Compteur 8 coups d'enable lors de la réception du bit de start
    variable compteur8CoupsEnable : integer;
    -- Compteur 16 coups d'enable pour chaque bit reçu ensuite
    variable compteur16CoupsEnable : integer;
  begin

    -- On réinitialise les compteurs...
    if (reset = '0') then
      compteurBoucleIf      := 0;
      compteur8CoupsEnable  := 0;
      compteur16CoupsEnable := 0;
      tmpClk               <= '0';
      etatsCompteur16Coups <= auRepos;

      ------------------------------------
      -- On n'envoie rien avec tmpRxd ? --
      ------------------------------------

    elsif (rising_edge(enable)) then

      -- On vérifie les états possibles
      case(etatsCompteur16Coups) is
        when auRepos =>
        if (rxd = '0') then
          compteurBoucleIf     := 0;
          compteur8CoupsEnable := 0;
          etatsCompteur16Coups <= receptionBitDeStart;
        end if;

        -- Compteur de 0 à 7 pour attendre 8 coups d'enable après avoir reçu le bit de start
        when receptionBitDeStart =>
        if (compteur8CoupsEnable = 7) then
          tmpClk               <= '1';
          tmpRxd               <= rxd;
          etatsCompteur16Coups <= compter16Coups10fois;
        else
          compteur8CoupsEnable := compteur8CoupsEnable + 1;
        end if;

        -- Compteur de 0 à 9 car on a 10 bits à émettre pour chaque caractère tapé :
        --      8 bits de données de MSB à LSB
        --      1 bit de parité
        --      1 bit de stop
        --      Entre chaque bit on compte 16 coups d'enable avant d'émettre
        when compter16Coups10fois =>
        if (compteurBoucleIf < 10) then
          if (compteur16CoupsEnable = 15) then
            compteur16CoupsEnable := 0;
            compteurBoucleIf      := compteurBoucleIf + 1;
            tmpClk <= '1';
            tmpRxd <= rxd;
          else
            tmpClk <= '0';
            compteur16CoupsEnable := compteur16CoupsEnable + 1;
          end if;
        else
          etatsCompteur16Coups <= auRepos;
        end if;
      end case;
    end if;
  end process;
end compteur16_arch;