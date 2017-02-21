----------------------------------------------------------------------------------
-- Author: Ariel Podlubne
-- Task: Design and verification of a FIFO with parity checker.
-- Reason: Excersie pre-interview (Universita di Bologna - Prof. Benini, Prof. Rossi)

-- Component: Fifo and Parity Check Top module's testbench.
-- Description: Instantiation of FIFO and ParityCheck.
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
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
	--signal passed : std_logic_vector(3 downto 0);

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
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 21 ns. (It is 21 ns so the changing state of the signals (stimulus) do not match with the
		-- changing state (0->1 or 1->0) of the clock.
      wait for 21 ns;	
		
		-- ** Mimics example from exercise ** --
        rst_n <= '1';
		grant_i <= '0';
		wait for clk_period;
		-- Cycle 2
		valid_i <= '1';
		data_i <= "1001";
		wait for clk_period;
		-- Cycle 3
		data_i <= "1010";
		wait for clk_period;
		-- Cycle 4
		data_i <= "1011";
		wait for clk_period;
		-- Cycle 5
		data_i <= "1100";
		wait for clk_period;
		-- Cycle 6
		data_i <= "1101";
		wait for clk_period/4;
		grant_i <= '1';
		wait for clk_period/4;
		wait for clk_period/2;
		-- Cycle 7
		wait for clk_period;
		-- Cycle 8
		valid_i <= '0';
		grant_i <= '0';
		data_i <= "1000";
		wait for clk_period;
		-- Cycle 9
		wait for clk_period/4;
		grant_i <= '1';

      wait;
   end process;
END;