library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Controller is
	
	port(int_opcode : in std_logic_vector(5 downto 0);
        regDST, jump, branch, memRead, memToReg, memWrite, ALUsrc, regWrite : out std_logic;
	ALUop out std_logic_vector (1 downto 0));
		  
end MIPS_Controller;

architecture behavioral of MIPS_Controller is
begin
    Operation: process(int_opcode)
	    begin
	    case int_opcode is
			when "000000" =>
				regDST <= '1';
				jump <= '0';
				branch <= '0';
				memRead <= '0';
				memToReg <= '0';
				memWrite <= '0';
				ALUsrc <= '0';
				regWrite <= '1';
				ALUop <= '10';
        end case;
		
	end process;

end behavioral;