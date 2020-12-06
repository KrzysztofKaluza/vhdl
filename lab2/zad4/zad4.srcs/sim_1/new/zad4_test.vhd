----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.10.2020 09:33:23
-- Design Name: 
-- Module Name: zad4_test - Behavioral
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

entity zad4_test is
--  Port ( );
end zad4_test;

architecture Behavioral of zad4_test is
    component zad4 is
    Port(
        x : in std_logic_vector(3 downto 0);
        y : out std_logic_vector(1 downto 0));
    end component;
    signal x : std_logic_vector(3 downto 0) := (others => '0');
    signal y : std_logic_vector(1 downto 0);
    
begin
    b0: zad4 port map (x=>x, y=>y);
    process
    begin
        wait for 10 ns;
            x <= ('0','0','0','1');
        wait for 10 ns;
            x <= ('0','0','1','0');
        wait for 10 ns;
            x <= ('0','1','0','0');
        wait for 10 ns;
            x <= ('1','0','0','0');
        wait for 10 ns;
            x <= ('1','0','1','0');
        wait;
    end process;
end Behavioral;
