----------------------------------------------------------------------------------
-- Author: Ariel Podlubne
-- Task: Design and verification of a FIFO with parity checker.
-- Reason: Excersie pre-interview (Universita di Bologna - Prof. Benini, Prof. Rossi)

-- Component: Grant_in Generator module design 
-- Description: Works as a decoder with traffic_type as its input. The "special feature" is that in one particular case (11), 
--					 it behaves as a frequency divider (by 2).
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Grant_in_Generator is
    Port ( clk 			: in  STD_LOGIC;
           traffic_type : in  STD_LOGIC_VECTOR (1 downto 0);
			  grant_i 		: out STD_LOGIC);
end Grant_in_Generator;

architecture Behavioral of Grant_in_Generator is
	signal tmp : STD_LOGIC:='0';
begin
	process(clk, traffic_type, tmp)
		begin
		case traffic_type is
			when "00" => 		-- FULL Condition.
				tmp <= '0';
			when "01" =>		-- EMTPY Condition.
				tmp <= '1';
			when "10" =>		-- Max BW Condition.
				tmp <= '1';
			when others =>		-- 50% BW Condition.
				if(clk'event and clk='1') then
					tmp <= not tmp;
				end if;
		end case;
	end process;
	grant_i <= tmp;
end Behavioral;