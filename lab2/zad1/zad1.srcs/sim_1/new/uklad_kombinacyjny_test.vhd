----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.10.2020 14:29:11
-- Design Name: 
-- Module Name: uklad_kombinacyjny_test - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uklad_kombinacyjny_test is

end uklad_kombinacyjny_test;

architecture Behavioral of uklad_kombinacyjny_test is
    component uklad_kombinacyjny is
    Port (  X0 : in std_logic;
            X1 : in std_logic;   
            Y0 : out std_logic;
            Y1 : out std_logic;
            Y2 : out std_logic;
            Y3 : out std_logic);
    end component;
    
    signal X0 : std_logic := '0';
    signal X1 : std_logic := '0';
    signal Y0 : std_logic;
    signal Y1 : std_logic;
    signal Y2 : std_logic;
    signal Y3 : std_logic;
begin
    b0: uklad_kombinacyjny port map (X0 => X0, X1 => X1, Y0 => Y0, Y1 => Y1, Y2 => Y2, Y3 => Y3);
    
    process
    begin
        wait for 10 ns;
        X0 <= '1';
        wait for 10 ns;
        X0 <= '0';
        X1 <= '1';
        wait for 10 ns;
        X0 <= '1';
        wait;
    end process;
end Behavioral;
