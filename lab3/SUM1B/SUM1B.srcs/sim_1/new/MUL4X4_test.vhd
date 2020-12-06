library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUL4X4_test is
--  Port ( );
end MUL4X4_test;

architecture Behavioral of MUL4X4_test is
    component MUL4X4 is 
    Port (
        A_MUL : in std_logic_vector(3 downto 0);
        B_MUL : in std_logic_vector(3 downto 0);
        Y_MUL : out std_logic_vector(7 downto 0));
    end component;
    signal A: std_logic_vector(3 downto 0):= ('0','0','0','0');
    signal B: std_logic_vector(3 downto 0):= ('0','0','0','0');
    signal Y: std_logic_vector(7 downto 0);
begin
    mul: MUL4X4 port map( A_MUL => A, B_MUL=>B, Y_MUL=>Y);
    process
    begin 
        wait for 10 ns;
        A <= ('1','0','1','1');
        B <= ('1','1','0','1');
        wait;
    end process;

end Behavioral;
