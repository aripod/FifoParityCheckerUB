----------------------------------------------------------------------------------
-- Author: Ariel Podlubne
-- Task: Design and verification of a FIFO with parity checker.
-- Reason: Excersie pre-interview (Universita di Bologna - Prof. Benini, Prof. Rossi)

-- Component: Comparator module's design.
-- Description: Compares its inputs and ouputs 1 if they are equal.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.my_pkg.ALL;

entity Comparator is
    Port ( A : in  STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
           B : in  STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
           Q : out  STD_LOGIC);
end Comparator;

architecture Behavioral of Comparator is

begin

	Q <= '1' when A=B else '0';

end Behavioral;

