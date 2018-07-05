library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Exception_Controller is
	
	generic(WSIZE : natural := 32);
	
	port(overflow, unknown_opcode : in STD_LOGIC;
		  EPC : out STD_LOGIC_VECTOR(WSIZE-1 downto 0);
		  exception : out STD_LOGIC);
		  
end MIPS_Exception_Controller;

architecture dataflow of MIPS_Exception_Controller is

signal short_EPC : STD_LOGIC_VECTOR(7 downto 0);

begin

	EPC <= std_logic_vector(resize(unsigned(short_EPC), WSIZE));
	
	exception <= '1' when (overflow = '1' or unknown_opcode = '1') else
					 '0';
					 
	short_EPC <= x"F0" when (unknown_opcode = '1') else
					 x"F8" when (overflow = '1') else
					 x"00";

end dataflow;