----------------------------------------------------------------------------------
-- Author: Ariel Podlubne
-- Task: Design and verification of a FIFO with parity checker.
-- Reason: Excersie pre-interview (Universita di Bologna - Prof. Benini, Prof. Rossi)

-- Component: Fifo
-- Description: Synchronous FIFO with the following parameters:
-- 	DATA_WIDTH = WIDTH+1 where 1 is the parity bit.
--		FIFO_DEPTH (depth >=2)
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.my_pkg.all;

entity Fifo is		
   Port(
		clk				: in  STD_LOGIC;
      rst_n 			: in  STD_LOGIC;
      push_data_i 	: in  STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
      push_valid_i 	: in  STD_LOGIC;
      push_grant_o 	: out  STD_LOGIC;
      pop_data_o 		: out  STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
      pop_valid_o 	: out  STD_LOGIC;
      pop_grant_i 	: in  STD_LOGIC
		);
end Fifo;

architecture Behavioral of Fifo is

begin


end Behavioral;