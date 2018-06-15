library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Processor_Unicycle is

	-- TODO: Code the ports and generics of this entity.

	-- generic();
	
	-- port();
		  
end MIPS_Processor_Unicycle;

architecture behavioral of MIPS_Processor_Unicycle is

	component MIPS_BREG is

		generic(WSIZE : natural);
	
		port(clock, reset, write_enable : in std_logic;
			  readADDR1, readADDR2 : in std_logic_vector(4 downto 0);
			  writeADDR : in std_logic_vector(4 downto 0);
			  write_data : in std_logic_vector(WSIZE-1 downto 0);
			  Reg1, Reg2 : out std_logic_vector(WSIZE-1 downto 0));
		  
	end component;
	
	-- Note: This is an instruction memory, not a general memory.
	
	-- TODO: When convinient, this component should be renamed to better reflect
	-- it's nature and restructured to allow for better modularity.
	
	component MIPS_Memory is

		generic(MIF_FILE : string;
				  WSIZE : natural=);
	
		port(clock, selector1, write_PC : in STD_LOGIC;
			  keys : in STD_LOGIC_VECTOR(7 downto 0);
			  output : out STD_LOGIC_VECTOR(WSIZE-1 downto 0));
		  
	end component;

	component MIPS_ULA is

		generic(WSIZE : natural);
	
		port(opcode : in std_logic_vector(3 downto 0);
			  A, B : in std_logic_vector(WSIZE-1 downto 0);
			  R : out std_logic_vector(WSIZE-1 downto 0);
			  Z, O : out std_logic);
		  
	end component;

	component Multiplexer2to1 is
	
		generic(WSIZE : natural);
	
		port(input1 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  input2 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  selector : in STD_LOGIC;
			  output : out STD_LOGIC_VECTOR(WSIZE-1 downto 0));
		  
	end component;

	component UnsignedAdder is
	
		generic(WSIZE : natural);
	
		port(input1 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  input2 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  output : out STD_LOGIC_VECTOR(WSIZE-1 downto 0));
		  
	end component;

end behavioral;