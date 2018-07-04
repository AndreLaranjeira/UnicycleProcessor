library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Controller is
	
	port(int_opcode : in std_logic_vector(5 downto 0);
        regDST, jump, branch, memRead, memToReg, ALUop, memWrite, ALUsrc, regWrite : out std_logic;
		  
		  
end MIPS_Controller;

architecture behavioral of MIPS_Controller is
begin
    Operation: process(int_opcode)
	    begin
	    case int_opcode is
			when "000000" => 
            
        end case;
		
	end process;

end behavioral;