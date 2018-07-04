library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Controller is
	
	port(int_opcode : in std_logic_vector(5 downto 0);
        regDST, jump, branch, memRead, memToReg, memWrite, ALUsrc, regWrite : out std_logic;
        ALUop : out std_logic_vector(2 downto 0));
  
end MIPS_Controller;

-- ALUops
-- 000 -> soma
-- 001 -> subtração
-- 010 -> and
-- 011 -> or
-- 100 -> tipo R
-- 101 -> soma unsigned
-- 111 -> slt

architecture behavioral of MIPS_Controller is
begin
    Operation: process(int_opcode)
	    begin
	    case int_opcode is
			when "000000" =>
            -- addi
            when "001000" =>
                regDST <= '0';
                jump <= '0';
                branch <= '0';
                branchN <= '0';
                memRead <= '0';
                memToReg <= '0';
                memWrite <= '0';
                ALUsrc <= '1';
                regWrite <= '1';
                ALUop <= "000";
            --addiu
            when "001001" =>
                regDST <= '0';
                jump <= '0';
                branch <= '0';
                branchN <= '0';
                memRead <= '0';
                memToReg <= '0';
                memWrite <= '0';
                ALUsrc <= '1';
                regWrite <= '1';
                ALUop <= "101";
            --j
            when "000001" =>
                regDST <= '0';
                jump <= '1';
                branch <= '0';
                branchN <= '0';
                memRead <= '0';
                memToReg <= '0';
                memWrite <= '0';
                ALUsrc <= '0';
                regWrite <= '0';
                ALUop <= "000";
            --jal
            when "000011" => --usar jump e regwrite sendo 1 para registrador de escrita ser $31
                regDST <= '0';
                jump <= '1';
                branch <= '0';
                branchN <= '0';
                memRead <= '0';
                memToReg <= '0';
                memWrite <= '0';
                ALUsrc <= '0';
                regWrite <= '1';
                ALUop <= "000";
            --slti
            when "001010" =>
                regDST <= '0';
                jump <= '0';
                branch <= '0';
                branchN <= '0';
                memRead <= '0';
                memToReg <= '0';
                memWrite <= '0';
                ALUsrc <= '1';
                regWrite <= '1';
                ALUop <= "111";
        end case;
		
	end process;

end behavioral;