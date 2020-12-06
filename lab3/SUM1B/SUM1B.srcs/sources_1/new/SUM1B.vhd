library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SUM1B is
    Port ( CIN : in std_logic;
           A : in std_logic;
           B : in std_logic;
           COUT: out std_logic;
           Y : out std_logic);
end SUM1B;

architecture Behavioral of SUM1B is

begin
    Y <= CIN xor B xor A;
    COUT <= (CIN and A) or (B and A) or (CIN and B);
end Behavioral;