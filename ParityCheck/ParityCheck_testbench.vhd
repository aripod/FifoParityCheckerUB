LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ParityChecker_testbench IS
END ParityChecker_testbench;
 
ARCHITECTURE behavior OF ParityChecker_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ParityChecker
    PORT(
         data_i : IN  std_logic_vector(3 downto 0);
         pop_valid_i : IN  std_logic;
         pop_grant_o : OUT  std_logic;
         valid_o : OUT  std_logic;
         grant_i : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal data_i : std_logic_vector(3 downto 0) := (others => '0');
   signal pop_valid_i : std_logic := '0';
   signal grant_i : std_logic := '0';

 	--Outputs
   signal pop_grant_o : std_logic;
   signal valid_o : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ParityChecker PORT MAP (
          data_i => data_i,
          pop_valid_i => pop_valid_i,
          pop_grant_o => pop_grant_o,
          valid_o => valid_o,
          grant_i => grant_i
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 10 ns.
      wait for 10 ns;	

		pop_valid_i <= '1';	-- There is data available in the FIFO to POP.
		grant_i <= '1';		-- The reciever is ready to get data.
      
		data_i <= "0101";
		wait for 10 ns;
		data_i <= "1100";
		wait for 10 ns;
		data_i <= "0100";
		wait for 10 ns;
		data_i <= "1101";

      wait;
   end process;

END;
