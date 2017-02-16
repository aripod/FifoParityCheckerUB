LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE WORK.my_pkg.ALL;

ENTITY TrafficGenerator_testbench IS
END TrafficGenerator_testbench;
 
ARCHITECTURE behavior OF TrafficGenerator_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TrafficGenerator
    PORT(
         clk : IN  std_logic;
         ce : IN  std_logic;
         stimulus : IN  std_logic_vector(5 downto 0);
         data_i : OUT  std_logic_vector(3 downto 0);
         valid_i : OUT  std_logic;
         traffic_type : OUT  std_logic_vector(1 downto 0);
         grant_o : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal ce : std_logic := '0';
   signal stimulus : std_logic_vector(5 downto 0) := (others => '0');
   signal grant_o : std_logic := '0';

 	--Outputs
   signal data_i : std_logic_vector(3 downto 0);
   signal valid_i : std_logic;
   signal traffic_type : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TrafficGenerator PORT MAP (
          clk => clk,
          ce => ce,
          stimulus => stimulus,
          data_i => data_i,
          valid_i => valid_i,
          traffic_type => traffic_type,
          grant_o => grant_o
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 21 ns;

      ce <= '1';
		for i in 0 to TEST_LENGTH-1 loop
			stimulus <= traffic(i);
			wait for clk_period;
		end loop;
		ce <= '0';
		
      wait;
   end process;

END;
