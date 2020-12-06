library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity LICZ8B is
--  Port ( );
    Port(
        SET: in std_logic;
        EN: in std_logic;
        DIR: in std_logic;
        CLK: in std_logic;
        RESET: in std_logic; 
        X: in std_logic_vector(7 downto 0);
        Y: out std_logic_vector(7 downto 0)
    );
end LICZ8B;

architecture Behavioral of LICZ8B is
    signal CNT: unsigned(7 downto 0) := (others => '0');
begin
    process (RESET, CLK)
    begin
        if RESET = '1' then
            CNT <= (others => '0');
        elsif rising_edge(CLK) then
            if EN ='1' then
                if SET = '1' then
                    CNT <= unsigned(X);
                else
                    if DIR = '1' then
                        CNT <= CNT + 1;
                    else
                        CNT <= CNT - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    Y <= std_logic_vector(CNT);
end Behavioral;
