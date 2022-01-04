library IEEE;
use IEEE.std_logic_1164.all;

entity controleRx is
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
end controleRx;

architecture arch of controleRx is
begin

  process (clk, reset)

    variable buf    : std_logic_vector(7 downto 0);
    variable parite : std_logic;
    variable cpt    : integer;

    type etats is (REPOS, RECEPTION_DATA, RECEPTION_VERIF, RECEPTION_FIN, ATTENTE_READ);
    variable etat : etats;

  begin

    if reset = '0' then
      data <= (others => '0');
      FErr <= '0';
      OErr <= '0';
      DRdy <= '0';
      etat := REPOS;

    elsif rising_edge(clk) then
      case etat is
        when REPOS =>
          if tmpclk = '1' then
            FErr <= '0';
            OErr <= '0';
            DRdy <= '0';
            parite := '0';
            cpt    := 7;
            etat   := RECEPTION_DATA;
          end if;

        when RECEPTION_DATA =>
          if tmpclk = '1' then
            buf(cpt) := tmprxd;
            parite   := parite xor buf(cpt);
            cpt      := cpt - 1;

            if cpt = 0 then
              etat := RECEPTION_VERIF;
            else
              cpt := cpt - 1;
            end if;
          end if;

        when RECEPTION_VERIF =>
          if tmpclk = '1' then
            if not (tmprxd = parite) then
              FErr <= '1';
            else
              FErr <= '0';
            end if;
            etat := RECEPTION_FIN;
          end if;

        when RECEPTION_FIN =>
          if tmpclk = '1' then
            if not (tmprxd = '1') then
              FErr <= '1';
              DRdy <= '0';
              etat := REPOS;
            else
              DRdy <= '1';
              data <= buf;
              etat := ATTENTE_READ;
            end if;
          end if;

        when ATTENTE_READ =>
          DRdy <= '0';
          if read = '0' then
            OErr <= '1';
          end if;
          etat := REPOS;
      end case;

    end if;

  end process;

end arch;