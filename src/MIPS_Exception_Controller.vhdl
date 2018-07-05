library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Exception_Controller is
	
	generic(WSIZE : natural := 32);
	
	port(overflow, unknown_opcode : in STD_LOGIC;
		  exception_ADDR : out STD_LOGIC_VECTOR(WSIZE-1 downto 0);
		  exception : out STD_LOGIC);
		  
end MIPS_Exception_Controller;

architecture dataflow of MIPS_Exception_Controller is

signal short_ADDR : STD_LOGIC_VECTOR(11 downto 0);

begin

	exception_ADDR <= std_logic_vector(resize(unsigned(short_ADDR), WSIZE));
	
	exception <= '1' when (overflow = '1' or unknown_opcode = '1') else
					 '0';
					 
	short_ADDR <= x"3F0" when (unknown_opcode = '1') else
					  x"3F8" when (overflow = '1') else
					  x"000";

end dataflow;