library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SUM1B_test is

end SUM1B_test;

architecture Behavioral of SUM1B_test is
    component SUM1B is
        Port(CIN : in std_logic;
        B: in std_logic;
        A: in std_logic;
        COUT: out std_logic;
        Y: out std_logic);
    end component;
    signal CIN : std_logic := '0';
    signal B : std_logic := '0';
    signal A : std_logic := '0';
    signal Y : std_logic;
    signal COUT : std_logic;
begin
    SUM : SUM1B port map (CIN => CIN, B => B, A => A, Y => Y, COUT => COUT);
    process
    begin
        wait for 10 ns;
        A <= '1';
        wait for 10 ns;
        A <= '0';
        B <= '1';
        wait for 10 ns;
        A <= '1';
        wait for 10 ns;
        A <= '0';
        B <= '0';
        CIN <= '1';
        wait for 10 ns;
        A <= '1';
        wait for 10 ns;
        A <= '0';
        B <= '1';
        wait for 10 ns;
        A <= '1';
        wait;
    end process;
end Behavioral;
