----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.10.2020 15:52:33
-- Design Name: 
-- Module Name: zad3b - Behavioral
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

entity zad3b is
    Port ( x0 : in STD_LOGIC;
           x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           y : out STD_LOGIC);
end zad3b;

architecture Behavioral of zad3b is
    signal x: std_logic_vector(2 downto 0);
begin
    x <= (x2, x1, x0);
    y <= '1' when (x="000") or  (x="001") or (x="010") or (x="101") else
             '0';
end Behavioral;
    
