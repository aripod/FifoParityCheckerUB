library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.my_pkg.ALL;

entity TestEnvironment_TOP is
    Port ( clk : in  STD_LOGIC;
           rst_n : in  STD_LOGIC;
			  ce : in  STD_LOGIC;
           stimulus : in  STD_LOGIC_VECTOR (STIMULUS_WIDTH-1 downto 0);
           Passed : out  STD_LOGIC_VECTOR (7 downto 0);
           Dropped : out  STD_LOGIC_VECTOR (7 downto 0);
           Loss : out  STD_LOGIC_VECTOR (7 downto 0);
			  Blink : out STD_LOGIC);
end TestEnvironment_TOP;

architecture Behavioral of TestEnvironment_TOP is

	signal top_data_i : STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
	signal top_data_o : STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
	signal top_valid_i : STD_LOGIC;
	signal top_valid_o : STD_LOGIC;
	signal top_grant_i: STD_LOGIC;
	signal top_grant_o: STD_LOGIC;
	signal top_traffic_type: STD_LOGIC_VECTOR(1 downto 0);

begin

	Inst_TrafficGenerator: entity work.TrafficGenerator PORT MAP(
		clk => clk,
		ce => ce,
		stimulus => stimulus,
		data_i => top_data_i,
		valid_i => top_valid_i,
		traffic_type => top_traffic_type,
		grant_o => top_grant_o
	);
	
	Inst_FifoParityCheckerUB_TOP: entity work.FifoParityCheckerUB_TOP PORT MAP(
		clk => clk,
		rst_n => rst_n,
		data_i => top_data_i,
		valid_i => top_valid_i,
		grant_o => top_grant_o,
		data_o => top_data_o,
		valid_o => top_valid_o,
		grant_i => top_grant_i
	);
	
	Inst_Grant_in_Generator: entity work.Grant_in_Generator PORT MAP(
		clk => clk,
		traffic_type => top_traffic_type,
		grant_i => top_grant_i
	);
	
	Inst_Checker: entity work.Checker PORT MAP(
		clk => clk,
		ce => ce,
		data_i => top_data_i,
		valid_i => top_valid_i,
		grant_o => top_grant_o,
		data_o => top_data_o,
		valid_o => top_valid_o,
		grant_i => top_grant_i,
		passed_o => Passed,
		dropped_o => Dropped,
		loss_o => Loss,
		test => Blink
	);

end Behavioral;

