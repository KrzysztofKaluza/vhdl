library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NEW_1010_DETECTOR_test is
end NEW_1010_DETECTOR_test;

architecture Behavioral of NEW_1010_DETECTOR_test is
component NEW_1010_DETECTOR is
     port (I : in STD_LOGIC;
        O : out STD_LOGIC;
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC);
    end component;
    signal I_t: std_logic;
    signal O_t: std_logic := '0';
    signal CLK_t : std_logic := '0';
    signal RESET_t : std_logic := '0';
    
    constant CLK_period : time := 10 ns;
begin
    g: NEW_1010_DETECTOR port map (
        I => I_t,
        O => O_t,
        CLK => CLK_t,
        RESET => RESET_t
    );
     CLK_process :process
        begin
        CLK_t <= '0';
        wait for CLK_period/2;
        CLK_t <= '1';
        wait for CLK_period/2;
    end process;
     reset_process : process
    begin
        RESET_t <= '1';
        wait for 20 ns;
        RESET_t <= '0';
        wait;
    end process;
    input_process: process
    begin
        I_t <= '0';
        wait for 34 ns;
        I_t <= '1';
        wait for 12 ns;
        I_t <= '0';
        wait for 10 ns;
        I_t <= '1';
        wait for 10 ns;
        I_t <= '0';
        wait for 10 ns;
        I_t <= '1';
        wait for 10 ns;
        I_t <= '0';
        wait;
    end process;
end Behavioral;
