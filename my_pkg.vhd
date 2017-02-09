----------------------------------------------------------------------------------
-- Author: Ariel Podlubne
-- Task: Design and verification of a FIFO with parity checker.
-- Reason: Excersie pre-interview (Universita di Bologna - Prof. Benini, Prof. Rossi)

-- Component: Custom package.
-- Description: Includes all the constants values for the customisable parameters.
		-- FIFO_DEPTH: Depth of the FIFO.
		-- DATA_WIDTH: Data width.
		-- FIFO_WIDTH: Data width with 1 parity bit included.
		-- Parity: EVEN (1) or ODD (0).
		-- Parity BIT: MSB (1) or LSB (0).
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package my_pkg is
		constant FIFO_DEPTH	: positive := 4;
		constant DATA_WIDTH  : positive := 2;
		constant FIFO_WIDTH  : positive := DATA_WIDTH+1; 	--DATAWIDTH=WIDTH+1bitParity
		constant PARITY		: bit		  := '0';
		constant PARITY_BIT	: bit		  := '0';
end my_pkg;