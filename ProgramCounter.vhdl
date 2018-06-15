library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ProgramCounter is
	
	generic(WSIZE : natural := 32);
	
	port(clock, write_enable : in STD_LOGIC;
		  data : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
		  output : out STD_LOGIC_VECTOR(WSIZE-1 downto 0));
		  
end ProgramCounter;

architecture behavioral of ProgramCounter is

signal counter : STD_LOGIC_VECTOR(WSIZE-1 downto 0) := (others => '0');

begin

	output <= counter;
	
	Sync: process(clock, write_enable)
	
	begin
	
		if(falling_edge(clock) and write_enable = '1') then
			counter <= data;
		end if;
				  
	end process;

end behavioral;