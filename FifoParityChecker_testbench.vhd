LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY FifoParityChecker_testbench IS
END FifoParityChecker_testbench;
 
ARCHITECTURE behavior OF FifoParityChecker_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FifoParityCheckerUB_TOP
    PORT(
         clk : IN  std_logic;
         rst_n : IN  std_logic;
         data_i : IN  std_logic_vector(3 downto 0);
         valid_i : IN  std_logic;
         grant_o : OUT  std_logic;
         data_o : OUT  std_logic_vector(3 downto 0);
         valid_o : OUT  std_logic;
         grant_i : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst_n : std_logic := '0';
   signal data_i : std_logic_vector(3 downto 0) := (others => '0');
   signal valid_i : std_logic := '0';
   signal grant_i : std_logic := '0';

 	--Outputs
   signal grant_o : std_logic;
   signal data_o : std_logic_vector(3 downto 0);
   signal valid_o : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FifoParityCheckerUB_TOP PORT MAP (
          clk => clk,
          rst_n => rst_n,
          data_i => data_i,
          valid_i => valid_i,
          grant_o => grant_o,
          data_o => data_o,
          valid_o => valid_o,
          grant_i => grant_i
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

      -- insert stimulus here 

      wait;
   end process;

END;
