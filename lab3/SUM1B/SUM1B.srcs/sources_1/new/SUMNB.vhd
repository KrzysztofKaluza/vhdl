library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SUMNB is
    generic (N: natural := 8);
    Port ( CIN_u : in std_logic;
        B_u : in std_logic_vector(N-1 downto 0);
        A_u : in std_logic_vector(N-1 downto 0);
        Y_u : out std_logic_vector(N-1 downto 0);
        COUT_u : out std_logic);
end SUMNB;

architecture Behavioral of SUMNB is
    component SUM1B is
    Port(CIN : in std_logic;
        B: in std_logic;
        A: in std_logic;
        COUT: out std_logic;
        Y: out std_logic);
    end component;
    signal COUT_in : std_logic_vector(N-1 downto 0);
    signal CIN_in : std_logic_vector(N-1 downto 0);
begin
    CIN_in(0) <= CIN_u;
    g: for i in 0 to N-1 generate
        i0: if i=0 generate
            sum: SUM1B port map (A => A_u(i), B => B_u(i), CIN => CIN_in(i), Y => Y_u(i), COUT => CIN_in(i+1));
        end generate i0;
        ina: if i > 0 and i < N-1 generate
            sum: SUM1B port map (A => A_u(i), B => B_u(i), CIN => CIN_in(i), Y => Y_u(i), COUT => CIN_in(i+1));
        end generate ina;
        inL: if i = N-1 generate
            sum: SUM1B port map (A => A_u(i), B => B_u(i), CIN => CIN_in(i), Y => Y_u(i), COUT => COUT_u);
        end generate inL;
    end generate g;

end Behavioral;
