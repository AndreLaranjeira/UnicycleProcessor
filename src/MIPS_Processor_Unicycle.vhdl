library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
	
entity MIPS_Processor_Unicycle is

	generic(MIF_FILE_DATA : string := "mif/Data.mif";
			  MIF_FILE_INSTRUCTION : string := "mif/Instructions.mif";
			  BREG_SIZE : natural := 5;
			  OPCODE_SIZE : natural := 4;
			  TYPES_SIZE : natural := 3;
			  WSIZE : natural := 32);
	
	port(clock, keys_input, nibble_view, reset, run : in STD_LOGIC;
		  keys : in STD_LOGIC_VECTOR(7 downto 0);
		  nibble_codes : out STD_LOGIC_VECTOR(0 to 55));
		  
end MIPS_Processor_Unicycle;

architecture behavioral of MIPS_Processor_Unicycle is

-- Components:

	component MIPS_BREG is

		generic(WSIZE : natural);
	
		port(clock, reset, write_enable : in std_logic;
			  readADDR1, readADDR2 : in std_logic_vector(4 downto 0);
			  writeADDR : in std_logic_vector(4 downto 0);
			  write_data : in std_logic_vector(WSIZE-1 downto 0);
			  Reg1, Reg2 : out std_logic_vector(WSIZE-1 downto 0));
		  
	end component;
	
	component MIPS_Controller is
	
		port(inst_opcode, inst_functor : in std_logic_vector(5 downto 0);
			  regDST, jump, branch, branchN, memRead, memToReg : out std_logic; 
			  memWrite, ALUsrc, ALUsrc2, regWrite : out std_logic;
			  eret, unknown_opcode : out std_logic;
			  ALUop : out std_logic_vector (2 downto 0));
		  
	end component;
	
	component MIPS_Exception_Controller is
	
		generic(WSIZE : natural);
	
		port(overflow, unknown_opcode : in STD_LOGIC;
			  exception_ADDR : out STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  exception : out STD_LOGIC);
		  
	end component;

	component MIPS_ULA_Controller is
	
		port(ALUop : in std_logic_vector(2 downto 0);
			  intFunct : in std_logic_vector(5 downto 0);
			  ALU : out std_logic_vector (3 downto 0);
			  jr : out std_logic;
			  shamt : out std_logic);
		  
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
	
	component Multiplexer4to1 is
	
		generic(WSIZE : natural);
	
		port(input1, input2 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  input3, input4 : in STD_LOGIC_VECTOR(WSIZE-1 downto 0);
			  selector : in STD_LOGIC_VECTOR(1 downto 0);
			  output : out STD_LOGIC_VECTOR(WSIZE-1 downto 0));
		  
	end component;	
	
	component NibbleDisplay is

		port(nibble : in STD_LOGIC_VECTOR(3 downto 0);
			  display_code : out STD_LOGIC_VECTOR(0 to 6));
		  
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
	
signal branch, branchN, eret, exception, jump, read_DATA_MEM : STD_LOGIC;
signal sel_BREG_WD, sel_BREG_WR, sel_JR, sel_shamt : STD_LOGIC;
signal sel_ULA_opB, sel_ULA_opB2 : STD_LOGIC;
signal ULA_overflow, ULA_zero : STD_LOGIC;
signal unknown_opcode : STD_LOGIC;
signal write_BREG, write_DATA_MEM : STD_LOGIC;

signal instruction_type : STD_LOGIC_VECTOR(TYPES_SIZE-1 downto 0);
signal ULA_opcode : STD_LOGIC_VECTOR(OPCODE_SIZE-1 downto 0);

-- Data signals

signal BREG_R1, BREG_R2, BREG_WR : STD_LOGIC_VECTOR(BREG_SIZE-1 downto 0);

signal branch_ADDR : STD_LOGIC_VECTOR(WSIZE-1 downto 0);	
signal BREG_D1, BREG_D2, BREG_WD : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal DATA_MEM_output : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal EPC_output, exception_ADDR : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal instruction : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal jump_ADDR : STD_LOGIC_VECTOR(WSIZE-1 downto 0);	 
signal PC_input, PC_output : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal PC_plus_4, next_PC : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal sxt_imm, sxt_keys : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
signal ULA_opB, ULA_result : STD_LOGIC_VECTOR(WSIZE-1 downto 0);

signal inst_nibble_codes, PC_nibble_codes : STD_LOGIC_VECTOR(0 to 55);
	
begin

-- Signal attributions:
	
	BREG_R1 <= instruction(25 downto 21);
	BREG_R2 <= instruction(20 downto 16);
	jump_ADDR <= (PC_plus_4(WSIZE-1 downto WSIZE-4) & instruction(25 downto 0) & "00");
	sxt_imm <= std_logic_vector(resize(signed(instruction(15 downto 0)), WSIZE));
	sxt_keys <= std_logic_vector(resize(unsigned(keys & "00"), WSIZE));

-- BREG (Register bank):

	BREG: MIPS_BREG
		generic map(WSIZE => WSIZE)
		port map(clock => clock,
					readADDR1 => BREG_R1,
					readADDR2 => BREG_R2,
					Reg1 => BREG_D1,
					Reg2 => BREG_D2,
					reset => reset,
					writeADDR => BREG_WR,
					write_data => BREG_WD,
					write_enable => write_BREG);

-- Controllers:
					
	Controller: MIPS_Controller
		port map(ALUop => instruction_type,
					ALUsrc => sel_ULA_opB,
					ALUsrc2 => sel_ULA_opB2,
					branch => branch,
					branchN => branchN,
					eret => eret,
					inst_functor => instruction(5 downto 0),
					inst_opcode => instruction(31 downto 26),
					jump => jump,
					memRead => read_DATA_MEM,
					memToReg => sel_BREG_WD,
					memWrite => write_DATA_MEM,
					regDST => sel_BREG_WR,
					regWrite => write_BREG,
					unknown_opcode => unknown_opcode);
	
	Exception_Controller: MIPS_Exception_Controller
		generic map(WSIZE => WSIZE)
		port map(exception_ADDR => exception_ADDR,
					exception => exception,
					overflow => ULA_overflow,
					unknown_opcode => unknown_opcode);
	
	ULA_Controller: MIPS_ULA_Controller
		port map(ALUop => instruction_type,
					intFunct => instruction (5 downto 0),
					ALU => ULA_opcode,
					jr => sel_JR,
					shamt => sel_shamt);
					
-- Memory units (RAMs):

	Data_RAM: RAM 
		generic map(MIF_FILE => MIF_FILE_DATA)
		port map(address => ULA_result(7 downto 0),
					clock => not(clock),
					data => BREG_D2,
					wren => write_DATA_MEM,
					q => DATA_MEM_output);

	Instruction_RAM: RAM 
		generic map(MIF_FILE => MIF_FILE_INSTRUCTION)
		port map(address => PC_output(9 downto 2),
					clock => clock,
					data => x"00000000",
					wren => '0',
					q => instruction);
					
-- Multiplexers:

	Mux_BREG_WD: Multiplexer4to1
		generic map(WSIZE => WSIZE)
		port map(input1 => ULA_result, 
					input2 => DATA_MEM_output,
					input3 => sxt_imm,
					input4 => PC_plus_4,
					selector => (((jump and sel_BREG_WD) or sel_ULA_opB2) & (sel_BREG_WD and not(sel_ULA_opB2))),
					output => BREG_WD);

	Mux_BREG_WR: Multiplexer4to1
		generic map(WSIZE => BREG_SIZE)
		port map(input1 => instruction(20 downto 16), 
					input2 => instruction(15 downto 11),
					input3 => "00000",
					input4 => "11111",
					selector => (jump and sel_BREG_WD) & sel_BREG_WR,
					output => BREG_WR);
	
	Mux_nibble_codes: Multiplexer2to1
		generic map(WSIZE => 56)
		port map(input1 => PC_nibble_codes, 
					input2 => inst_nibble_codes,
					selector => nibble_view,
					output => nibble_codes);
	
	Mux_next_PC: Multiplexer4to1
		generic map(WSIZE => WSIZE)
		port map(input1 => PC_plus_4, 
					input2 => branch_ADDR,
					input3 => jump_ADDR,
					input4 => BREG_D1,
					selector => ((jump or sel_JR) & (((branchN and not(ULA_zero)) or (branch and ULA_zero)) or sel_JR)),
					output => next_PC);
				
	Mux_PC_input: Multiplexer4to1
		generic map(WSIZE => WSIZE)
		port map(input1 => next_PC,
					input2 => exception_ADDR,
					input3 => EPC_output,
					input4 => sxt_keys,
					selector => ((keys_input or eret) & (keys_input or exception)),
					output => PC_input);				
				
	Mux_ULA_opB: Multiplexer4to1
		generic map(WSIZE => WSIZE)
		port map(input1 => BREG_D2, 
					input2 => sxt_imm,
					input3 => std_logic_vector(resize(unsigned(instruction(10 downto 6)), WSIZE)),
					input4 => std_logic_vector(to_unsigned(0, WSIZE)),
					selector => (sel_shamt & sel_ULA_opB),
					output => ULA_opB);	

-- Nibble displays:

	ND_PC_0: NibbleDisplay
		port map(display_code => PC_nibble_codes(0 to 6),
					nibble => PC_output(3 downto 0));

	ND_PC_1: NibbleDisplay
		port map(display_code => PC_nibble_codes(7 to 13),
					nibble => PC_output(7 downto 4));
					
	ND_PC_2: NibbleDisplay
		port map(display_code => PC_nibble_codes(14 to 20),
					nibble => PC_output(11 downto 8));
					
	ND_PC_3: NibbleDisplay
		port map(display_code => PC_nibble_codes(21 to 27),
					nibble => PC_output(15 downto 12));					

	ND_PC_4: NibbleDisplay
		port map(display_code => PC_nibble_codes(28 to 34),
					nibble => PC_output(19 downto 16));
					
	ND_PC_5: NibbleDisplay
		port map(display_code => PC_nibble_codes(35 to 41),
					nibble => PC_output(23 downto 20));

	ND_PC_6: NibbleDisplay
		port map(display_code => PC_nibble_codes(42 to 48),
					nibble => PC_output(27 downto 24));					

	ND_PC_7: NibbleDisplay
		port map(display_code => PC_nibble_codes(49 to 55),
					nibble => PC_output(31 downto 28));

	ND_inst_0: NibbleDisplay
		port map(display_code => inst_nibble_codes(0 to 6),
					nibble => instruction(3 downto 0));

	ND_inst_1: NibbleDisplay
		port map(display_code => inst_nibble_codes(7 to 13),
					nibble => instruction(7 downto 4));
					
	ND_inst_2: NibbleDisplay
		port map(display_code => inst_nibble_codes(14 to 20),
					nibble => instruction(11 downto 8));
					
	ND_inst_3: NibbleDisplay
		port map(display_code => inst_nibble_codes(21 to 27),
					nibble => instruction(15 downto 12));					

	ND_inst_4: NibbleDisplay
		port map(display_code => inst_nibble_codes(28 to 34),
					nibble => instruction(19 downto 16));
					
	ND_inst_5: NibbleDisplay
		port map(display_code => inst_nibble_codes(35 to 41),
					nibble => instruction(23 downto 20));

	ND_inst_6: NibbleDisplay
		port map(display_code => inst_nibble_codes(42 to 48),
					nibble => instruction(27 downto 24));					

	ND_inst_7: NibbleDisplay
		port map(display_code => inst_nibble_codes(49 to 55),
					nibble => instruction(31 downto 28));
					
-- Program counters:

	EPC: ProgramCounter
		generic map(WSIZE => WSIZE)
		port map(clock => clock,
					data => PC_plus_4,
					output => EPC_output,
					write_enable => exception);
					
	PC: ProgramCounter
		generic map(WSIZE => WSIZE)
		port map(clock => clock,
					data => PC_input,
					output => PC_output,
					write_enable => run);
					
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
					
	UA_branch_ADDR: UnsignedAdder
		generic map(WSIZE => WSIZE)
		port map(input1 => BREG_D2, 
					input2 => (sxt_imm(WSIZE-3 downto 0) & "00"),
					output => branch_ADDR);	
	
	UA_PC_plus_4: UnsignedAdder
		generic map(WSIZE => WSIZE)
		port map(input1 => std_logic_vector(to_unsigned(4, WSIZE)),
					input2 => PC_output,
					output => PC_plus_4);
	
end behavioral;

-- TODO list:
--		Finish behavioral architecture of MIPS_Processor_Unicycle.
--		Implement ERET instruction.
--		Merge ULA_Controller into Controller.
--		Add generics for every component length variable. 