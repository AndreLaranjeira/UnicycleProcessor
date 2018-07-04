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

architecture behavioral of MIPS_ULA_Controller is
    begin
    Operation: process(ALUop, intFunct)
	begin
	    case ALUop is
            when "100" =>
                case intFunct is
                    
        end case;
    end process;

end behavioral;