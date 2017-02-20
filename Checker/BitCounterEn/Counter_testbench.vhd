LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Counter_testbench IS
END Counter_testbench;
 
ARCHITECTURE behavior OF Counter_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Counter
    PORT(
         clk : IN  std_logic;
         ce : IN  std_logic;
         count : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal ce : std_logic := '0';

 	--Outputs
   signal count : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Counter PORT MAP (
          clk => clk,
          ce => ce,
          count => count
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
      wait for 5*clk_period;
		ce <= '0';

      wait;
   end process;

END;
