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
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; 
use WORK.my_pkg.ALL;

entity Fifo is		
   Port(
		clk				: in  STD_LOGIC;
      rst_n 			: in  STD_LOGIC;
		-- DATA 
      push_data_i 	: in  STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);		-- Data IN.
		pop_data_o 		: out STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);		-- Data out.
		-- CONTROL
      push_valid_i 	: in  STD_LOGIC;												-- 1 to write push_data_i into the FIFO.
      pop_grant_i 	: in  STD_LOGIC;												-- 1 to read from the FIFO.
		-- STATUS
		push_grant_o 	: out STD_LOGIC;												-- 0 when full. To write push_grant_o=1 and push_valid_i=1.
		pop_valid_o 	: out STD_LOGIC												-- 1 where there is data available in the FIFO.
		);
end Fifo;

architecture Behavioral of Fifo is
	type reg_type is array (FIFO_DEPTH-1 downto 0) of STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
	signal array_reg : reg_type;
	signal write_ptr_reg, write_ptr_next, write_ptr_succ : STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
	signal read_ptr_read, read_ptr_next, read_ptr_succ : STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
	signal full_reg, empty_reg, full_next, empty_next : STD_LOGIC;
	signal operation : STD_LOGIC_VECTOR (1 downto 0);
	signal wr_en: STD_LOGIC;
	signal write_signal : STD_LOGIC;
	
	begin
		process(clk, rst_n)
		begin
			if(rst_n='0') then
				array_reg <= (others=>(others=>'0'));	-- Sets the entire array_reg to 0.
			elsif (clk'event and clk='1') then 		-- Rising edge of the clock.
				if (wr_en='1') then
					array_reg(to_integer(unsigned(write_ptr_reg))) <= push_data_i;	-- It expects an intiger as the position in the array. Therefore the 'to_intiger' function).
				end if;
			end if;
		end process;
		
		write_signal <= push_valid_i;
		wr_en <= push_valid_i and write_signal;
end Behavioral;