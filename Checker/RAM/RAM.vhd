----------------------------------------------------------------------------------
-- Author: Ariel Podlubne
-- Task: Design and verification of a FIFO with parity checker.
-- Reason: Excersie pre-interview (Universita di Bologna - Prof. Benini, Prof. Rossi)

-- Component: RAM module's design.
-- Description: Synchronous RAM with input and output ports that can be written to and read from at the same time.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL; 
use WORK.my_pkg.ALL;

entity RAM is
    Port ( clk : in  STD_LOGIC;
           wr : in  STD_LOGIC;
           data_i : in  STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
           address_i : in  STD_LOGIC_VECTOR (RAM_BITS-1 downto 0);
           rd : in  STD_LOGIC;
           data_o : out  STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
           address_o : in  STD_LOGIC_VECTOR (RAM_BITS-1 downto 0));
end RAM;

architecture Behavioral of RAM is
	type ram_datatype is array(0 to 2**RAM_BITS-1) of std_logic_vector(FIFO_WIDTH-1 downto 0);
	signal ram : ram_datatype := (others => (others => '0'));
	signal output : std_logic_vector(FIFO_WIDTH-1 downto 0) := (others =>'0');
begin

	process(clk) is
	begin
	  if(clk'event and clk='1') then
		 if(wr='1') then -- Write to RAM
			ram(to_integer(unsigned(address_i))) <= data_i;
		 end if;
	 end if;
	 if(clk'event and clk='0') then
		 if(rd='1') then -- Read from RAM
			output <= ram(to_integer(unsigned(address_o)));      
		 end if;
	  end if;
	end process;
	data_o <= output;
end Behavioral;