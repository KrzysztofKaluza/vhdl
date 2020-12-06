library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NEW_1010_DETECTOR is
    port (  I : in STD_LOGIC;
            O : out STD_LOGIC;
            CLK : in STD_LOGIC;
            RESET : in STD_LOGIC);
end NEW_1010_DETECTOR;

architecture Behavioral of NEW_1010_DETECTOR is
    signal state, nstate: std_logic_vector(2 downto 0);
begin
    process(RESET, CLK)
        begin
            if RESET = '1' then
                state <= "000";
            elsif rising_edge(CLK) then
                state <= nstate;
        end if;
    end process;
    process(I, state)
    begin
        case state is
            when "000" =>
                if I = '0' then
                    nstate <= "000";
                else
                    nstate <= "001";
                end if;
                O <= '0';
            when "001" =>
                if I = '0' then
                    nstate <= "010";
                else
                    nstate <= "001";
                end if;
                O <= '0';
            when "010" =>
                if I = '0' then
                    nstate <= "000";
                else
                    nstate <= "011";
                end if;
                O <= '0';
            when "011" =>
                if I = '0' then
                    nstate <= "100";
                else
                    nstate <= "001";
                end if;
                O <= '0';
            when "100" =>
                if I = '0' then
                    nstate <= "000";
                else
                    nstate <= "011";
                end if;
                O <= '1';
            when others =>
                nstate <= "000";
                O <= '0';
        end case;
    end process;
end Behavioral;
