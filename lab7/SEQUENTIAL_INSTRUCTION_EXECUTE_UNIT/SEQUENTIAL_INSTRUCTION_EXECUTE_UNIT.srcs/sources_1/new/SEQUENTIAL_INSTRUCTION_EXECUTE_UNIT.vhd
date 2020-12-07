library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity SEQUENTIAL_INSTRUCTION_EXECUTE_UNIT is
    Port (  Z: in std_logic;
            CLK: in std_logic;
            RESET: in std_logic;
            GPIO: out std_logic_vector(7 downto 0));
end SEQUENTIAL_INSTRUCTION_EXECUTE_UNIT;

architecture Behavioral of SEQUENTIAL_INSTRUCTION_EXECUTE_UNIT is
    --type rom_t is array (0 to 31) of std_logic_vector(15 downto 0);
    type rom_array is array (0 to 31) of std_logic_vector(15 downto 0);
    type reg_array is array (0 to 7) of std_logic_vector(7 downto 0);
    signal R: reg_array;
    type ram_array is array (0 to 31) of std_logic_vector(7 downto 0);
    signal RAM: ram_array;
    signal IR: std_logic_vector(15 downto 0);
    signal IR_N: std_logic_vector(15 downto 0);
    alias OPCODE_R: std_logic_vector(9 downto 0) is IR(15 downto 6);
    alias ARG_R_DDD: std_logic_vector(2 downto 0) is IR(5 downto 3);
    alias ARG_R_SSS: std_logic_vector(2 downto 0) is IR(2 downto 0);
    alias OPCODE_I: std_logic_vector(4 downto 0) is IR(15 downto 11);
    alias ARG_I_DDD: std_logic_vector(2 downto 0) is IR(10 downto 8);
    alias ARG_I_K: std_logic_vector(7 downto 0) is IR(7 downto 0);
    
    type STATE_t is (S_FETCH, S_EX);
    signal STATE, STATE_N: STATE_t;
    signal PC: std_logic_vector(7 downto 0);
    signal PC_N: std_logic_vector(7 downto 0);
    constant MC_MOV: std_logic_vector(15 downto 0) := "0000000000------";
    constant C_MOV: std_logic_vector(9 downto 0) := "0000000000";
    constant MC_LD: std_logic_vector(15 downto 0) := "0000000001------";
    constant C_LD: std_logic_vector(9 downto 0) := "0000000001";
    constant MC_ST: std_logic_vector(15 downto 0) := "0000000010------";
    constant C_ST: std_logic_vector(9 downto 0) := "0000000010";
    constant MC_NOP: std_logic_vector(15 downto 0) := "01000001--------";
    constant C_NOP: std_logic_vector( 7 downto 0) := "01000001";
    constant MC_OUTP: std_logic_vector(15 downto 0) := "01000010--------";
    constant C_OUTP: std_logic_vector( 7 downto 0) := "01000010";
    constant MC_B: std_logic_vector(15 downto 0) := "01000011--------";
    constant C_B: std_logic_vector( 7 downto 0) := "01000011";
    constant MC_BZ: std_logic_vector(15 downto 0) := "01000100--------";
    constant C_BZ: std_logic_vector( 7 downto 0) := "01000100";
    constant MC_LDI: std_logic_vector(15 downto 0) := "10000-----------";
    constant C_LDI: std_logic_vector(4 downto 0) := "10000";
    constant MC_LDS: std_logic_vector(15 downto 0) := "10001-----------";
    constant C_LDS: std_logic_vector(4 downto 0) := "10001";
    constant MC_STS: std_logic_vector(15 downto 0) := "10010-----------";
    constant C_STS: std_logic_vector(4 downto 0) := "10010";
    --constant ROM: rom_t := (C_OUTP & x"FF", C_OUTP & x"55", C_BZ & x"02",C_OUTP & x"00", C_NOP & x"00", C_B & x"00", others => x"0000");
    constant ROM: rom_array := (
        C_LDI & "001" & x"35", -- za³adowanie wartoœci x35 do rejestru R1
        C_LDI & "100" & x"79", -- za³adowanie wartoœci x79 do rejestru R4
        C_MOV & "101" & "001", -- przes³anie zawartoœci rejestru R1 do rejestru R5
        C_LDI & "001" & x"02", -- za³adowanie wartoœci x02 do rejestru R1
        C_ST & "001" & "100", -- zapisanie zawartoœci rejestru R4 do pamiêci RAM
        -- pod adres zawarty w R1 (adres x02)
        C_STS & "100" & x"05", -- zapisanie zawartoœci rejestru R4 do pamiêci RAM
        -- pod adres x05
        C_LD & "110" & "001", -- za³adowanie wartoœci z pamiêci RAM spod adresu
        -- zawartego w rejestrze R1 do rejestru R6
        C_LDS & "111" & x"05", -- za³adowanie wartoœci z pamiêci RAM spod adresu
        -- x05 do rejestru R7
        C_B & x"00", -- skok na poczatek programu
        others => x"0000");
begin

    process(CLK, RESET)
    begin
         if RESET = '1' then
            STATE <= S_FETCH;
        elsif rising_edge(CLK) then
            STATE <= STATE_N;
        end if;
    end process;
    
    process(STATE)
    begin
        case (STATE) is 
             when S_FETCH =>
                STATE_N <= S_EX;
             when S_EX =>
                STATE_N <= S_FETCH;      
        end case;    
    end process;
    
    process(CLK, RESET)
    begin
        if RESET = '1' then
            IR <= (others => '0');
            PC <= (others => '0');
        elsif rising_edge(CLK) then
            IR <= IR_N;
            PC <= PC_N;
        end if;
    end process;
    
    process(Z, IR, PC, STATE, RESET)
    begin
        if RESET = '1' then
            IR_N <= (others => '0');
            PC_N <= (others => '0');
        else
            case(STATE) is
                when S_FETCH =>
                    IR_N <= ROM(to_integer(unsigned(PC_N)));
                when S_EX =>
                    if std_match(IR, MC_LDI) then
                        R(to_integer(unsigned(ARG_I_DDD))) <= ARG_I_K;
                        PC_N <= std_logic_vector(unsigned(PC_N) + 1);
                    elsif std_match(IR, MC_MOV) then
                        R(to_integer(unsigned(ARG_R_DDD))) <= R(to_integer(unsigned(ARG_R_SSS)));
                        PC_N <= std_logic_vector(unsigned(PC_N) + 1);
                    elsif std_match(IR, MC_LD) then
                        R(to_integer(unsigned(ARG_R_DDD))) <= RAM(to_integer(unsigned(R(to_integer(unsigned(ARG_R_SSS))))));
                        PC_N <= std_logic_vector(unsigned(PC_N) + 1);
                    elsif std_match(IR, MC_LDS) then
                        R(to_integer(unsigned(ARG_I_DDD))) <= RAM(to_integer(unsigned(ARG_I_K)));
                        PC_N <= std_logic_vector(unsigned(PC_N) + 1);
                    elsif std_match(IR, MC_ST) then
                        RAM(to_integer(unsigned(R(to_integer(unsigned(ARG_R_DDD)))))) <= R(to_integer(unsigned(ARG_R_SSS)));
                        PC_N <= std_logic_vector(unsigned(PC_N) + 1);
                    elsif std_match(IR, MC_STS) then
                        RAM(to_integer(unsigned(ARG_I_K))) <= R(to_integer(unsigned(ARG_I_DDD)));
                        PC_N <= std_logic_vector(unsigned(PC_N) + 1);
                    elsif std_match(IR, MC_NOP) then
                        PC_N <= std_logic_vector(unsigned(PC_N) + 1);
                    elsif std_match(IR, MC_OUTP) then
                        GPIO <= ARG_I_K;
                        PC_N <= std_logic_vector(unsigned(PC_N) + 1);
                    elsif std_match(IR, MC_B) then
                        PC_N <= ARG_I_K;
                    elsif std_match(IR, MC_BZ) then
                        if Z = '1' then
                            PC_N <= ARG_I_K;
                        else
                            PC_N <= std_logic_vector(unsigned(PC_N) + 1); 
                        end if;
                    end if;
            end case;
        end if;
    end process;
end Behavioral;
