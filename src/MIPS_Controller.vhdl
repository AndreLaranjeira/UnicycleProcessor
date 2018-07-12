library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Controller is
	
	port(inst_opcode, inst_functor : in std_logic_vector(5 downto 0);
        jump, branch, branchN : out std_logic; 
		  memWrite, ALUsrc, regWrite : out std_logic; 
		  regDST, memToReg : out std_logic_vector (1 downto 0);
		  eret, unknown_opcode : out std_logic;
		  ALUop : out std_logic_vector (3 downto 0);
		  jr, shamt : out std_logic);
		  
end MIPS_Controller;

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
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '0';
				regWrite <= '1';
				eret <= '0';
				unknown_opcode <= '0';
				case inst_functor is
                    when "100100"=> -- AND
                        ALUop <= "0000";
						jr <= '0';
						shamt <='0';
                    when "100101"=> -- OR
                        ALUop <= "0001";
						jr <= '0';
						shamt <='0';
                    when "100000"=> -- ADD
                        ALUop <= "0010";
						jr <= '0';
						shamt <='0';
                    when "100001"=> -- ADDU
                        ALUop <= "0011";
						jr <= '0';
						shamt <='0';
                    when "001000"=> -- JR
                        ALUop <= "0000";
                        jr <= '1';
						shamt <='0';
                    when "100010" => --SUB
                        ALUop <= "0100";
						jr <= '0';
						shamt <='0';
                    when "100011" => --SUBU
                        ALUop <= "0101";
						jr <= '0';
						shamt <='0';
                    when "101010" => --SLT
                        ALUop <= "0110";
						jr <= '0';
						shamt <='0';
                    when "101011" => --SLTU
                        ALUop <= "0111";
						jr <= '0';
						shamt <='0';
                    when "100111" => --NOR
                        ALUop <= "1000";
						jr <= '0';
						shamt <='0';
                    when "100110" => --xor
                        ALUop <= "1001";
						jr <= '0';
						shamt <='0';
                    when "000000" => --sll
                        ALUop <= "1010";
						jr <= '0';
                        shamt <='1';
                    when "000010" => --srl
                        ALUop <= "1011";
						jr <= '0';
                        shamt <='1';
                    when "000011" => --sra
                        ALUop <= "1100";
						jr <= '0';
                        shamt <='1';
                    when others => --funct inválido
                        ALUop <= "1111";
						jr <= '0';
						shamt <='0';
                end case;

         
         when "001000" =>	--addi
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';	
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '1';
				regWrite <= '1';
				eret <= '0';
				unknown_opcode <= '0';
				ALUop <= "0010";
				jr <= '0';
				shamt <='0'; 
         
         when "001001" =>	--addiu
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '1';
				regWrite <= '1';
				eret <= '0';
				unknown_opcode <= '0';
				ALUop <= "0011";
				jr <= '0';
				shamt <='0';
			
         when "000010" =>	--j
				regDST <= "00";
				jump <= '1';
				branch <= '0';
				branchN <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '0';
				regWrite <= '0';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "0010";
				jr <= '0';
				shamt <='0'; 

         when "000011" => 	--jal (usar jump e regwrite sendo 1 para registrador de escrita ser $31)
				regDST <= "11";
				jump <= '1';
				branch <= '0';
				branchN <= '0';
				memToReg <= "11";
				memWrite <= '0';
				ALUsrc <= '0';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "1111";
				jr <= '0';
				shamt <='0'; 
            
         when "001010" =>	--slti
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '1';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "0110";
				jr <= '0';
				shamt <='0';
				
         when "001100" =>	--ANDi
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '1';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "0000";
				jr <= '0';
				shamt <='0';

         when "001101" =>	--ORi
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '1';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "0001";
				jr <= '0';
				shamt <='0';
		
		when "001110" =>	--XorI
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '1';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "1001";
				jr <= '0';
				shamt <='0';				
				
			when "000100" =>	--BEQ
				regDST <= "00";
				jump <= '0';
				branch <= '1';
				branchN <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '0';
				regWrite <= '0';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "0100";
				jr <= '0';
				shamt <='0';
	
			when "000101" =>	--BNE
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '1';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '0';
				regWrite <= '0';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "0100";
				jr <= '0';
				shamt <='0';
		
			when "001111" =>	--LUI
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memToReg <= "10";
				memWrite <= '0';
				ALUsrc <= '0';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "0010";
				jr <= '0';
				shamt <='0'; 
			
			when "100011" =>	--LW
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memToReg <= "01";
				memWrite <= '0';
				ALUsrc <= '1';
				regWrite <= '1';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "0010";
				jr <= '0';
				shamt <='0'; 

			when "101011" =>	--SW
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memToReg <= "00";
				memWrite <= '1';
				ALUsrc <= '1';
				regWrite <= '0';
				eret <= '0';				
				unknown_opcode <= '0';
				ALUop <= "0010"; 
				jr <= '0';
				shamt <='0'; 	
	
			when "010000" =>	-- Coprocessor 0
			
				case inst_functor is
					
					when "011000" =>	--ERET
						regDST <= "00";
						jump <= '0';
						branch <= '0';
						branchN <= '0';
						memToReg <= "00";
						memWrite <= '0';
						ALUsrc <= '0';
						regWrite <= '0';
						eret <= '1';				
						unknown_opcode <= '0';
						ALUop <= "1111";
						jr <= '0';
						shamt <= '0';	

					when others =>	-- Unknown opcode
						regDST <= "00";
						jump <= '0';
						branch <= '0';
						branchN <= '0';
						memToReg <= "00";
						memWrite <= '0';
						ALUsrc <= '0';
						regWrite <= '0';
						eret <= '0';				
						unknown_opcode <= '1';
						ALUop <= "1111";
						jr <= '0';
						shamt <= '0';
		
					end case;
				
			when others =>	-- Unknown opcode
				regDST <= "00";
				jump <= '0';
				branch <= '0';
				branchN <= '0';
				memToReg <= "00";
				memWrite <= '0';
				ALUsrc <= '0';
				regWrite <= '0';
				eret <= '0';				
				unknown_opcode <= '1';
				ALUop <= "1111";
				jr <= '0';
				shamt <= '0';
			end case;
			
	end process;
end behavioral;