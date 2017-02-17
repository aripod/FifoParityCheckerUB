----------------------------------------------------------------------------------
-- Author: Ariel Podlubne
-- Task: Design and verification of a FIFO.
-- Reason: Excersie pre-interview (Universita di Bologna - Prof. Benini, Prof. Rossi)

-- Component: Fifo
-- Description: Synchronous FIFO with the following parameters:
-- 	DATA_WIDTH = WIDTH+1 where 1 is the parity bit.
--		FIFO_DEPTH (depth >=2)
--		Parity: EVEN (1) or ODD (0).
-- 	Parity BIT: MSB (1) or LSB (0).
--	This parameters can be changed in my_pkg.vhd file.
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
	type reg_type is array (2**FIFO_DEPTH-1 downto 0) of STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);			-- FIFO_WIDTH x FIFO_DEPTH 2D-array.
	signal array_reg : reg_type;																									-- FIFO itself. Data is stored here.
	signal write_ptr_reg, write_ptr_next, write_ptr_succ : STD_LOGIC_VECTOR (FIFO_DEPTH-1 downto 0);		-- Write control registers.
	signal read_ptr_reg, read_ptr_next, read_ptr_succ : STD_LOGIC_VECTOR (FIFO_DEPTH-1 downto 0);			-- Read control registers.
	signal full_reg, full_next  : STD_LOGIC := '0';																			-- Status registers
	signal empty_reg, empty_next : STD_LOGIC := '1';																		-- Status registers
	signal operation : STD_LOGIC_VECTOR (1 downto 0) := "00";															-- Operation 2 bit array 
	signal wr_en: STD_LOGIC;																										-- Write possible register.
	
	begin
		-- ** PUSH & POP PORTS (data) ** --
		process(clk, rst_n)
		begin
			if(rst_n='0') then
				array_reg <= (others=>(others=>'0'));		-- Sets the entire array_reg (2D-array) to 0.
				write_ptr_reg <= (others=>'0');				-- Resets all write registers (to 0).
				read_ptr_reg <= (others=>'0');				-- Resets all read registers (to 0).
				full_reg <= '0';									-- Full register is set to 0 as FIFO is not FULL.
				empty_reg <= '1';									-- Empty register is set to 1 as FIFO is empty.
			elsif (clk'event and clk='1') then 												-- Rising edge of the clock.
				if (wr_en='1') then
					array_reg(to_integer(unsigned(write_ptr_reg))) <= push_data_i;	-- It writes the incoming data (push_data_i) to the corresponding position in the FIFO.
																										-- It expects an intiger as the position in the array. Therefore the 'to_intiger' function.										
				end if;
				write_ptr_reg <= write_ptr_next;	-- Current write position becomes the next one on clock event.
				read_ptr_reg <= read_ptr_next;	-- Current read position becomes the next one on clock event.
				full_reg <= full_next;				-- Current full position becomes the next one on clock event.
				empty_reg <= empty_next;			-- Current empty position becomes the next one on clock event.
			end if;
		end process;
		
		process(clk, rst_n)
		begin
			if(rst_n='0') then
				array_reg <= (others=>(others=>'0'));		-- Sets the entire array_reg (2D-array) to 0.
				write_ptr_reg <= (others=>'0');				-- Resets all write registers (to 0).
				read_ptr_reg <= (others=>'0');				-- Resets all read registers (to 0).
				full_reg <= '0';									-- Full register is set to 0 as FIFO is not FULL.
				empty_reg <= '1';									-- Empty register is set to 1 as FIFO is empty.
			elsif (clk'event and clk='1') then 												-- Rising edge of the clock.
				if (wr_en='1') then
					array_reg(to_integer(unsigned(write_ptr_reg))) <= push_data_i;	-- It writes the incoming data (push_data_i) to the corresponding position in the FIFO.
																										-- It expects an intiger as the position in the array. Therefore the 'to_intiger' function.										
				end if;
				write_ptr_reg <= write_ptr_next;	-- Current write position becomes the next one on clock event.
				read_ptr_reg <= read_ptr_next;	-- Current read position becomes the next one on clock event.
				full_reg <= full_next;				-- Current full position becomes the next one on clock event.
				empty_reg <= empty_next;			-- Current empty position becomes the next one on clock event.
			end if;
		end process;
		
		-- Input port:
		wr_en <= push_valid_i and (not full_reg);	-- If FIFO is NOT full it is possible to write.
		-- Output port:
		-- It is done differently from the input port as the output data ('first-in', pointed by read_ptr_reg)has to be available all the time.
		pop_data_o <= array_reg(to_integer(unsigned(read_ptr_reg)));

		-- Successive values to read and write when requested.
		write_ptr_succ <= STD_LOGIC_VECTOR(unsigned(write_ptr_reg)+1);
		read_ptr_succ <= STD_LOGIC_VECTOR(unsigned(read_ptr_reg)+1);
		
		-- ** Events and register control  ** --
		operation <= (((not full_reg) and push_valid_i) & ((not empty_reg) and pop_grant_i));	-- Concatenates the two control inputs for the 'case, when' statement.
		process(write_ptr_reg, write_ptr_succ, read_ptr_reg, read_ptr_succ,
				  operation, full_reg, empty_reg)
		begin
			write_ptr_next <= write_ptr_reg;		-- This four lines are to assure that the current state does not
			read_ptr_next <= read_ptr_reg;		-- change in case none of the case-when statements happen.
			full_next <= full_reg;
			empty_next <= empty_reg;
			case operation is
				when "00" =>											-- Not write (push) or read (pop).
				when "01" =>											-- Read.
					if(empty_reg /= '1') then						-- If FIFO is NOT empty, it can be read.
						read_ptr_next <= read_ptr_succ;			-- It points to the successive position to read.
						full_next <= '0';								-- As one position is read, FIFO will NOT be full.
						if(read_ptr_succ=write_ptr_reg) then	-- Read 'reached' write. So the FIFO will be EMPTY.
							empty_next <= '1';
						end if;
					end if;
				when "10" => 											-- Write.
					if(full_reg /='1') then							-- If FIFO is NOT full, it can be written.
						write_ptr_next <= write_ptr_succ;
						empty_next <= '0';							-- The FIFO is written, so it will NOT be empty.
						if(write_ptr_succ=read_ptr_reg) then	-- Write 'reached' read, so the FIFO will be full.
							full_next <= '1';
						end if;
					end if;
				when others => 										-- Write and Read at the same time.
					read_ptr_next <= read_ptr_succ;
					write_ptr_next <= write_ptr_succ;
			end case;
		end process;
		
		-- Output STATUS
		push_grant_o <= not full_reg;
		pop_valid_o <= not empty_reg;
end Behavioral;