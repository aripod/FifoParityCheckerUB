LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Checker_testbenchDEBUG IS
END Checker_testbenchDEBUG;
 
ARCHITECTURE behavior OF Checker_testbenchDEBUG IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Checker
    PORT(
         clk : IN  std_logic;
         ce : IN  std_logic;
         data_i : IN  std_logic_vector(3 downto 0);
         valid_i : IN  std_logic;
         grant_o : IN  std_logic;
         data_o : IN  std_logic_vector(3 downto 0);
         valid_o : IN  std_logic;
         grant_i : IN  std_logic;
         passed_o : OUT  std_logic_vector(7 downto 0);
         dropped_o : OUT  std_logic_vector(7 downto 0);
         loss_o : OUT  std_logic_vector(3 downto 0);
         port_puc : OUT  std_logic;
         port_poc : OUT  std_logic;
         port_push_counter : OUT  std_logic_vector(3 downto 0);
         port_pop_counter : OUT  std_logic_vector(3 downto 0);
         port_signal_ram_data_o : OUT  std_logic_vector(3 downto 0);
         port_comp : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal ce : std_logic := '0';
   signal data_i : std_logic_vector(3 downto 0) := (others => '0');
   signal valid_i : std_logic := '0';
   signal grant_o : std_logic := '0';
   signal data_o : std_logic_vector(3 downto 0) := (others => '0');
   signal valid_o : std_logic := '0';
   signal grant_i : std_logic := '0';

 	--Outputs
   signal passed_o : std_logic_vector(7 downto 0);
   signal dropped_o : std_logic_vector(7 downto 0);
   signal loss_o : std_logic_vector(3 downto 0);
   signal port_puc : std_logic;
   signal port_poc : std_logic;
   signal port_push_counter : std_logic_vector(3 downto 0);
   signal port_pop_counter : std_logic_vector(3 downto 0);
   signal port_signal_ram_data_o : std_logic_vector(3 downto 0);
   signal port_comp : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Checker PORT MAP (
          clk => clk,
          ce => ce,
          data_i => data_i,
          valid_i => valid_i,
          grant_o => grant_o,
          data_o => data_o,
          valid_o => valid_o,
          grant_i => grant_i,
          passed_o => passed_o,
          dropped_o => dropped_o,
          loss_o => loss_o,
          port_puc => port_puc,
          port_poc => port_poc,
          port_push_counter => port_push_counter,
          port_pop_counter => port_pop_counter,
          port_signal_ram_data_o => port_signal_ram_data_o,
          port_comp => port_comp
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
       grant_o <= '1';
		wait for 21 ns;	
 
		ce <= '1';

	-- ** Mimics simulation from TOP design ** --
		data_o <= "0000";
		data_i <= "0000";
		wait for 10 ns;
		data_i <= "1001";
		valid_i <= '1';
		wait for 9 ns;
		data_o <= "1001";
		wait for 1 ns;
		data_i <= "1010";
		wait for 10 ns;
		data_i <= "1011";
		wait for 10 ns;
		data_i <= "1100";
		wait for 9 ns;
		grant_o <= '0';
		wait for 1 ns;
		data_i <= "1101";
		wait for 2.5 ns;
		grant_i <= '1';
		valid_o <= '1';
		wait for 6.5 ns;
		data_o <= "1010";
		grant_o <= '1';
		wait for 10 ns;
		data_o <= "1011";
		valid_o <= '0';
		wait for 1 ns;
		data_i <= "1000";
		valid_i <= '0';
		grant_i <= '0';
		wait for 12.5 ns;
		grant_i <= '1';
		wait for 6.5 ns;
		valid_o <= '1';
		data_o <= "1100";
		wait for 10 ns;
		valid_o <= '0';
		data_o <= "1101";
		wait for 10 ns;
		data_o <= "1010";
		
		ce <= '0';

      wait;
   end process;

END;
