----------------------------------------------------------------------------------
-- Author: Ariel Podlubne
-- Task: Design and verification of a FIFO.
-- Reason: Excersie pre-interview (Universita di Bologna - Prof. Benini, Prof. Rossi)

-- Component: Fifo's testbench
-- Description: It mimics the input signals from the example.
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Fifo_testbench IS
END Fifo_testbench;
 
ARCHITECTURE behavior OF Fifo_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Fifo
    PORT(
         clk : IN  std_logic;
         rst_n : IN  std_logic;
         push_data_i : IN  std_logic_vector(3 downto 0);
         pop_data_o : OUT  std_logic_vector(3 downto 0);
         push_valid_i : IN  std_logic;
         pop_grant_i : IN  std_logic;
         push_grant_o : OUT  std_logic;
         pop_valid_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst_n : std_logic := '0';
   signal push_data_i : std_logic_vector(3 downto 0) := (others => '0');
   signal push_valid_i : std_logic := '0';
   signal pop_grant_i : std_logic := '0';

 	--Outputs
   signal pop_data_o : std_logic_vector(3 downto 0);
   signal push_grant_o : std_logic;
   signal pop_valid_o : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Fifo PORT MAP (
          clk => clk,
          rst_n => rst_n,
          push_data_i => push_data_i,
          pop_data_o => pop_data_o,
          push_valid_i => push_valid_i,
          pop_grant_i => pop_grant_i,
          push_grant_o => push_grant_o,
          pop_valid_o => pop_valid_o
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
      -- hold reset state for 11 ns when the clk changes its state, it does not match with the stimulus.
      wait for 11 ns;	
		rst_n <= '1';
		wait for clk_period;

		-- ** Mimics example from exercise ** --
		pop_grant_i <= '0';
		--wait for clk_period;
		-- Cycle 2
		push_valid_i <= '1';
		push_data_i <= "1001";
		wait for clk_period;
		-- Cycle 3
		push_data_i <= "1010";
		wait for clk_period;
		-- Cycle 4
		push_data_i <= "1011";
		wait for clk_period;
		-- Cycle 5
		push_data_i <= "1100";
		wait for clk_period;
		-- Cycle 6
		push_data_i <= "1101";
		wait for clk_period/4;
		pop_grant_i <= '1';
		wait for clk_period/4;
		wait for clk_period/2;
		-- Cycle 7
		wait for clk_period;
		-- Cycle 8
		push_valid_i <= '0';
		pop_grant_i <= '0';
		push_data_i <= "1000";
		wait for clk_period;
		-- Cycle 9
		wait for clk_period/4;
		pop_grant_i <= '1';
		
		
      wait;
   end process;

END;
