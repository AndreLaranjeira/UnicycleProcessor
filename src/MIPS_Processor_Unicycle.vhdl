library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Processor_Unicycle is

	-- TODO: Code the ports and generics of this entity.

	generic(MIF_FILE_INSTRUCTION : string := "RAM.mif";
			  MIF_FILE_DATA : string := "DATA.mif";
			  inst_types_bits : natural := 1;
			  WSIZE : natural := 32);
	
	port(clock : in STD_LOGIC;
		  keys : in STD_LOGIC_VECTOR(7 downto 0));
		  
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
				  WSIZE : natural);
	
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
	
	component NibbleDisplay is

		port(nibble : in STD_LOGIC_VECTOR(3 downto 0);
			  display_code : out STD_LOGIC_VECTOR(7 downto 0));
		  
	end component;

	component UnsignedAdder is
	
		generic(WSIZE : natural);
	
		port(input1 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  input2 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  output : out STD_LOGIC_VECTOR(WSIZE-1 downto 0));
		  
	end component;

signal branch, read_DATA_MEM, write_BREG, write_DATA_MEM : STD_LOGIC;
signal mux_BREG_WD, mux_BREG_WR, mux_ULA_opB : STD_LOGIC;
signal opcode_type : STD_LOGIC_VECTOR(inst_types_bits downto 0);
	
signal BREG_R1, BREG_R2, BREG_WR : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal BREG_D1, BREG_D2, BREG_WD : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal DATA_MEM_output : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal PC_plus_4, next_PC, sxt_imm : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal ULA_opA, ULA_opB, ULA_result : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
	
begin


	
end behavioral;