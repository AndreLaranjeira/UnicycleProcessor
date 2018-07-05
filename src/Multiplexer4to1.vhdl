library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplexer4to1 is
	
	generic(WSIZE : natural := 32);
	
	port(input1, input2, input3, input4 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
		  selector : in STD_LOGIC_VECTOR(1 downto 0);
		  output : out STD_LOGIC_VECTOR(WSIZE-1 downto 0));
		  
end Multiplexer4to1;

architecture dataflow of Multiplexer4to1 is

begin

	output <= input1 when (selector = "00") else
				 input2 when (selector = "01") else
				 input3 when (selector = "10") else
				 input4;

end dataflow;