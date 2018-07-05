library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Controller is
	
	port(inst_opcode, inst_functor : in std_logic_vector(5 downto 0);
        regDST, jump, branch, branchN, memRead, memToReg : out std_logic; 
		  memWrite, ALUsrc, ALUsrc2, regWrite : out std_logic; 
		  eret, unknown_opcode : out std_logic;
		  ALUop : out std_logic_vector (2 downto 0));
		  
end MIPS_Controller;

-- ALUops
-- 000 -> soma
-- 001 -> subtração
-- 010 -> and
-- 011 -> or
-- 100 -> tipo R
-- 101 -> soma unsigned
-- 110 -> slt
-- 111 -> Xor

architecture behavioral of MIPS_Controller is
begin
    Operation: process(inst_opcode, inst_functor)
	    begin
	    case inst_opcode is
			
			when "000000" =>	--tipo R
				regDST <= '1';
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= '0';
				memWrite <= '0';
				ALUsrc <= '0';
				ALUsrc2 <= '0';
				regWrite <= '1';
				eret <= '0';
				unknown_opcode <= '0';
				ALUop <= "100";
         
         when "001000" =>	--addi
				regDST <= '0';
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= '0';
				memWrite <= '0';
				ALUsrc <= '1';
				ALUsrc2 <= '0';
				regWrite <= '1';
				eret <= '0';
				unknown_opcode <= '0';
				ALUop <= "000";
         
         when "001001" =>	--addiu
				regDST <= '0';
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= '0';
				memWrite <= '0';
				ALUsrc <= '1';
				ALUsrc2 <= '0';
				regWrite <= '1';
				eret <= '0';
				unknown_opcode <= '0';
				ALUop <= "101";
			
         when "000010" =>	--j
				regDST <= '0';
				jump <= '1';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= '0';
				memWrite <= '0';
				ALUsrc <= '0';
				ALUsrc2 <= '0';
				regWrite <= '0';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "000";

         when "000011" => 	--jal (usar jump e regwrite sendo 1 para registrador de escrita ser $31)
				regDST <= '0';
				jump <= '1';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= '0';
				memWrite <= '0';
				ALUsrc <= '0';
				ALUsrc2 <= '0';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "000";
            
         when "001010" =>	--slti
				regDST <= '0';
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= '0';
				memWrite <= '0';
				ALUsrc <= '1';
				ALUsrc2 <= '0';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "110";
				
         when "001100" =>	--ANDi
				regDST <= '0';
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= '0';
				memWrite <= '0';
				ALUsrc <= '1';
				ALUsrc2 <= '0';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "010";

         when "001101" =>	--ORi
				regDST <= '0';
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= '0';
				memWrite <= '0';
				ALUsrc <= '1';
				ALUsrc2 <= '0';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "011";
		
		when "001110" =>	--XorI
				regDST <= '0';
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= '0';
				memWrite <= '0';
				ALUsrc <= '1';
				ALUsrc2 <= '0';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "111";					
				
			when "000100" =>	--BEQ
				regDST <= '0';
				jump <= '0';
				branch <= '1';
				branchN <= '0';
				memRead <= '0';
				memToReg <= '0';
				memWrite <= '0';
				ALUsrc <= '0';
				ALUsrc2 <= '0';
				regWrite <= '0';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "001";
	
			when "000101" =>	--BNE
				regDST <= '0';
				jump <= '0';
				branch <= '0';
				branchN <= '1';
				memRead <= '0';
				memToReg <= '0';
				memWrite <= '0';
				ALUsrc <= '0';
				ALUsrc2 <= '0';
				regWrite <= '0';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "001";
		
			when "001111" =>	--LUI
				regDST <= '0';
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= '0';
				memWrite <= '0';
				ALUsrc <= '0';
				ALUsrc2 <= '1';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "000";
			
			when "010011" =>	--LW
				regDST <= '0';
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '1';
				memToReg <= '1';
				memWrite <= '0';
				ALUsrc <= '1';
				ALUsrc2 <= '0';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "000";

			when "101011" =>	--SW
				regDST <= '0';
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= '0';
				memWrite <= '1';
				ALUsrc <= '1';
				ALUsrc2 <= '0';
				regWrite <= '0';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "000";	
	
			when "010000" =>	-- Coprocessor 0
			
				case inst_functor is
					
					when "011000" =>	--ERET
						regDST <= '0';
						jump <= '0';
						branch <= '0';
						branchN <= '0';
						memRead <= '0';
						memToReg <= '0';
						memWrite <= '0';
						ALUsrc <= '0';
						ALUsrc2 <= '0';
						regWrite <= '0';
						eret <= '1';				
						unknown_opcode <= '0';
						ALUop <= "111";		

					when others =>	-- Unknown opcode
						regDST <= '0';
						jump <= '0';
						branch <= '0';
						branchN <= '0';
						memRead <= '0';
						memToReg <= '0';
						memWrite <= '0';
						ALUsrc <= '0';
						ALUsrc2 <= '0';
						regWrite <= '0';
						eret <= '0';				
						unknown_opcode <= '1';
						ALUop <= "111";
		
					end case;
				
			when others =>	-- Unknown opcode
				regDST <= '0';
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= '0';
				memWrite <= '0';
				ALUsrc <= '0';
				ALUsrc2 <= '0';
				regWrite <= '0';
				eret <= '0';				
				unknown_opcode <= '1';
				ALUop <= "111";
			end case;
			
	end process;
end behavioral;