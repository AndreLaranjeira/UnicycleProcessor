library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_ULA_Controller is
	
	port(ALUop : in std_logic_vector(2 downto 0);
        intFunct : in std_logic(5 downto 0);
	    ALU out std_logic_vector (3 downto 0));
		  
end MIPS_ULA_Controller;

-- ALU
-- 0000 -> and
-- 0001 -> or
-- 0010 -> soma
-- 0011 -> somau

-- 0100 -> sub
-- 0101 -> subu
-- 0110 -> slt
-- 0111 -> sltu

-- 1000 -> nor
-- 1001 -> xor
-- 1010 -> sll
-- 1011 -> srl

-- 1100 -> sra
-- 1101 -> rtr
-- 1110 -> rtl

-- ALUops
-- 000 -> soma
-- 001 -> subtração
-- 010 -> and
-- 011 -> or
-- 100 -> tipo R
-- 101 -> soma unsigned
-- 111 -> slt

architecture behavioral of MIPS_ULA_Controller is
    begin
    Operation: process(ALUop, intFunct)
	begin
	    case ALUop is
            when "000" =>
                ALU <= "0010"
            when "001" =>
                ALU <= "0100"
            when "010" =>
                ALU <= "0000"
            when "011" =>
                ALU <= "0001"
            when "100" =>
                case intFunct is
                    when "101000"=> -- AND
                        ALU <= "0000";
                    when "100101"=> -- OR
                        ALU <= "0001";
                    when "100000"=> -- ADD
                        ALU <= "0010";
                    when "100001"=> -- ADDU
                        ALU <= "0011";

                    when "100010" => --SUB
                        ALU <= "0100";
                    when "100011" => --SUBU
                        ALU <= "0101";
                    when "101010" => --SLT
                        ALU <= "0110";
                    when "101011" => --SLTU
                        ALU <= "0111";
                    
                    when "100111" => --NOR
                        ALU <= "1000";
                    when "100110" => --xor
                        ALU <= "1001";
                    when "000000" => --sll
                        ALU <= "1010";
                    when "000010" => --srl
                        ALU <= "1011";
                    
                    when "000011" => --sra
                        ALU <= "1100";
                    when "000010" => --rtr
                        ALU <= "1101";

                    when others => 
                        ALU <= "1111";
                end case;
            when "101" =>
                ALU <= "0011"
            when "110" =>
                ALU <= "0110"
            when others =>
                ALU <= "1111";
        end case;
    end process;

end behavioral;