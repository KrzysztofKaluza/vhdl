library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity zad5_test is
--  Port ( );
end zad5_test;

architecture Behavioral of zad5_test is
    component zad5 is
    Port(   x: in std_logic_vector(7 downto 0);
            sel: in std_logic_vector(2 downto 0);
            y: out std_logic);
    end component;
    signal x : std_logic_vector(7 downto 0):= ('1','0','1','0','1','0','1','0');
    signal sel : std_logic_vector(2 downto 0) := (others => '0');
    signal y : std_logic;
begin
    b0: zad5 port map (x => x, sel => sel, y => y);
    process
    begin
        wait for 10 ns;
        sel <= ('0','0','1');
        wait for 10 ns;
        sel <= ('0','1','0');
        wait for 10 ns;
        sel <= ('0','1','1');
        wait for 10 ns;
        sel <= ('1','0','0');
        wait for 10 ns;
        sel <= ('1','0','1');
        wait for 10 ns;
        sel <= ('1','1','0');
        wait for 10 ns;
        sel <= ('1','1','1');
        wait;
    end process;
end Behavioral;
