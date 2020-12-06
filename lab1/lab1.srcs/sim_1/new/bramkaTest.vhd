----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.10.2020 09:09:37
-- Design Name: 
-- Module Name: bramkaTest - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bramkaTest is
--  Port ( );
end bramkaTest;

architecture Behavioral of bramkaTest is
    component bramka is
    --Declarations
    Port (  a : in STD_LOGIC;
            b : in STD_LOGIC;
            c : out STD_LOGIC);
    end component;
    
    signal a : STD_LOGIC := '0';
    signal b : STD_LOGIC := '0';
    signal c : STD_LOGIC;
begin
    --Test code
    b0: bramka port map (a=>a, b=>b, c=>c);
    
    process
    begin
        wait for 10 ns;
        a <= '1';
        wait for 10 ns;
        a <= '0';
        b <= '1';
        wait for 10 ns;
        a <= '1';
        wait;
    end process;

end Behavioral;
