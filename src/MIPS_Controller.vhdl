library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Controller is

	generic(WSIZE : natural := 32);
	
	port(intruction_opcode : in std_logic_vector(5 downto 0);
        regDST, jump, branch, memRead, memToReg, ALUop, memWrite, ALUsrc, regWrite : out std_logic;
		  
		  
end MIPS_Controller;

architecture behavioral of MIPS_Controller is

end behavioral;