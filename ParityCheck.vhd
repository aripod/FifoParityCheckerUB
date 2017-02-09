----------------------------------------------------------------------------------
-- Author: Ariel Podlubne
-- Task: Design and verification of a FIFO with parity checker.
-- Reason: Excersie pre-interview (Universita di Bologna - Prof. Benini, Prof. Rossi)

-- Component: Parity Checker
-- Description: Checks the correctness of incoming data (data_i) with the following parameters:
-- 	Parity: EVEN or ODD
--		Parity BIT: MSB or LSB
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.my_pkg.all;

entity ParityCheck is		
    Port(
		parity_data_i		: in  STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
      parity_valid_i 	: in  STD_LOGIC;
      parity_grant_o 	: out  STD_LOGIC;
      parity_valid_o 	: out  STD_LOGIC;
      parity_grant_i 	: in  STD_LOGIC
		);
end ParityCheck;

architecture Behavioral of ParityCheck is

begin


end Behavioral;

