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
--		-- ** This should be used if math_real library available. Otherwise comment lines 24 and 25. Uncomment line 27 ** --
--		constant SLOTS : positive := 4;				-- This values has to be a power of two (2, 4, 8, 16, etc).
--		constant FIFO_DEPTH	: positive := integer(ceil(log2(real(SLOTS))));
		
		constant FIFO_DEPTH	: positive := 2;					-- The DEPTH of the FIFO will be 2^FIFO_DEPTH. In this case, 4 slots.
		constant DATA_WIDTH  : positive := 3;
		constant FIFO_WIDTH  : positive := DATA_WIDTH+1; 	--DATAWIDTH=WIDTH+1bitParity
		constant PARITY		: bit		  := '0';				-- EVEN or ODD.
		constant PARITY_BIT	: bit		  := '0';				-- LSB or MSB.
		
		-- ** Parameters for the Test Environment ** --
		constant TEST_LENGTH 		: positive := 16;			-- Number of steps in the test.
		constant STIMULUS_WIDTH	: positive := (FIFO_WIDTH+2);	-- Width of the stimulus (with valid_i included (Data+1 bit)).
		type datatraffic is array (0 to TEST_LENGTH-1) of STD_LOGIC_VECTOR(STIMULUS_WIDTH-1 downto 0);
		-- * Test Vector * --
		-- Traffic: |Data(3 bits)|DataParity(1 bit)|TrafficType(2 bit)|
		-- TrafficType: 00: FULL | 01: EMPTY | 10: Max BW | 11: BW 50%
		signal traffic : datatraffic:= ("100100", "101000", "101100", "110000", 	-- FULL. Data is different to test ParityCheck.
											     "000001", "000001", "000001", "000001",		-- EMPTY. Data does not matter as it is poped, not pushed.
											     "100110", "101010", "101110", "110010", 	-- Full BW. Data is different to test ParityCheck.
											     "100111", "101011", "101111", "110011");	-- 50% BW. 
		
end my_pkg;