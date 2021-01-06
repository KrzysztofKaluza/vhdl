library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SIEU_TEST is
end SIEU_TEST;

architecture Behavioral of SIEU_TEST is
    component SEQUENTIAL_INSTRUCTION_EXECUTE_UNIT is
        Port (  INT: in std_logic;
            Z: in std_logic;
            CLK: in std_logic;
            RESET: in std_logic;
            IOIN: in std_logic_vector(7 downto 0);
            IOOUT: out std_logic_vector(7 downto 0);
            IOADR: out std_logic_vector(7 downto 0);
            IOWR: out std_logic;
            IORD: out std_logic);
    end component;
    signal CLK_t : std_logic := '0';
    signal INT_t : std_logic := '0';
    signal IOWR_t : std_logic := '0';
    signal IORD_t : std_logic := '0';
    signal RESET_t : std_logic := '0';
    signal Z_t : std_logic := '0';
    signal IOIN_t :std_logic_vector(7 downto 0);
    signal IOOUT_t :std_logic_vector(7 downto 0);
    signal IOADR_t :std_logic_vector(7 downto 0);
    constant CLK_period : time := 10 ns;
begin
    g: SEQUENTIAL_INSTRUCTION_EXECUTE_UNIT port map (
        Z => Z_t,
        CLK => CLK_t,
        RESET => RESET_t,
        IOOUT => IOOUT_t,
        IOADR => IOADR_t,
        INT => INT_t,
        IOWR => IOWR_t,
        IORD => IORD_t,
        IOIN => IOIN_t
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
        wait for 200 ns;
        INT_t <= '1';
        wait for 1 ns;
        INT_t<= '0';
        wait;
    end process;
end Behavioral;
