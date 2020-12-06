library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity DECODE_PARSE_STRING_test is
end DECODE_PARSE_STRING_test;

architecture Behavioral of DECODE_PARSE_STRING_test is
    component DECODE_PARSE_STRING is
        Port(   D : in std_logic_vector (7 downto 0);
            CLK : in std_logic;
            RESET : in std_logic;
            F : out std_logic_vector (3 downto 0);
            ARG : out std_logic_vector(6 downto 0);
            RCVD : out std_logic);
    end component;
    signal D_t :std_logic_vector(7 downto 0);
    signal F_t : std_logic_vector (3 downto 0);
    signal ARG_t : std_logic_vector (6 downto 0);
    signal RCVD_t : std_logic := '0';
    signal CLK_t : std_logic := '0';
    signal RESET_t : std_logic := '0';
    constant CLK_period : time := 10 ns;
begin
    g: DECODE_PARSE_STRING port map (
        D => D_t,
        F => F_t,
        CLK => CLK_t,
        RESET => RESET_t,
        ARG => ARG_t,
        RCVD => RCVD_t
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
    provide_data : process
    begin
        wait for 21 ns;
        D_t <= x"43";
        wait for 10 ns;
        D_t <= x"36";
        wait for 10 ns;
        D_t <= x"32";
        wait for 10 ns;
        D_t <= x"35";
        wait for 10 ns;
        D_t <= x"34";
        wait for 10 ns;
        D_t <= x"3A";
        wait for 10 ns;
        D_t <= x"43";
        wait for 10 ns;
        D_t <= x"38";
        wait for 10 ns;
        D_t <= x"31";
        wait for 10 ns;
        D_t <= x"35";
        wait for 10 ns;
        D_t <= x"3A";
        wait for 10 ns;
        D_t <= x"43";
        wait for 10 ns;
        D_t <= x"33";
        wait for 10 ns;
        D_t <= x"30";
        wait for 10 ns;
        D_t <= x"3A";
        wait;
    end process;
    
end Behavioral;
