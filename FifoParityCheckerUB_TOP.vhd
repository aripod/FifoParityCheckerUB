----------------------------------------------------------------------------------
-- Author: Ariel Podlubne
-- Task: Design and verification of a FIFO with parity checker.
-- Reason: Excersie pre-interview (Universita di Bologna - Prof. Benini, Prof. Rossi)

-- Component: Top design.
-- Description: Instantiation of FIFO and ParityCheck:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.my_pkg.all;		-- Package including all the customisable parameters.

entity FifoParityCheckerUB_TOP is		
    Port(
		clk 		: in  STD_LOGIC;
      rst_n 	: in  STD_LOGIC;
      data_i   : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
      valid_i  : in  STD_LOGIC;
      grant_o  : out  STD_LOGIC;
      data_o   : out  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
      valid_o 	: out  STD_LOGIC;
      grant_i 	: in  STD_LOGIC);
end FifoParityCheckerUB_TOP;

architecture Behavioral of FifoParityCheckerUB_TOP is

	signal data_signal : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
	signal pop_valid_o_signal : STD_LOGIC;
	signal pop_grant_i_signal : STD_LOGIC;
begin

	TopFifo: entity work.Fifo PORT MAP(
		clk => clk, 								-- Input TOP clk to clk in FIFO.
		rst_n => rst_n, 							-- Input TOP rst_n to rst_n in FIFO.
		push_data_i => data_i,					-- FINISH COMMENTS
		push_valid_i => valid_i,				-- SEPARATE CONTROL AND DATA
		push_grant_o => grant_o,
		pop_data_o => data_signal,
		pop_valid_o => pop_valid_o_signal,
		pop_grant_i => pop_grant_i_signal
	);
	
	TopParityCheck: entity work.ParityCheck PORT MAP(
		parity_data_i => data_signal,
		parity_valid_o => valid_o,
		parity_grant_o => pop_valid_o_signal,
		parity_valid_i => pop_valid_o_signal,
		parity_grant_i => pop_grant_i_signal
	);

	data_o <= data_signal;
end Behavioral;

