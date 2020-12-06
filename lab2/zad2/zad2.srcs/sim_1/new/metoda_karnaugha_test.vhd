

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity metoda_karnaugha_test is
--  Port ( );
end metoda_karnaugha_test;

architecture Behavioral of metoda_karnaugha_test is
    component metoda_karnaugha is
    Port (x : in std_logic_vector(2 downto 0);
          y : out std_logic);
    end component;
    signal x : std_logic_vector(2 downto 0) :=  ('0', '0', '0');
    signal y : std_logic;
begin
    b0: metoda_karnaugha port map (x => x, y => y);
    process
    begin
        wait for 10 ns;
        x(0) <= '1';
        wait for 10 ns;
        x(0) <= '0';
        x(1) <= '1';
        wait for 10 ns;
        x(0) <= '1';
        wait for 10 ns;
        x(0) <= '0';
        x(1) <= '0';
        x(2) <= '1';
        wait for 10 ns;
        x(0) <= '1';
        wait for 10 ns;
        x(0) <= '0';
        x(1) <= '1';
        wait for 10 ns;
        x(0) <= '1';
        wait;
    end process;
end Behavioral;
