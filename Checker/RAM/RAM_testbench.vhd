LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY RAM_testbench IS
END RAM_testbench;
 
ARCHITECTURE behavior OF RAM_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RAM
    PORT(
         clk : IN  std_logic;
         wr : IN  std_logic;
         data_i : IN  std_logic_vector(3 downto 0);
         address_i : IN  std_logic_vector(3 downto 0);
         rd : IN  std_logic;
         data_o : OUT  std_logic_vector(3 downto 0);
         address_o : IN  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal wr : std_logic := '0';
   signal data_i : std_logic_vector(3 downto 0) := (others => '0');
   signal address_i : std_logic_vector(3 downto 0) := (others => '0');
   signal rd : std_logic := '0';
   signal address_o : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal data_o : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RAM PORT MAP (
          clk => clk,
          wr => wr,
          data_i => data_i,
          address_i => address_i,
          rd => rd,
          data_o => data_o,
          address_o => address_o
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
		
		rd <= '0';
		wr <= '1';
		address_i <= "0000";
		data_i <= "1000";
      wait for clk_period; 
		address_i <= "0001";
		data_i <= "1001";
      wait for clk_period; 
		address_i <= "0010";
		data_i <= "1010";
      wait for clk_period; 
		
		wr <= '0';
		rd <= '1';
		address_o <= "0000";
		wait for clk_period;
		address_o <= "0001";
		wait for clk_period;
		address_o <= "0010";
		wait for clk_period; 
		rd <= '0';
		
      wait;
   end process;

END;
