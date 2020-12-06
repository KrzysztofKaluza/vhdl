library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUL4X4 is
--  Port ( );
    Port (
        A_MUL : in std_logic_vector(3 downto 0);
        B_MUL : in std_logic_vector(3 downto 0);
        Y_MUL : out std_logic_vector(7 downto 0));
end MUL4X4;

architecture Behavioral of MUL4X4 is
    component SUMNB is
    generic(N: natural := 8);
    Port(CIN_u : in std_logic;
        B_u: in std_logic_vector(7 downto 0);
        A_u: in std_logic_vector(7 downto 0);
        COUT_u: out std_logic;
        Y_u: out std_logic_vector(7 downto 0));
    end component;
    signal Y: std_logic_vector(7 downto 0);
    signal m0: std_logic_vector(7 downto 0);
    signal m1: std_logic_vector(7 downto 0);
    signal m2: std_logic_vector(7 downto 0);
    signal m3: std_logic_vector(7 downto 0);
    signal s0: std_logic_vector(7 downto 0);
    signal s1: std_logic_vector(7 downto 0);
begin
    m0 <= ('0','0','0','0') & A_MUL when B_MUL(0) = '1' else (7 downto 0 => '0');
    m1 <= ('0','0','0') & A_MUL & '0' when B_MUL(1) = '1' else (7 downto 0 => '0');
    m2 <= ('0','0') & A_MUL & ('0','0') when B_MUL(2) = '1' else (7 downto 0 => '0');
    m3 <= '0' & A_MUL & ('0','0','0') when B_MUL(3) = '1' else (7 downto 0 => '0');
    
    sum0: SUMNB port map (CIN_u => '0', B_u=> m1, A_u => m0, Y_u => s0, COUT_u => open);
    sum1: SUMNB port map (CIN_u => '0', B_u => m2, A_u => s0, Y_u => s1, COUT_u => open);
    sum2: SUMNB port map (CIN_u => '0', B_u => m3, A_u => s1, Y_u => Y_MUL, COUT_u => open);
    
end Behavioral;
