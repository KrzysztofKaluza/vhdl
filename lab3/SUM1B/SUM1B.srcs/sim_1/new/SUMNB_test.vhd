library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SUMNB_test is
--  Port ( );
end SUMNB_test;

architecture Behavioral of SUMNB_test is
    component SUMNB
        generic(N: natural := 8);
        port(CIN_u : in std_logic;
        B_u : in std_logic_vector(N-1 downto 0);
        A_u : in std_logic_vector(N-1 downto 0);
        Y_u : out std_logic_vector(N-1 downto 0);
        COUT_u : out std_logic
        );
    end component;
    
    signal A : std_logic_vector(2 downto 0) := (others => '0');
    signal B : std_logic_vector(2 downto 0) := (others => '0');
    signal CIN : std_logic := '0';
    signal Y : std_logic_vector(2 downto 0);
    signal COUT : std_logic;
    
begin
    SUM3B : SUMNB
    generic map (N => 3)
    port map ( A_u => A,
     B_u => B,
     CIN_u => CIN, 
     COUT_u => COUT, 
     Y_u => Y);
    process begin
        wait for 10 ns;
        A <= ('0', '1', '1');
        B <= ('1', '1', '0');
        wait;
    end process;
end Behavioral;
