library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity SEQUENTIAL_INSTRUCTION_EXECUTE_UNIT is
    Port (  INT: in std_logic;
            Z: in std_logic;
            CLK: in std_logic;
            RESET: in std_logic;
            IOIN: in std_logic_vector(7 downto 0);
            IOOUT: out std_logic_vector(7 downto 0);
            IOADR: out std_logic_vector(7 downto 0);
            IOWR: out std_logic;
            IORD: out std_logic
            );
end SEQUENTIAL_INSTRUCTION_EXECUTE_UNIT;

architecture Behavioral of SEQUENTIAL_INSTRUCTION_EXECUTE_UNIT is
    type rom_array is array (0 to 31) of std_logic_vector(15 downto 0);
    type reg_array is array (0 to 7) of std_logic_vector(7 downto 0);
    type ram_array is array (0 to 31) of std_logic_vector(7 downto 0);
    type stack_array is array (0 to 15) of std_logic_vector(7 downto 0);
    
    
    signal R: reg_array;
    signal R_N: reg_array;
    signal RAM: ram_array;
    signal RAM_N: ram_array;
    signal STACK: stack_array;
    signal STACK_N: stack_array;
    signal IR: std_logic_vector(15 downto 0);
    signal IR_N: std_logic_vector(15 downto 0);
    signal SREG: std_logic_vector(7 downto 0);
    signal SREG_N: std_logic_vector(7 downto 0);
    signal SREGM: std_logic_vector(7 downto 0);
    signal SREGM_N: std_logic_vector(7 downto 0);
    signal SPTR: std_logic_vector(3 downto 0) := "0000";
    signal SPTR_N: std_logic_vector(3 downto 0) := "0000";
    
    alias OPCODE_R: std_logic_vector(9 downto 0) is IR(15 downto 6);
    alias ARG_R_DDD: std_logic_vector(2 downto 0) is IR(5 downto 3);
    alias ARG_R_SSS: std_logic_vector(2 downto 0) is IR(2 downto 0);
    alias OPCODE_I: std_logic_vector(4 downto 0) is IR(15 downto 11);
    alias ARG_I_DDD: std_logic_vector(2 downto 0) is IR(10 downto 8);
    alias ARG_I_K: std_logic_vector(7 downto 0) is IR(7 downto 0);
    
    alias ARG_M_SSS: std_logic_vector(2 downto 0) is IR(2 downto 0);
    alias ARG_M_K: std_logic_vector(7 downto 0) is IR(10 downto 3);
    
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
    constant MC_ADC: std_logic_vector(15 downto 0) := "0000000011------";
    constant C_ADC: std_logic_vector(9 downto 0) := "0000000011";
    constant MC_SBC: std_logic_vector(15 downto 0) := "0000000100------";
    constant C_SBC: std_logic_vector(9 downto 0) := "0000000100";
    constant MC_MUL: std_logic_vector(15 downto 0) := "0000000101------";
    constant C_MUL: std_logic_vector(9 downto 0) := "0000000101";
    constant MC_MULS: std_logic_vector(15 downto 0) := "0000000110------";
    constant C_MULS: std_logic_vector(9 downto 0) := "0000000110";
    constant MC_AND: std_logic_vector(15 downto 0) := "0000000111------";
    constant C_AND: std_logic_vector(9 downto 0) := "0000000111";
    constant MC_OR: std_logic_vector(15 downto 0) := "0000001000------";
    constant C_OR: std_logic_vector(9 downto 0) := "0000001000";
    constant MC_XOR: std_logic_vector(15 downto 0) := "0000001001------";
    constant C_XOR: std_logic_vector(9 downto 0) := "0000001001";
    constant MC_CP: std_logic_vector(15 downto 0) := "0000001010------";
    constant C_CP: std_logic_vector(9 downto 0) := "0000001010";
    constant MC_RET: std_logic_vector(15 downto 0) := "0000001011------";
    constant C_RET: std_logic_vector(9 downto 0) := "0000001011";
    constant MC_RETI: std_logic_vector(15 downto 0) := "0000001100------";
    constant C_RETI: std_logic_vector(9 downto 0) := "0000001100";
    
    constant MC_NOP: std_logic_vector(15 downto 0) := "01000001--------";
    constant C_NOP: std_logic_vector( 7 downto 0) := "01000001";
    constant MC_B: std_logic_vector(15 downto 0) := "01000011--------";
    constant C_B: std_logic_vector( 7 downto 0) := "01000011";
    constant MC_BZ: std_logic_vector(15 downto 0) := "01000100--------";
    constant C_BZ: std_logic_vector( 7 downto 0) := "01000100";
    constant MC_BSET: std_logic_vector(15 downto 0) := "01000101--------"; 
    constant C_BSET: std_logic_vector(7 downto 0) := "01000101";
    constant MC_BCLR: std_logic_vector(15 downto 0) := "01000110--------";
    constant C_BCLR: std_logic_vector(7 downto 0) := "01000110";
    constant MC_RB: std_logic_vector(15 downto 0) := "01000111--------";
    constant C_RB: std_logic_vector(7 downto 0) := "01000111";
    constant MC_BRBS: std_logic_vector(15 downto 0) := "01001000--------";
    constant C_BRBS: std_logic_vector(7 downto 0) := "01001000";
    constant MC_BRBC: std_logic_vector(15 downto 0) := "01001001--------";
    constant C_BRBC: std_logic_vector(7 downto 0) := "01001001";
    constant MC_RCALL: std_logic_vector(15 downto 0) := "01001010--------";
    constant C_RCALL: std_logic_vector(7 downto 0) := "01001010";
    constant MC_CALL: std_logic_vector(15 downto 0) := "01001011--------";
    constant C_CALL: std_logic_vector(7 downto 0) := "01001011";
    
    constant MC_LDI: std_logic_vector(15 downto 0) := "10000-----------";
    constant C_LDI: std_logic_vector(4 downto 0) := "10000";
    constant MC_LDS: std_logic_vector(15 downto 0) := "10001-----------";
    constant C_LDS: std_logic_vector(4 downto 0) := "10001";
    constant MC_STS: std_logic_vector(15 downto 0) := "10010-----------";
    constant C_STS: std_logic_vector(4 downto 0) := "10010";
    constant MC_CPI: std_logic_vector(15 downto 0) := "10011-----------";
    constant C_CPI: std_logic_vector(4 downto 0) := "10011"; 
    constant MC_ADCI: std_logic_vector(15 downto 0) := "10101-----------";
    constant C_ADCI: std_logic_vector(4 downto 0) := "10101";
    constant MC_SBCI: std_logic_vector(15 downto 0) := "10110-----------";
    constant C_SBCI: std_logic_vector(4 downto 0) := "10110";
    constant MC_ANDI: std_logic_vector(15 downto 0) := "10111-----------";
    constant C_ANDI: std_logic_vector(4 downto 0) := "10111";
    constant MC_ORI: std_logic_vector(15 downto 0) := "11000-----------";
    constant C_ORI: std_logic_vector(4 downto 0) := "11000";
    constant MC_XORI: std_logic_vector(15 downto 0) := "11001-----------";
    constant C_XORI: std_logic_vector(4 downto 0) := "11001";
    
    constant MC_OUTP: std_logic_vector(15 downto 0) := "11010-----------";
    constant C_OUTP: std_logic_vector(4 downto 0) := "11010";
    constant MC_INP: std_logic_vector(15 downto 0) := "11011-----------";
    constant C_INP: std_logic_vector(4 downto 0) := "11011";
    
    
    constant ROM: rom_array := (
        C_LDI & "001" & x"04",
        C_OUTP & x"03" & "001",
        C_INP & "010" & x"55",
        C_CALL & x"0A",
        C_LDI & "011" & x"10",
        C_RCALL & x"05",
        x"0000",
        C_B & x"00",
        x"0000",
        x"0000",
        C_LDI & "011" & x"13",
        C_RET & "000000",    
        C_LDI & "101" & x"33",
        C_RETI & "000000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        x"0000",
        C_B & x"0c"
        );

begin

    process(CLK, RESET)
    begin
        if RESET = '1' then
            STATE <= S_FETCH;
        elsif INT = '1' then
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
    
    process(CLK, RESET, INT)
    begin
        if RESET = '1' then
            IR <= (others => '0');
            PC <= (others => '0');
            SREG <= (others => '0');
            SREGM <= (others => '0');
            SPTR <= (others => '0');
            for i in 0 to R'high loop
				R(i) <= x"00";
			end loop;
            for i in 0 to STACK'high loop
				STACK(i) <= x"00";
			end loop;
		elsif INT = '1' then
            STACK<=STACK_N;
            SPTR<=SPTR_N;
            SREGM<=SREGM_N;
            SREG<=SREG_N;
            PC<=PC_N;
        elsif rising_edge(CLK) then
            IR <= IR_N;
            PC <= PC_N;
            R <= R_N;
            SREG <= SREG_N;
            RAM <= RAM_N; 
            STACK <=STACK_N;
            SPTR <= SPTR_N;
            
        end if;
    end process;
    
    process(INT, RAM, SREG, R, Z, IR, PC, STATE, RESET, PC_N, R_N, STACK, STACK_N, SPTR, SPTR_N)
        variable src1, src2: signed(7 downto 0);
        variable res: signed(8 downto 0);
        variable mulres: signed(15 downto 0);
        variable flag: std_logic := '0';
    begin
        if RESET = '1' then
            IR_N <= (others => '0');
            PC_N <= (others => '0');
            SREG_N <= (others => '0');
            SPTR_N <= (others => '0');
            SREGM_N <= (others => '0');
            for i in 0 to R'high loop
				R_N(i) <= x"00";	
			end loop;
			for i in 0 to STACK'high loop
				STACK_N(i) <= x"00";
			end loop;
        elsif INT = '1' then
            STACK_N(to_integer(unsigned(SPTR))) <= PC;
            SPTR_N <= std_logic_vector(unsigned(SPTR) + 1);
            SREGM_N <= SREG;
            SREG_N(7) <= '0';
            PC_N <= "00011111";
            
        else
            case(STATE) is
                when S_FETCH =>
                    IR_N <= ROM(to_integer(unsigned(PC)));
                when S_EX =>
                    if std_match(IR, MC_LDI) then
                        R_N(to_integer(unsigned(ARG_I_DDD))) <= ARG_I_K;
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_RCALL) then
                        STACK_N(to_integer(unsigned(SPTR)))<= std_logic_vector(unsigned(PC) + 1);
                        SPTR_N <= std_logic_vector(unsigned(SPTR) + 1);
                        PC_N <= std_logic_vector(unsigned(PC) + unsigned(ARG_I_K)); --hmmm, powinno dzialaæ
                    elsif std_match(IR, MC_CALL) then   
                        STACK_N(to_integer(unsigned(SPTR)))<= std_logic_vector(unsigned(PC) + 1);
                        SPTR_N <= std_logic_vector(unsigned(SPTR) + 1);
                        PC_N <= ARG_I_K;
                    elsif std_match(IR, MC_RET) then
                        PC_N <= STACK(to_integer(unsigned(SPTR))-1);
                        SPTR_N <= std_logic_vector(unsigned(SPTR) - 1);
                    elsif std_match(IR, MC_RETI) then
                        PC_N <= STACK(to_integer(unsigned(SPTR))-1);
                        SPTR_N <= std_logic_vector(unsigned(SPTR) - 1);
                        SREG_N <= SREGM;
                    elsif std_match(IR, MC_CP) then
                        src1:=signed(R(to_integer(unsigned(ARG_R_DDD))));
                        src2:=signed(R(to_integer(unsigned(ARG_R_SSS))));
                        res:= x"00" & SREG(0);
                        res:= ('0' & src1) - ('0' & src2) - res;
                        SREG_N(0) <= res(8);
                        if res(7 downto 0) = x"00" then
                            SREG_N(1)<='1';
                        else
                            SREG_N(1)<='0';
                        end if; 
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_CPI) then
                        src1:=signed(R(to_integer(unsigned(ARG_I_DDD))));
                        src2:=signed(R(to_integer(unsigned(ARG_I_K))));
                        res:= x"00" & SREG(0);
                        res:= ('0' & src1) - ('0' & src2) - res;
                        SREG_N(0) <= res(8);
                        if res(7 downto 0) = x"00" then
                            SREG_N(1)<='1';
                        else
                            SREG_N(1)<='0';
                        end if;
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_MOV) then
                        R_N(to_integer(unsigned(ARG_R_DDD))) <= R(to_integer(unsigned(ARG_R_SSS)));
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_LD) then
                        R_N(to_integer(unsigned(ARG_R_DDD))) <= RAM(to_integer(unsigned(R(to_integer(unsigned(ARG_R_SSS))))));
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_LDS) then
                        R_N(to_integer(unsigned(ARG_I_DDD))) <= RAM(to_integer(unsigned(ARG_I_K)));
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_ST) then
                        RAM_N(to_integer(unsigned(R(to_integer(unsigned(ARG_R_DDD)))))) <= R(to_integer(unsigned(ARG_R_SSS)));
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_STS) then
                        RAM_N(to_integer(unsigned(ARG_I_K))) <= R(to_integer(unsigned(ARG_I_DDD)));
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_BRBS) then
                    
                        if SREG(1) = '1' then
                            PC_N <= std_logic_vector(signed(PC) + signed(ARG_I_K));
                        else
                            PC_N <= std_logic_vector(signed(PC) + 1);
                        end if;
                        
                    elsif std_match(IR, MC_BRBC) then
                    
                        if SREG(1) = '0' then
                            PC_N <= std_logic_vector(signed(PC) + signed(ARG_I_K));
                        else
                            PC_N <= std_logic_vector(signed(PC) + 1);
                        end if;
                    
                    elsif std_match(IR, MC_NOP) then
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_OUTP) then
                        IOADR <= ARG_M_K;
                        IOOUT <= R(to_integer(unsigned(ARG_M_SSS)));
                        if flag = '0' then
                            flag := '1'; 
                        else
                            IOWR <= '1'; --gdzies trzeba pewnie zerowac, nie zapomnij
                            PC_N <= std_logic_vector(unsigned(PC) + 1);
                            flag := '0';
                        end if;
                    elsif std_match(IR, MC_INP) then
                        IOADR <= ARG_I_K;
                        R_N(to_integer(unsigned(ARG_I_DDD))) <= IOIN;
                        if flag = '0' then
                            flag := '1'; 
                        else
                            IORD <= '1'; --gdzies trzeba pewnie zerowac, nie zapomnij
                            PC_N <= std_logic_vector(unsigned(PC) + 1);
                            flag := '0';
                        end if;
                    elsif std_match(IR, MC_B) then
                        PC_N <= ARG_I_K;
                    elsif std_match(IR, MC_RB) then
                        PC_N <= PC + ARG_I_K;
                    elsif std_match(IR, MC_BZ) then
                        if Z = '1' then
                            PC_N <= ARG_I_K;
                        else
                            PC_N <= std_logic_vector(unsigned(PC) + 1); 
                        end if;
                    elsif std_match(IR, MC_ADC) then
                        src1:=signed(R(to_integer(unsigned(ARG_R_DDD))));
                        src2:=signed(R(to_integer(unsigned(ARG_R_SSS))));
                        res:= x"00" & SREG(0);
                        res:=res + ('0' & src1) + ('0' & src2);
                        SREG_N(0) <= res(8);
                        if res(7 downto 0) = x"00" then
                            SREG_N(1)<='1';
                        else
                            SREG_N(1)<='0';
                        end if;
                        R_N(to_integer(unsigned(ARG_R_DDD))) <= std_logic_vector(unsigned(res(7 downto 0))); 
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_SBC) then
                        src1:=signed(R(to_integer(unsigned(ARG_R_DDD))));
                        src2:=signed(R(to_integer(unsigned(ARG_R_SSS))));
                        res:= x"00" & SREG(0);
                        res:= ('0' & src1) - ('0' & src2) - res;
                        SREG_N(0) <= res(8);
                        if res(7 downto 0) = x"00" then
                            SREG_N(1)<='1';
                        else
                            SREG_N(1)<='0';
                        end if;
                        R_N(to_integer(unsigned(ARG_R_DDD))) <= std_logic_vector(res(7 downto 0));
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_MUL) then
                        src1:=signed(R(to_integer(unsigned(ARG_R_DDD))));
                        src2:=signed(R(to_integer(unsigned(ARG_R_SSS))));
                        mulres:= (others => '0');
                        mulres:=signed(unsigned(src1)*unsigned(src2));
                        
                        if mulres(15 downto 0) = x"0000" then
                            SREG_N(1)<='1';
                        else
                            SREG_N(1)<='0';
                        end if;
                        R_N(to_integer(unsigned(ARG_R_DDD))+1) <= std_logic_vector(unsigned(mulres(15 downto 8)));
                        R_N(to_integer(unsigned(ARG_R_DDD))) <= std_logic_vector(unsigned(mulres(7 downto 0)));
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_MULS) then
                        src1:=signed(R(to_integer(unsigned(ARG_R_DDD))));
                        src2:=signed(R(to_integer(unsigned(ARG_R_SSS))));
                        mulres:= (others => '0');
                        mulres:= src1 * src2;
                        
                        if mulres(15 downto 0) = x"0000" then
                            SREG_N(1)<='1';
                        else
                            SREG_N(1)<='0';
                        end if;
                        R_N(to_integer(unsigned(ARG_R_DDD))+1) <= std_logic_vector(mulres(15 downto 8));
                        R_N(to_integer(unsigned(ARG_R_DDD))) <= std_logic_vector(mulres(7 downto 0));
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_AND) then          
                        R_N(to_integer(unsigned(ARG_R_DDD))) <= R(to_integer(unsigned(ARG_R_DDD))) and R(to_integer(unsigned(ARG_R_SSS)));
                        if R_N(to_integer(unsigned(ARG_R_DDD))) = x"00" then
                            SREG_N(1)<='1';
                        else
                            SREG_N(1)<='0';
                        end if;
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_OR) then
                        R_N(to_integer(unsigned(ARG_R_DDD))) <= R(to_integer(unsigned(ARG_R_DDD))) or R(to_integer(unsigned(ARG_R_SSS)));
                        if R_N(to_integer(unsigned(ARG_R_DDD))) = x"00" then
                            SREG_N(1)<='1';
                        else
                            SREG_N(1)<='0';
                        end if;
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_XOR) then
                        R_N(to_integer(unsigned(ARG_R_DDD))) <= R(to_integer(unsigned(ARG_R_DDD))) xor R(to_integer(unsigned(ARG_R_SSS)));
                        if R_N(to_integer(unsigned(ARG_R_DDD))) = x"00" then
                            SREG_N(1)<='1';
                        else
                            SREG_N(1)<='0';
                        end if;
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_BSET) then
                        SREG_N <= SREG or ARG_I_K;
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_BCLR) then
                        SREG_N <= SREG and not ARG_I_K;
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_ADCI) then
                        src1:=signed(R(to_integer(unsigned(ARG_I_DDD))));
                        src2:=signed(ARG_I_K);
                        res:= x"00" & SREG(0);
                        res:=res + ('0' & src1) + ('0' & src2);
                        SREG_N(0) <= res(8);
                        if res(7 downto 0) = x"00" then
                            SREG_N(1)<='1';
                        else
                            SREG_N(1)<='0';
                        end if;
                        R_N(to_integer(unsigned(ARG_I_DDD))) <= std_logic_vector(unsigned(res(7 downto 0))); 
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_SBCI) then
                        src1:=signed(R(to_integer(unsigned(ARG_I_DDD))));
                        src2:=signed(ARG_I_K);
                        res:= x"00" & SREG(0);
                        res:= ('0' & src1) - ('0' & src2) - res;
                        SREG_N(0) <= res(8);
                        if res(7 downto 0) = x"00" then
                            SREG_N(1)<='1';
                        else
                            SREG_N(1)<='0';
                        end if;
                        R_N(to_integer(unsigned(ARG_I_DDD))) <= std_logic_vector(res(7 downto 0));
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_ANDI) then
                        R_N(to_integer(unsigned(ARG_I_DDD))) <= R(to_integer(unsigned(ARG_I_DDD))) and ARG_I_K;
                        if R_N(to_integer(unsigned(ARG_I_DDD))) = x"00" then
                            SREG_N(1)<='1';
                        else
                            SREG_N(1)<='0';
                        end if;
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                        
                    elsif std_match(IR, MC_ORI) then
                        R_N(to_integer(unsigned(ARG_I_DDD))) <= R(to_integer(unsigned(ARG_I_DDD))) or ARG_I_K;
                        if R_N(to_integer(unsigned(ARG_I_DDD))) = x"00" then
                            SREG_N(1)<='1';
                        else
                            SREG_N(1)<='0';
                        end if;
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    elsif std_match(IR, MC_XORI) then
                        R_N(to_integer(unsigned(ARG_I_DDD))) <= R(to_integer(unsigned(ARG_I_DDD))) xor ARG_I_K;
                        if R_N(to_integer(unsigned(ARG_I_DDD))) = x"00" then
                            SREG_N(1)<='1';
                        else
                            SREG_N(1)<='0';
                        end if;
                        PC_N <= std_logic_vector(unsigned(PC) + 1);
                    end if;
            end case;
        end if;
    end process;
end Behavioral;
