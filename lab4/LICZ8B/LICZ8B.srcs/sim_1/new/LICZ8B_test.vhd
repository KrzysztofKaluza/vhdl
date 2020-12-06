library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LICZ8B_test is
--  Port ( );
end LICZ8B_test;

architecture Behavioral of LICZ8B_test is
    component LICZ8B
    port(
        SET: in std_logic;
        EN: in std_logic;
        DIR: in std_logic;
        CLK: in std_logic;
        RESET: in std_logic; 
        X: in std_logic_vector(7 downto 0);
        Y: out std_logic_vector(7 downto 0)
    );
    end component;
    signal SETi : std_logic := '0';
    signal ENi : std_logic := '0';
    signal DIRi : std_logic := '0';
    signal CLKi : std_logic := '0';
    signal RESETi : std_logic := '0';
    signal Xi: std_logic_vector(7 downto 0);
    signal Yi: std_logic_vector(7 downto 0);
    constant CLK_period : time := 10 ns;
begin
    Xi <= ('1','0','1','1', others => '0');
    licz: LICZ8B port map (
        SET => SETi,
        EN => ENi,
        DIR => DIRi,
        CLK => CLKi,
        RESET => RESETi,
        X => Xi,
        Y => Yi
    );
    CLK_process : process
    begin
        CLKi <= '0';
        wait for CLK_period/2;
        CLKi <= '1';
        wait for CLK_period/2;
    end process;
    res_proc: process
    begin
        RESETi <= '1';
        SETi <= '1';
        wait for 20 ns;
        RESETi <= '0';
        DIRi <= '0';
        ENi <= '1';
        SETi <= '0';
        wait;
    end process;
end Behavioral;
