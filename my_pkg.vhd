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

use IEEE.math_real."ceil";
use IEEE.math_real."log2";

package my_pkg is
		-- ** This should be used if math_real library available. Otherwise comment lines 24 and 25. Uncomment line 27 ** --
		constant SLOTS : positive := 4;				-- This values has to be a power of two (2, 4, 8, 16, etc).
		constant FIFO_DEPTH	: positive := integer(ceil(log2(real(SLOTS))));
		
		--constant FIFO_DEPTH	: positive := 2;	-- The DEPTH of the FIFO will be 2^FIFO_DEPTH. In this case, 4 slots.
		constant DATA_WIDTH  : positive := 3;
		constant FIFO_WIDTH  : positive := DATA_WIDTH+1; 	--DATAWIDTH=WIDTH+1bitParity
		constant PARITY		: bit		  := '0';	-- EVEN or ODD.
		constant PARITY_BIT	: bit		  := '0';	-- LSB or MSB.
end my_pkg;