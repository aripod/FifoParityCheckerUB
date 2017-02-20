LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Comparator_testbench IS
END Comparator_testbench;
 
ARCHITECTURE behavior OF Comparator_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Comparator
    PORT(
         A : IN  std_logic_vector(3 downto 0);
         B : IN  std_logic_vector(3 downto 0);
         Q : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(3 downto 0) := (others => '0');
   signal B : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal Q : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Comparator PORT MAP (
          A => A,
          B => B,
          Q => Q
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 20 ns;

		A <= "1001";
		B <= "1001";
		wait for 20 ns;
		A <= "1101";
		B <= "1001";
		
      wait;
   end process;

END;
