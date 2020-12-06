

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity zad3_test is
--  Port ( );
end zad3_test;

architecture Behavioral of zad3_test is
    component zad3_test is
    Port (x0 : in std_logic;
          x1 : in std_logic;
          x2 : in std_logic;
          y : out std_logic);
    end component;
    signal x0 : std_logic := '0';
    signal x1 : std_logic := '0';
    signal x2 : std_logic := '0';
    signal y : std_logic;
begin
    b0: zad3_test port map (x0 => x0, x1 => x1, x2 => x2, y => y);
    process
    begin
        wait for 10 ns;
        x0 <= '1';
        wait for 10 ns;
        x0 <= '0';
        x1 <= '1';
        wait for 10 ns;
        x0 <= '1';
        wait for 10 ns;
        x0 <= '0';
        x1 <= '0';
        x2 <= '1';
        wait for 10 ns;
        x0 <= '1';
        wait for 10 ns;
        x0 <= '0';
        x1 <= '1';
        wait for 10 ns;
        x0 <= '1';
        wait;
    end process;
end Behavioral;