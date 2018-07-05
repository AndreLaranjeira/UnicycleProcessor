library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Controller is
	
	port(inst_opcode, inst_functor : in std_logic_vector(5 downto 0);
        regDST, jump, branch, branchN, memRead : out std_logic; 
		  memWrite, ALUsrc, regWrite : out std_logic; 
		  regDST, memToReg : out std_logic_vector (1 downto 0);
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
				regDST <= "01";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '0';
				regWrite <= '1';
				eret <= '0';
				unknown_opcode <= '0';
				ALUop <= "100";
         
         when "001000" =>	--addi
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '1';
				regWrite <= '1';
				eret <= '0';
				unknown_opcode <= '0';
				ALUop <= "000";
         
         when "001001" =>	--addiu
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '1';
				regWrite <= '1';
				eret <= '0';
				unknown_opcode <= '0';
				ALUop <= "101";
			
         when "000010" =>	--j
				regDST <= "00";
				jump <= '1';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '0';
				regWrite <= '0';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "000";

         when "000011" => 	--jal (usar jump e regwrite sendo 1 para registrador de escrita ser $31)
				regDST <= "11";
				jump <= '1';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= "11";
				memWrite <= '0';
				ALUsrc <= '0';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "000";
            
         when "001010" =>	--slti
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '1';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "110";
				
         when "001100" =>	--ANDi
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '1';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "010";

         when "001101" =>	--ORi
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '1';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "011";
		
		when "001110" =>	--XorI
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '1';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "111";					
				
			when "000100" =>	--BEQ
				regDST <= "00";
				jump <= '0';
				branch <= '1';
				branchN <= '0';
				memRead <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '0';
				regWrite <= '0';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "001";
	
			when "000101" =>	--BNE
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '1';
				memRead <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '0';
				regWrite <= '0';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "001";
		
			when "001111" =>	--LUI
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= "10";
				memWrite <= '0';
				ALUsrc <= '0';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "000";
			
			when "100011" =>	--LW
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '1';
				memToReg <= "01";
				memWrite <= '0';
				ALUsrc <= '1';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "000";

			when "101011" =>	--SW
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= "00";
				memWrite <= '1';
				ALUsrc <= '1';
				regWrite <= '0';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "000";	
	
			when "010000" =>	-- Coprocessor 0
			
				case inst_functor is
					
					when "011000" =>	--ERET
						regDST <= "00";
						jump <= '0';
						branch <= '0';
						branchN <= '0';
						memRead <= '0';
						memToReg <= "00";
						memWrite <= '0';
						ALUsrc <= '0';
						regWrite <= '0';
						eret <= '1';				
						unknown_opcode <= '0';
						ALUop <= "111";		

					when others =>	-- Unknown opcode
						regDST <= "00";
						jump <= '0';
						branch <= '0';
						branchN <= '0';
						memRead <= '0';
						memToReg <= "00";
						memWrite <= '0';
						ALUsrc <= '0';
						regWrite <= '0';
						eret <= '0';				
						unknown_opcode <= '1';
						ALUop <= "111";
		
					end case;
				
			when others =>	-- Unknown opcode
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memRead <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '0';
				regWrite <= '0';
				eret <= '0';				
				unknown_opcode <= '1';
				ALUop <= "111";
			end case;
			
	end process;
end behavioral;