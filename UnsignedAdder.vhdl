library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UnsignedAdder is
	
	generic(WSIZE : natural := 32);
	
	port(input1 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
		  input2 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
		  output : out STD_LOGIC_VECTOR(WSIZE-1 downto 0));
		  
end UnsignedAdder;

architecture dataflow of UnsignedAdder is

begin

	output <= std_logic_vector(unsigned(input1) + unsigned(input2));

end dataflow;