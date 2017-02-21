----------------------------------------------------------------------------------
-- Author: Ariel Podlubne
-- Task: Design and verification of a FIFO with parity checker.
-- Reason: Excersie pre-interview (Universita di Bologna - Prof. Benini, Prof. Rossi)

-- Component: N-bits counter module's design.
-- Description: N-bits counter (falling edge) with CE.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use WORK.my_pkg.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity CounterFalling is
    Port ( clk : in  STD_LOGIC;
           ce : in  STD_LOGIC;
           count : out  STD_LOGIC_VECTOR (COUNTER_BITS-1 downto 0));
end CounterFalling;

architecture Behavioral of CounterFalling is

	signal counter : STD_LOGIC_VECTOR (COUNTER_BITS-1 downto 0) := (others=>'0');
	
begin
	process(clk, ce)
		begin
		if(clk'event and clk='0') then
			if(ce='1') then
				counter <= counter + 1;
			end if;
		end if;
	end process;
	count <= counter;

end Behavioral;

