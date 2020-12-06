----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.10.2020 15:26:27
-- Design Name: 
-- Module Name: zad3 - Behavioral
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

entity zad3 is
    Port ( x : std_logic_vector(2 downto 0);
           y : out STD_LOGIC);
end zad3;
    
architecture Behavioral of zad3 is
    
begin
    with x select
        y <= '1' when "000" | "001" | "010" | "101",
             '0' when others;
end Behavioral;
