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
		grant_i <= tmp;
	end process;

end Behavioral;

