library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.my_pkg.ALL;

entity TrafficGenerator is
    Port ( clk 		: in  	STD_LOGIC;
			  ce 			: in  	STD_LOGIC;
			  stimulus 	: in  	STD_LOGIC_VECTOR (STIMULUS_WIDTH-1 downto 0);
           									-- ce will be used by the stimulus to tell when the test is complete (set to
																						-- 1 during the entire 'run' of the array.
           data_i 	: out 	STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0) :=(others=>'0');
           valid_i 	: out  	STD_LOGIC :='0';
			  traffic_type: out STD_LOGIC_VECTOR (1 downto 0) :=(others=>'0');
           grant_o 	: in  	STD_LOGIC);
end TrafficGenerator;

architecture Behavioral of TrafficGenerator is

begin
	process(clk, ce)
		begin
		if(clk'event and clk='1') then
			if(ce='1') then
				data_i <= stimulus(STIMULUS_WIDTH-1 downto 2);
				traffic_type <= stimulus(1 downto 0);
				
				if(stimulus(1 downto 0)="01" and grant_o='1') then		-- Only DON NOT push into the FIFO in "empty" traffic type.
					valid_i <='0';
				else
					valid_i <='1';
				end if;
			else
				valid_i <='0';
			end if;
		end if;
	end process;
end Behavioral;