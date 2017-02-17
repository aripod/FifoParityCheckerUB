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
      data_i   : in  STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
      valid_i  : in  STD_LOGIC;
      grant_o  : out  STD_LOGIC;
      data_o   : out  STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
      valid_o 	: out  STD_LOGIC;
      grant_i 	: in  STD_LOGIC);
end FifoParityCheckerUB_TOP;

architecture Behavioral of FifoParityCheckerUB_TOP is

	signal data_signal : STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
	signal pop_valid_o_signal : STD_LOGIC;
	signal pop_grant_i_signal : STD_LOGIC;
begin

	TopFifo: entity work.Fifo PORT MAP(
		clk => clk, 									-- Input TOP clk to clk in FIFO.
		rst_n => rst_n, 								-- Input TOP rst_n to rst_n in FIFO.
		
		-- * DATA * --
		push_data_i => data_i,						-- Incomming data to be pushed.
		pop_data_o => data_signal,					-- Outcoming data (from the FIFO) to the outside and to ParityChecker (that's why it is 
															-- connected to data_signal.
		
		-- * CONTROL * --
		push_valid_i => valid_i,					-- Request to push (but it pushes if FIFO is not complete (push_grant_o/=0)).
		pop_grant_i => pop_grant_i_signal,		-- Request to pop (but it pops if there is data available (pop_valid_o=1)).
		
		-- * STATUS * --
		push_grant_o => grant_o,					-- Push possibility status.
		pop_valid_o => pop_valid_o_signal		-- Pop possibility status.
	);
	
	TopParityCheck: entity work.ParityCheck PORT MAP(
		parity_data_i => data_signal,				-- Incomming data from the FIFO.
		parity_valid_o => valid_o,					-- Result from the ParityCheck (1 if parity is correct, 0 if not).
		parity_grant_o => pop_grant_i_signal,	-- Control to request data from ParityCheck to FIFO.
		parity_valid_i => pop_valid_o_signal,	-- Data available from the FIFO to pop, connected via a signal.
		parity_grant_i => grant_i					-- Control (from receiver) to request data to be poped.
	);

	data_o <= data_signal;							-- Output poped data.
end Behavioral;