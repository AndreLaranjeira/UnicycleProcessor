library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_ULA is

	generic(WSIZE : natural := 32);
	
	port(opcode : in std_logic_vector(3 downto 0);
		  A, B : in std_logic_vector(WSIZE-1 downto 0);
		  R : out std_logic_vector(WSIZE-1 downto 0);
		  Z, O : out std_logic);
		  
end MIPS_ULA;

architecture behavioral of MIPS_ULA is

signal result : std_logic_vector(WSIZE-1 downto 0) := (others => '0');
signal overflow : std_logic := '0';

begin
			  
	Operation: process(A, B, opcode)
	
		variable SA, SB, SR : std_logic := '0';
		variable tmp : std_logic_vector(WSIZE-1 downto 0) := (others => '0');
	
		begin
		
			case opcode is
			
				-- Bitwise and.
				when "0000" => 
					result <= A and B;
					overflow <= '0';
				
				-- Bitwise or.
				when "0001" => 
					result <= A or B;
					overflow <= '0';
			
				-- Sum with overflow.
				when "0010" =>
					tmp := std_logic_vector(unsigned(A) + unsigned(B));	
					SA := A(WSIZE-1);
					SB := B(WSIZE-1);
					SR := tmp(WSIZE-1);
					result <= tmp(WSIZE-1 downto 0);
					overflow <= ((SA xnor SB) and (SA xor SR));								
					
				-- Sum without overflow.
				when "0011" =>
					result <= std_logic_vector(unsigned(A) + unsigned(B));
					overflow <= '0';
				
				-- Subtraction with overflow.
				when "0100" =>
					tmp := std_logic_vector(unsigned(A) - unsigned(B));
					SA := A(WSIZE-1);
					SB := not(B(WSIZE-1));
					SR := tmp(WSIZE-1);
					result <= tmp(WSIZE-1 downto 0);
					overflow <= ((SA xnor SB) and (SA xor SR));
				
				-- Subtraction without overflow.
				when "0101" =>
					result <= std_logic_vector(unsigned(A) - unsigned(B));
					overflow <= '0';
				
				-- Set on less than.
				when "0110" => 
				
					if(signed(B) > signed(A)) then
						result(WSIZE-1 downto 1) <= (others => '0');
						result(0) <= '1';
						
					else
						result <= (others => '0');
						
					end if;
					
					overflow <= '0';
					
				-- Set on less than unsigned.	
				when "0111" =>
				
					if(unsigned(B) > unsigned(A)) then 
						result(WSIZE-1 downto 1) <= (others => '0');
						result(0) <= '1';
						
					else
						result <= (others => '0');
						
					end if;
					
					overflow <= '0';
				
				-- Bitwise nor.
				when "1000" =>
					result <= A nor B;
					overflow <= '0';
					
				-- Bitwise xor.
				when "1001" =>
					result <= A xor B;
					overflow <= '0';
				
				-- Shift left logical.
				when "1010" =>
					result <= std_logic_vector(shift_left(unsigned(B),
														to_integer(unsigned(A))));
					overflow <= '0';
				
				-- Shift right logical.
				when "1011" =>
					result <= std_logic_vector(shift_right(unsigned(B),
														to_integer(unsigned(A))));
					overflow <= '0';
				
				-- Shift right arithmetic.
				when "1100" =>
					result <= std_logic_vector(shift_right(signed(B),
														to_integer(unsigned(A))));
					overflow <= '0';
				
				-- Rotate right.
				when "1101" =>
					result <= std_logic_vector(rotate_right(unsigned(B),
														to_integer(unsigned(A))));
					overflow <= '0';
				
				-- Rotate left.
				when "1110" =>
					result <= std_logic_vector(rotate_left(unsigned(B),
														to_integer(unsigned(A))));
					overflow <= '0';
					
				-- Unknown OPCODE.
				when others =>
					result <= (others => '0');
					overflow <= '0';
			
			end case;
		
		end process;
		
	Output: process(result, overflow)
	
		variable zero: std_logic_vector(WSIZE-1 downto 0);
	
		begin
		
				O <= overflow;
				zero := (others => '0');
				
				if(overflow = '0') then
					R <= result;
				
				else
					R <= (others => '0');
				
				end if;
	
				if(result = zero) then
					Z <= '1';
					
				elsif(overflow = '1') then
					Z <= '1';
				
				else
					Z <= '0';
					
				end if;
		
		end process;

end behavioral;