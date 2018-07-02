library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplexer2to1 is
	
	generic(WSIZE : natural := 32);
	
	port(input1 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
		  input2 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
		  selector : in STD_LOGIC;
		  output : out STD_LOGIC_VECTOR(WSIZE-1 downto 0));
		  
end Multiplexer2to1;

architecture dataflow of Multiplexer2to1 is

begin

	output <= input1 when (selector = '0') else
				 input2;

end dataflow;