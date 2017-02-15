--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:59:34 02/15/2017
-- Design Name:   
-- Module Name:   /home/ariel/Documents/VHDL/FifoParityCheckerUB/ParityCheck/ParityCheck_testbench.vhd
-- Project Name:  ParityCheck
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ParityCheck
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ParityCheck_testbench IS
END ParityCheck_testbench;
 
ARCHITECTURE behavior OF ParityCheck_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ParityCheck
    PORT(
         parity_data_i : IN  std_logic_vector(3 downto 0);
         parity_valid_i : IN  std_logic;
         parity_grant_o : OUT  std_logic;
         parity_valid_o : OUT  std_logic;
         parity_grant_i : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal parity_data_i : std_logic_vector(3 downto 0) := (others => '0');
   signal parity_valid_i : std_logic := '0';
   signal parity_grant_i : std_logic := '0';

 	--Outputs
   signal parity_grant_o : std_logic;
   signal parity_valid_o : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ParityCheck PORT MAP (
          parity_data_i => parity_data_i,
          parity_valid_i => parity_valid_i,
          parity_grant_o => parity_grant_o,
          parity_valid_o => parity_valid_o,
          parity_grant_i => parity_grant_i
        );
 
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;	

		parity_valid_i <= '1';		-- There is data available in the FIFO to POP.
		parity_grant_i <= '1';		-- The reciever is ready to get data.
      
		parity_data_i <= "0101";
		wait for 10 ns;
		parity_data_i <= "1100";
		wait for 10 ns;
		parity_data_i <= "0100";
		wait for 10 ns;
		parity_data_i <= "1101";

      wait;
   end process;

END;
