library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
	
entity NibbleDisplayConverter is
	
	port(input : in STD_LOGIC_VECTOR(31 downto 0);
		  output : out STD_LOGIC_VECTOR(0 to 55));
		  
end NibbleDisplayConverter;

architecture dataflow of NibbleDisplayConverter is

	component NibbleDisplay is

		port(nibble : in STD_LOGIC_VECTOR(3 downto 0);
			  display_code : out STD_LOGIC_VECTOR(0 to 6));
		  
	end component;

begin

	ND_0: NibbleDisplay
		port map(display_code => output(0 to 6),
					nibble => input(3 downto 0));

	ND_1: NibbleDisplay
		port map(display_code => output(7 to 13),
					nibble => input(7 downto 4));
					
	ND_2: NibbleDisplay
		port map(display_code => output(14 to 20),
					nibble => input(11 downto 8));
					
	ND_3: NibbleDisplay
		port map(display_code => output(21 to 27),
					nibble => input(15 downto 12));					

	ND_4: NibbleDisplay
		port map(display_code => output(28 to 34),
					nibble => input(19 downto 16));
					
	ND_5: NibbleDisplay
		port map(display_code => output(35 to 41),
					nibble => input(23 downto 20));

	ND_6: NibbleDisplay
		port map(display_code => output(42 to 48),
					nibble => input(27 downto 24));					

	ND_7: NibbleDisplay
		port map(display_code => output(49 to 55),
					nibble => input(31 downto 28));
					
end dataflow;					