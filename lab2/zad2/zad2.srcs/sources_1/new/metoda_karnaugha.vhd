----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.10.2020 15:03:46
-- Design Name: 
-- Module Name: metoda_karnaugha - Behavioral
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

entity metoda_karnaugha is
    Port ( x : in STD_LOGIC_VECTOR(2 downto 0);
           y : out STD_LOGIC);
end metoda_karnaugha;

architecture Behavioral of metoda_karnaugha is

begin  
   y <= (not x(2) and not x(0)) or (not x(1) and x(0));
end Behavioral;
