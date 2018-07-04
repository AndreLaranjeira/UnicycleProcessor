library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Processor_Unicycle is

	generic(MIF_FILE_DATA : string := "DATA.mif";
			  MIF_FILE_INSTRUCTION : string := "RAM.mif";
			  BREG_SIZE : natural := 5;
			  TYPES_SIZE : natural := 1;
			  WSIZE : natural := 32);
	
	port(clock : in STD_LOGIC;
		  keys : in STD_LOGIC_VECTOR(7 downto 0));
		  
end MIPS_Processor_Unicycle;

architecture behavioral of MIPS_Processor_Unicycle is

-- Components

	component MIPS_BREG is

		generic(WSIZE : natural);
	
		port(clock, reset, write_enable : in std_logic;
			  readADDR1, readADDR2 : in std_logic_vector(4 downto 0);
			  writeADDR : in std_logic_vector(4 downto 0);
			  write_data : in std_logic_vector(WSIZE-1 downto 0);
			  Reg1, Reg2 : out std_logic_vector(WSIZE-1 downto 0));
		  
	end component;
	
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

-- Control signals
	
signal branch, read_DATA_MEM, ULA_zero, write_BREG, write_DATA_MEM : STD_LOGIC;
signal sel_BREG_WD, sel_BREG_WR, sel_ULA_opB : STD_LOGIC;
signal opcode_type : STD_LOGIC_VECTOR(TYPES_SIZE downto 0);

-- Data signals

signal branch_ADDR : STD_LOGIC_VECTOR(WSIZE-1 downto 0);	
signal BREG_R1, BREG_R2, BREG_WR : STD_LOGIC_VECTOR(BREG_SIZE-1 downto 0);
signal BREG_D1, BREG_D2, BREG_WD : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal DATA_MEM_output : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal instruction : STD_LOGIC_VECTOR(WSIZE-1 downto 0); 
signal PC, PC_plus_4, next_PC, sxt_imm : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal ULA_opA, ULA_opB, ULA_result : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
	
begin

-- Multiplexers:

	Mux_BREG_WD : Multiplexer2to1
		generic map(WSIZE => WSIZE)
		port map(input1 => ULA_result, 
					input2 => DATA_MEM_output,
					selector => sel_BREG_WD,
					output => BREG_WD);

	Mux_BREG_WR : Multiplexer2to1
		generic map(WSIZE => BREG_SIZE)
		port map(input1 => instruction(20 downto 16), 
					input2 => instruction(15 downto 11),
					selector => sel_BREG_WR,
					output => BREG_WR);
					
	Mux_next_PC : Multiplexer2to1
		generic map(WSIZE => WSIZE)
		port map(input1 => PC_plus_4, 
					input2 => branch_ADDR,
					selector => (branch and ULA_zero),
					output => Next_PC);
				
	Mux_ULA_opB : Multiplexer2to1
		generic map(WSIZE => WSIZE)
		port map(input1 => BREG_D2, 
					input2 => sxt_imm,
					selector => sel_ULA_opB,
					output => ULA_opB);	
					
-- Unsigned adders:
					
	UA_branch_ADDR : UnsignedAdder
		generic map(WSIZE => WSIZE)
		port map(input1 => BREG_D2, 
					input2 => (sxt_imm(WSIZE-3 downto 0) & "00"),
					output => branch_ADDR);	
	
	UA_PC_plus_4 : UnsignedAdder
		generic map(WSIZE => WSIZE)
		port map(input1 => x"00000004",
					input2 => PC,
					output => PC_plus_4);
	
end behavioral;

-- TODO list:
--		Finish behavioral architecture of MIPS_Processor_Unicycle.
--		Organize signal order.
--		Break down MIPS_Memory component. 
--		Add generic for number of registers in MIPS_BREG component. 