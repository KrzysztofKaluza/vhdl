library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MULTIPLIER4X4 is
    port (  A : in std_logic_vector (3 downto 0);
            B : in std_logic_vector (3 downto 0);
            START: in std_logic;
            CLK : in std_logic;
            RESET : in std_logic;
            DONE: out std_logic;
            Y : out std_logic_vector (7 downto 0));
end MULTIPLIER4X4;

architecture Behavioral of MULTIPLIER4X4 is
    signal M, M_N: std_logic_vector(3 downto 0);
    signal Q, Q_N: unsigned(8 downto 0);
    signal N, N_N: natural range 0 to 4;
    signal YT, Y_N: std_logic_vector (7 downto 0);
    signal DONET, DONE_N: std_logic;
    -- Typ wyliczeniowy reprezentuj¹cy stany czêœci steruj¹cej
    type STATE_t is (S_IDLE, S_CALC, S_SHIFT, S_DONE);
    signal STATE, STATE_N: STATE_t;
begin
    -- Uaktualnianie stanu bie¿¹cego czêœci steruj¹cej
    process (CLK, RESET)
    begin
        if RESET = '1' then
            STATE <= S_IDLE;
        elsif rising_edge(CLK) then
            STATE <= STATE_N;
        end if;
    end process;
    -- Logika stanu nastêpnego czêœci steruj¹cej
    process (RESET, STATE, START, N)
    begin
        if RESET = '1' then
            STATE_N <= S_IDLE;
        else
            case (STATE) is
                when S_IDLE =>
                    if START = '1' then
                        STATE_N <= S_CALC;
                    else
                        STATE_N <= S_IDLE;
                    end if;
                when S_CALC =>
                    STATE_N <= S_SHIFT;
                when S_SHIFT =>
                    if N = 0 then
                        STATE_N <= S_DONE;
                    else
                        STATE_N <= S_CALC;
                    end if;
                when S_DONE =>
                    STATE_N <= S_IDLE;
                when others =>
                    STATE_N <= S_IDLE;
            end case;
        end if;
    end process;
    -- Uaktualnianie stanu bie¿¹cego œcie¿ki danych
    process (CLK, RESET)
    begin
        if RESET = '1' then
            M <= (others => '0');
            Q <= (others => '0');
            N <= 0;
            YT <= (others => '0');
            DONET <= '0';
        elsif rising_edge(CLK) then
            M <= M_N;
            Q <= Q_N;
            N <= N_N;
            YT <= Y_N;
            DONET <= DONE_N;
        end if;
    end process;
    -- Logika stanu nastêpnego œcie¿ki danych
    process (RESET, STATE, M, Q, YT, N, START, DONET, A, B)
    begin
        if RESET = '1' then
            M_N <= (others => '0');
            Q_N <= (others => '0');
            N_N <= 0;
            Y_N <= (others => '0');
            DONE_N <= '0';
        else
    -- Wartoœci domyœlne rejestrów œcie¿ki danych
    -- Je¿eli w dalszej czêœci kodu zostanie przypisana nowa wartoœæ
    -- to wartoœæ domyœlna zostanie ni¹ zast¹piona.
            M_N <= M;
            Q_N <= Q;
            N_N <= N;
            Y_N <= YT;
            DONE_N <= DONET;
            case (STATE) is
                when S_IDLE =>
                    if START = '1' then
                        M_N <= A;
                        Q_N <= unsigned("00000" & B);
                        N_N <= 4;
                        DONE_N <= '0';
                    end if;
                when S_CALC =>
                    N_N <= N - 1;
                    if Q(0) = '1' then
                        Q_N <= Q + unsigned('0' & M & "0000");
                    end if;
                when S_SHIFT =>
                    Q_N <= '0' & Q(8 downto 1);
                when S_DONE =>
                    Y_N <= std_logic_vector(Q(7 downto 0));
                    DONE_N <= '1';
                when others =>
            end case;
        end if;
    end process;
    -- Przepisanie wyniku mno¿enia do wyjœcia
    Y <= YT(7 downto 0);
    DONE <= DONET;
end Behavioral;