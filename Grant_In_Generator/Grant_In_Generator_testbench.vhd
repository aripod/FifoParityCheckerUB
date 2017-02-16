LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Grant_In_Generator_testbench IS
END Grant_In_Generator_testbench;
 
ARCHITECTURE behavior OF Grant_In_Generator_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Grant_in_Generator
    PORT(
         clk : IN  std_logic;
         traffic_type : IN  std_logic_vector(1 downto 0);
         grant_i : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal traffic_type : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal grant_i : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Grant_in_Generator PORT MAP (
          clk => clk,
          traffic_type => traffic_type,
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
      wait for 100 ns;	

      traffic_type <= "00";
		wait for 4*clk_period;
		traffic_type <= "01";
		wait for 4*clk_period;
		traffic_type <= "10";
		wait for 4*clk_period;
		traffic_type <= "11";
		wait for 4*clk_period;

      wait;
   end process;

END;
