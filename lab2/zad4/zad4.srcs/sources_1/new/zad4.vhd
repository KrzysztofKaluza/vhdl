library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity zad4 is
--  Port ( );
Port (     x : in std_logic_vector(3 downto 0);
           y : out STD_LOGIC_vector(1 downto 0));
end zad4;

architecture Behavioral of zad4 is

begin
    y <= "00" when x="0001" else
         "01" when x="0010" else
         "10" when x="0100" else
         "11" when x="1000" else
         "XX";

end Behavioral;
