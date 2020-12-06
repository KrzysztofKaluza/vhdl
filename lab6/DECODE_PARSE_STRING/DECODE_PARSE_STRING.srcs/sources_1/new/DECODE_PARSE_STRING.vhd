library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity DECODE_PARSE_STRING is
    Port(   D : in std_logic_vector (7 downto 0);
            CLK : in std_logic;
            RESET : in std_logic;
            F : out std_logic_vector (3 downto 0);
            ARG : out std_logic_vector(6 downto 0);
            RCVD : out std_logic);
end DECODE_PARSE_STRING;

architecture Behavioral of DECODE_PARSE_STRING is
    function IsDigit (arg : in std_logic_vector(7 downto 0))
        return boolean is
        constant c0: std_logic_vector(7 downto 0) := x"30";
        constant c9: std_logic_vector(7 downto 0) := x"39";
    begin
        if (arg >= c0) and (arg <= c9) then
            return true;
        else
            return false;
        end if;
    end;
    signal N, F2, A, B, TEMP : std_logic_vector(7 downto 0);
    signal F_N, N_N, A_N, B_N, TEMP_N : std_logic_vector(7 downto 0);
    constant c0: std_logic_vector(7 downto 0) := x"30";
    constant c1: std_logic_vector(7 downto 0) := x"31";
    constant c2: std_logic_vector(7 downto 0) := x"32";
    constant cC : std_logic_vector(7 downto 0) := x"43";
    constant cCN : std_logic_vector(7 downto 0) := x"3A";
    type STATE_t is (S_IDLE, S_F, S_N, S_A, S_B, S_0, S_cCN);
    signal STATE, STATE_N: STATE_t;
begin
    process(CLK, RESET)
    begin
        if RESET = '1' then
            STATE <= S_IDLE;
        elsif rising_edge(CLK) then
            STATE <= STATE_N;
        end if;
    end process;
    
    process(D, STATE)
    begin
        case (STATE) is 
             when S_IDLE =>
                if D = cC then
                    STATE_N <= S_F;  
                else
                    STATE_N <= S_IDLE;
                end if;
                RCVD <= '0';
            when S_F =>
                if isDigit(D) then
                    STATE_N <= S_N;
                else
                    STATE_N <= S_IDLE;
                end if;
                RCVD <= '0';   
            when S_N =>
                if D = c2 then
                    STATE_N <= S_A;
                elsif D = c1 then
                    STATE_N <= S_B;
                elsif D = c0 then
                    STATE_N <= S_0;
                else
                    STATE_N <= S_IDLE;
                end if;
                RCVD <= '0';  
            when S_A =>
                if isDigit(D) then
                    STATE_N <= S_B;
                else
                    STATE_N <= S_IDLE;
                end if;
                RCVD <= '0';  
            when S_B =>
                if isDigit(D) then
                    STATE_N <= S_0;
                else
                    STATE_N <= S_IDLE;
                end if;
                RCVD <= '0';
            when S_0 =>
                if D = cCN then
                    STATE_N <= S_cCN;
                else
                    STATE_N <= S_IDLE;
                end if;
                RCVD <= '0'; 
            when S_cCN =>
                if D = cC then
                    STATE_N <= S_F;
                else
                    STATE_N <= S_IDLE;
                end if;
                RCVD <= '1'; 
                
        end case;    
    end process;
    
    process(CLK, RESET)
    begin
        if RESET = '1' then
            F2 <= (others => '0');
            N <= (others => '0');
            A <= (others => '0');
            B <= (others => '0');
            TEMP <= (others => '0');
        elsif rising_edge(CLK) then
            F2 <= F_N;
            N <= N_N;
            A <= A_N;
            B <= B_N;
            TEMP <= TEMP_N;
        end if;
    end process;
    
    process(RESET, STATE, F2, N, A, B, D)
    begin
        if RESET = '1' then
            F_N <= (others => '0');
            N_N <= (others => '0');
            A_N <= (others => '0');
            B_N <= (others => '0');
            TEMP_N <= (others => '0');
        else
            case (STATE) is
                when S_IDLE =>
                    
                when S_F =>
                        F_N <= D - c0;
                when S_N =>
                        N_N <= D;
                when S_A =>
                        A_N <= D - c0;
                when S_B =>
                        B_N <= D - c0;
                when S_0 =>
                when S_cCN =>
                    if N_N = c0 then
                        TEMP_N <= (others => '0');
                    elsif N_N = c1 then
                    --sprawdziæ konwersjê z 8bit na 7bit
                        TEMP_N <= A_N;
                        
                    elsif N_N = c2 then
                     -- TEMP <= B*10 + A
                    TEMP_N <= std_logic_vector(unsigned(B_N(3 downto 0))*10 + unsigned(A_N(3 downto 0)));
                    end if;
            end case;
        end if;    
    end process;
    F <= F2(3 downto 0);
    ARG <= TEMP(6 downto 0);
end Behavioral;
