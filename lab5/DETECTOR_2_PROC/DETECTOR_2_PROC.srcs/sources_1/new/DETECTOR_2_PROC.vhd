library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DETECTOR_2_PROC is
    port (  I : in STD_LOGIC;
            O : out STD_LOGIC;
            CLK : in STD_LOGIC;
            RESET : in STD_LOGIC);
end DETECTOR_2_PROC;

architecture Behavioral of DETECTOR_2_PROC is
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
                    nstate <= "001";
                else
                    nstate <= "000";
                end if;
                O <= '0';
            when "001" =>
                if I = '0' then
                    nstate <= "001";
                else
                    nstate <= "010";
                end if;
                O <= '0';
            when "010" =>
                if I = '0' then
                    nstate <= "001";
                else
                    nstate <= "011";
                end if;
                O <= '0';
            when "011" =>
                if I = '0' then
                    nstate <= "100";
                else
                    nstate <= "000";
                end if;
                O <= '0';
            when "100" =>
                if I = '0' then
                    nstate <= "001";
                else
                    nstate <= "000";
                end if;
                O <= '1';
            when others =>
                nstate <= "000";
                O <= '0';
        end case;
    end process;
end Behavioral;
