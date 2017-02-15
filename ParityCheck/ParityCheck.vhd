----------------------------------------------------------------------------------
-- Author: Ariel Podlubne
-- Task: Design and verification of a FIFO.
-- Reason: Excersie pre-interview (Universita di Bologna - Prof. Benini, Prof. Rossi)

-- Component: Parity Checker
-- Description: Checks parity of the DATA coming from the FIFO.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_misc.all;
use WORK.my_pkg.ALL;

entity ParityCheck is
    Port ( parity_data_i : in  STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
           parity_valid_i : in  STD_LOGIC;
           parity_grant_o : out  STD_LOGIC;
           parity_valid_o : out  STD_LOGIC;
           parity_grant_i : in  STD_LOGIC
			  );
end ParityCheck;

architecture Behavioral of ParityCheck is
	signal data : std_logic_vector (DATA_WIDTH-1 downto 0);				-- This is used to extract the data WITHOUT its embedded parity.
	signal data_parity: std_logic;
	signal calculate_parity: std_logic;
	signal check_en: std_logic;
begin

	data_parity <= parity_data_i(0) when PARITY_BIT='0' else						-- LSB
						parity_data_i(FIFO_WIDTH-1);										-- MSB
	data <= parity_data_i(FIFO_WIDTH-1 downto 1) when PARITY_BIT='0' else
						parity_data_i(FIFO_WIDTH-2 downto 0);
		
	calculate_parity <= xor_reduce(data) when PARITY='0' else			-- ODD Paritity is obtained by XOR-ing all the bits in the data array.
							  not xor_reduce(data);  								-- EVEN Parity is the complementary. Therefore, the XNOR.
	check_en <= parity_valid_i and parity_grant_i;										-- Read value from FIFO when parity_grant_i (receiver) needs to validate data_o 
																							-- and there is data available on the FIFO.
	parity_grant_o <= check_en;
	parity_valid_o <= check_en and (not(calculate_parity xor data_parity));	-- valid_o is set to 1 only IF the parity included in the data 
																							-- and the calculate parity match.
end Behavioral;