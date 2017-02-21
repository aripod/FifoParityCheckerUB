LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE WORK.my_pkg.ALL;
 
ENTITY TestEnvironment_TOP_testbench IS
END TestEnvironment_TOP_testbench;
 
ARCHITECTURE behavior OF TestEnvironment_TOP_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TestEnvironment_TOP
    PORT(
         clk : IN  std_logic;
         rst_n : IN  std_logic;
         ce : IN  std_logic;
         stimulus : IN  std_logic_vector(5 downto 0);
         Passed : OUT  std_logic_vector(7 downto 0);
         Dropped : OUT  std_logic_vector(7 downto 0);
         Loss : OUT  std_logic_vector(3 downto 0);
         port_data_o : OUT  std_logic_vector(3 downto 0);
         port_data_i : OUT  std_logic_vector(3 downto 0);
         port_grant_i : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst_n : std_logic := '0';
   signal ce : std_logic := '0';
   signal stimulus : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal Passed : std_logic_vector(7 downto 0);
   signal Dropped : std_logic_vector(7 downto 0);
   signal Loss : std_logic_vector(3 downto 0);
   signal port_data_o : std_logic_vector(3 downto 0);
   signal port_data_i : std_logic_vector(3 downto 0);
   signal port_grant_i : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TestEnvironment_TOP PORT MAP (
          clk => clk,
          rst_n => rst_n,
          ce => ce,
          stimulus => stimulus,
          Passed => Passed,
          Dropped => Dropped,
          Loss => Loss,
          port_data_o => port_data_o,
          port_data_i => port_data_i,
          port_grant_i => port_grant_i
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 21 ns;	

		rst_n <= '1';
		wait for clk_period;

      ce <= '1';
		for i in 0 to TEST_LENGTH-1 loop
			stimulus <= traffic(i);
			wait for clk_period;
		end loop;
		ce <= '0';

      wait;
   end process;

END;
