library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_BREG is

	generic(WSIZE : natural := 32);
	
	port(clock, reset, write_enable : in std_logic;
		  readADDR1, readADDR2 : in std_logic_vector(4 downto 0);
		  writeADDR : in std_logic_vector(4 downto 0);
		  write_data : in std_logic_vector(WSIZE-1 downto 0);
		  Reg1, Reg2 : out std_logic_vector(WSIZE-1 downto 0));
		  
end MIPS_BREG;

architecture behavioral of MIPS_BREG is

type Register_Array is array (integer range <>) of std_logic_vector(WSIZE-1 downto 0);

signal GPR : Register_Array(31 downto 0) register := (others => (others => '0'));
					  
begin

	Reg1 <= GPR(to_integer(unsigned(readADDR1)));
	Reg2 <= GPR(to_integer(unsigned(readADDR2)));

	Sync: process(reset, clock)
	
	begin
	
		if(reset = '1') then
			GPR <= (others => (others => '0'));
	
		elsif(rising_edge(clock)) then
				
			if(write_enable = '1' and writeADDR /= "00000") then
				GPR(to_integer(unsigned(writeADDR))) <= write_data;
				
			end if;
		
		end if;
	
	end process;

end behavioral;