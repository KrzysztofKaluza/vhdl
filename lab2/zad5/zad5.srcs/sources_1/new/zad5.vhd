----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.10.2020 10:28:35
-- Design Name: 
-- Module Name: zad5 - Behavioral
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


entity zad5 is
--  Port ( );
    Port ( x : in std_logic_vector(7 downto 0);
           sel : in std_logic_vector(2 downto 0);
           y : out std_logic);
end zad5;

architecture Behavioral of zad5 is

begin
    with sel select
        y <=    x(0) when "000",
                x(1) when "001",
                x(2) when "010",
                x(3) when "011",
                x(4) when "100",
                x(5) when "101",
                x(6) when "110",
                x(7) when others;

end Behavioral;
