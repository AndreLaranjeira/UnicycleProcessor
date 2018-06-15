library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Memory is

	generic(MIF_FILE : string := "RAM.mif";
			  WSIZE : natural := 32);
	
	port(clock, selector1, write_PC : in STD_LOGIC;
		  keys : in STD_LOGIC_VECTOR(7 downto 0);
		  output : out STD_LOGIC_VECTOR(WSIZE-1 downto 0));
		  
end MIPS_Memory;

architecture behavioral of MIPS_Memory is

	component RAM is

		GENERIC(MIF_FILE : STRING);
	
		PORT(address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			  clock : IN STD_LOGIC;
			  data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			  wren : IN STD_LOGIC;
			  q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
		  
	end component;

	component Multiplexer2to1 is
	
		generic(WSIZE : natural);
	
		port(input1 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  input2 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  selector : in STD_LOGIC;
			  output : out STD_LOGIC_VECTOR(WSIZE-1 downto 0));
		  
	end component;

	component ProgramCounter is
	
		generic(WSIZE : natural);
	
		port(clock : in STD_LOGIC;
			  write_enable : in STD_LOGIC;
			  data : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  output : out STD_LOGIC_VECTOR(WSIZE-1 downto 0));
		  
	end component;
	
	component UnsignedAdder is
	
		generic(WSIZE : natural);
	
		port(input1 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  input2 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  output : out STD_LOGIC_VECTOR(WSIZE-1 downto 0));
		  
	end component;
	
	signal thisPC, nextPC, incrementedPC, extendedKeys : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
	
begin

	extendedKeys <= (x"00000" & "00" & (keys) & "00");

	Memory : RAM 
		generic map(MIF_FILE => MIF_FILE)
		port map(address => thisPC(9 downto 2),
					clock => clock,
					data => x"00000000",
					wren => '0',
					q => output);
	
	M1 : Multiplexer2to1
		generic map(WSIZE => WSIZE)
		port map(input1 => extendedKeys, 
					input2 => incrementedPC,
					selector => selector1,
					output => NextPC);

	PC : ProgramCounter
		generic map(WSIZE => WSIZE)
		port map(clock => clock,
					write_enable => write_PC,
					data => nextPC,
					output => thisPC);
	
	Add4 : UnsignedAdder
		generic map(WSIZE => WSIZE)
		port map(input1 => x"00000004",
					input2 => thisPC,
					output => incrementedPC);

end behavioral;