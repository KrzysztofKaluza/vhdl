library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SIEU_TEST is
end SIEU_TEST;

architecture Behavioral of SIEU_TEST is
    component SEQUENTIAL_INSTRUCTION_EXECUTE_UNIT is
        Port (  Z: in std_logic;
            CLK: in std_logic;
            RESET: in std_logic;
            GPIO: out std_logic_vector(7 downto 0));
    end component;
    signal CLK_t : std_logic := '0';
    signal RESET_t : std_logic := '0';
    signal Z_t : std_logic := '0';
    signal GPIO_t :std_logic_vector(7 downto 0);
    constant CLK_period : time := 10 ns;
begin
    g: SEQUENTIAL_INSTRUCTION_EXECUTE_UNIT port map (
        Z => Z_t,
        CLK => CLK_t,
        RESET => RESET_t,
        GPIO => GPIO_t
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
        Z_t<= '1';
        wait;
    end process;
end Behavioral;
