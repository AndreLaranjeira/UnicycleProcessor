library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Processor_Unicycle is

	generic(MIF_FILE_DATA : string := "mif/Data.mif";
			  MIF_FILE_INSTRUCTION : string := "mif/Instructions.mif";
			  BREG_SIZE : natural := 5;
			  OPCODE_SIZE : natural := 4;
			  TYPES_SIZE : natural := 2;
			  WSIZE : natural := 32);
	
	port(clock, keys_input, reset, run : in STD_LOGIC;
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
			  reg1, reg2 : out std_logic_vector(WSIZE-1 downto 0));
		  
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
	
	component ProgramCounter is
	
		generic(WSIZE : natural);
	
		port(clock : in STD_LOGIC;
			  write_enable : in STD_LOGIC;
			  data : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  output : out STD_LOGIC_VECTOR(WSIZE-1 downto 0));
		  
	end component;
	
	component RAM is

		GENERIC(MIF_FILE : STRING);
	
		PORT(address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			  clock : IN STD_LOGIC;
			  data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			  wren : IN STD_LOGIC;
			  q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
		  
	end component;

	component UnsignedAdder is
	
		generic(WSIZE : natural);
	
		port(input1 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  input2 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  output : out STD_LOGIC_VECTOR(WSIZE-1 downto 0));
		  
	end component;

-- Control signals
	
signal branch, read_DATA_MEM, write_BREG, write_DATA_MEM : STD_LOGIC;
signal sel_BREG_WD, sel_BREG_WR, sel_ULA_opB : STD_LOGIC;
signal ULA_overflow, ULA_zero : STD_LOGIC;
signal instruction_type : STD_LOGIC_VECTOR(TYPES_SIZE-1 downto 0);
signal ULA_opcode : STD_LOGIC_VECTOR(OPCODE_SIZE-1 downto 0);

-- Data signals

signal BREG_R1, BREG_R2, BREG_WR : STD_LOGIC_VECTOR(BREG_SIZE-1 downto 0);

signal branch_ADDR : STD_LOGIC_VECTOR(WSIZE-1 downto 0);	
signal BREG_D1, BREG_D2, BREG_WD : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal DATA_MEM_output : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal instruction : STD_LOGIC_VECTOR(WSIZE-1 downto 0); 
signal PC_input, PC_output : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal PC_plus_4, next_PC : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal sxt_imm, sxt_keys : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal ULA_opB, ULA_result : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
	
begin

-- Signal attributions:
	
	BREG_R1 <= instruction(25 downto 21);
	BREG_R2 <= instruction(20 downto 16);
	sxt_imm <= std_logic_vector(resize(signed(instruction(15 downto 0)), WSIZE));
	sxt_keys <= std_logic_vector(resize(signed(keys & "00"), WSIZE));

-- BREG (Register bank):

	BREG : MIPS_BREG
		generic map(WSIZE => WSIZE)
		port map(clock => clock,
					readADDR1 => BREG_R1,
					readADDR2 => BREG_R2,
					reg1 => BREG_D1,
					reg2 => BREG_D2,
					reset => reset,
					writeADDR => BREG_WR,
					write_data => BREG_WD,
					write_enable => write_BREG);

-- Memory units (RAMs):

	Data_RAM : RAM 
		generic map(MIF_FILE => MIF_FILE_DATA)
		port map(address => ULA_result(7 downto 0),
					clock => clock,
					data => BREG_D2,
					wren => write_DATA_MEM,
					q => DATA_MEM_output);

	Instruction_RAM : RAM 
		generic map(MIF_FILE => MIF_FILE_INSTRUCTION)
		port map(address => PC_output(9 downto 2),
					clock => clock,
					data => x"00000000",
					wren => '0',
					q => instruction);
					
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
	
	Mux_PC_input : Multiplexer2to1
		generic map(WSIZE => WSIZE)
		port map(input1 => next_PC,
					input2 => sxt_keys,
					selector => keys_input,
					output => PC_input);
	
	Mux_next_PC : Multiplexer2to1
		generic map(WSIZE => WSIZE)
		port map(input1 => PC_plus_4, 
					input2 => branch_ADDR,
					selector => (branch and ULA_zero),
					output => next_PC);
				
	Mux_ULA_opB : Multiplexer2to1
		generic map(WSIZE => WSIZE)
		port map(input1 => BREG_D2, 
					input2 => sxt_imm,
					selector => sel_ULA_opB,
					output => ULA_opB);	

-- PC (Program counter):

	PC: ProgramCounter
		generic map(WSIZE => WSIZE)
		port map(clock => clock,
					data => PC_input,
					output => PC_output,
					write_enable => not(run));
					
-- ULA (Arithmetic and Logic Unit):

	ULA: MIPS_ULA
		generic map(WSIZE => WSIZE)
		port map(opcode => ULA_opcode,
					A => BREG_D1,
					B => ULA_opB,
					O => ULA_overflow,
					R => ULA_result,
					Z => ULA_zero);
					
-- Unsigned adders:
					
	UA_branch_ADDR : UnsignedAdder
		generic map(WSIZE => WSIZE)
		port map(input1 => BREG_D2, 
					input2 => (sxt_imm(WSIZE-3 downto 0) & "00"),
					output => branch_ADDR);	
	
	UA_PC_plus_4 : UnsignedAdder
		generic map(WSIZE => WSIZE)
		port map(input1 => std_logic_vector(to_unsigned(4, WSIZE)),
					input2 => PC_output,
					output => PC_plus_4);
	
end behavioral;

-- TODO list:
--		Finish behavioral architecture of MIPS_Processor_Unicycle.
--		Replace 2 PC related Mux2to1 with 1 Mux4to1.
--		Organize signal order.
--		Break down MIPS_Memory component. 
--		Add generics for every component length variable. 