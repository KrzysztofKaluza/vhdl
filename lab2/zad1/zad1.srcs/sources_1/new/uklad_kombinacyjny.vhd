library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uklad_kombinacyjny is
    Port ( X0 : in STD_LOGIC;
           X1 : in STD_LOGIC;
           Y0 : out STD_LOGIC;
           Y1 : out STD_LOGIC;
           Y2 : out STD_LOGIC;
           Y3 : out STD_LOGIC);
end uklad_kombinacyjny;

architecture Behavioral of uklad_kombinacyjny is
    signal S0: std_logic;
    signal S1: std_logic;
begin
    S0 <= not X0;
    S1 <= not X1;
    Y0 <= S0 and S1;
    Y1 <= S1 and X0;
    Y2 <= S0 and X1;
    Y3 <= X0 and X1;

end Behavioral;
