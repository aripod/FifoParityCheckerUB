----------------------------------------------------------------------------------
-- Author: Ariel Podlubne
-- Task: Design and verification of a FIFO with parity checker.
-- Reason: Excersie pre-interview (Universita di Bologna - Prof. Benini, Prof. Rossi)

-- Component: Checker module's design.
-- Description: Counts pass, drop and loss data.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
use WORK.my_pkg.ALL;

entity Checker is
    Port ( clk 		: in   STD_LOGIC;
			  ce  		: in   STD_LOGIC;
			  data_i 	: in   STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
			  valid_i 	: in   STD_LOGIC;
           grant_o 	: in   STD_LOGIC;
           data_o 	: in   STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0);
           valid_o 	: in   STD_LOGIC;
           grant_i 	: in   STD_LOGIC;
           passed_o 	: out  STD_LOGIC_VECTOR (7 downto 0);		-- MAX value 256
           dropped_o 	: out  STD_LOGIC_VECTOR (7 downto 0);		-- MAX value 256
           loss_o 		: out  STD_LOGIC_VECTOR (COUNTER_BITS-1 downto 0)
			  );		
end Checker;

architecture Behavioral of Checker is
	signal result_passed : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');				-- MAX value 255. Thereofre, TEST_LENGTH has to be equal or less than that.
	signal result_dropped : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');				-- MAX value 255. Thereofre, TEST_LENGTH has to be equal or less than that.
	--signal result_loss : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');				-- MAX value 255. Thereofre, TEST_LENGTH has to be equal or less than that.
	
	signal puc: std_logic := '0';		-- Push Condition
	signal poc: std_logic := '0';		-- Pop Condition
	signal new_pop: std_logic := '0';
	signal comp_o : std_logic := '0';
	
	signal Q_push_counter: STD_LOGIC_VECTOR(COUNTER_BITS-1 downto 0);
	signal Q_pop_counter: STD_LOGIC_VECTOR(COUNTER_BITS-1 downto 0);
	signal Q_comp_counter: STD_LOGIC_VECTOR(COUNTER_BITS-1 downto 0);
	signal signal_ram_data_o: STD_LOGIC_VECTOR(FIFO_WIDTH-1 downto 0);
	signal signal_past: STD_LOGIC_VECTOR(FIFO_WIDTH-1 downto 0) := (others=>'0');
	signal loss_counter_ce : STD_LOGIC := '0';	
begin
	-- ** Process to count passed and dropped data ** --
	process(clk, ce, grant_i, valid_o)
		begin
		if(clk'event and clk='0') then	-- As data is poped on rising edge, at falling edge data is already poped and available.
			if(ce='1') then					-- Only check if the test is being performed.
				if(grant_i='1') then			-- And if the receiver wants to read data.
					if(valid_o='1') then		-- Output from ParityCheck
						result_passed <= result_passed + 1;
					else
						result_dropped <= result_dropped + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
	passed_o <= result_passed;
	dropped_o <= result_dropped;
	
	puc <= valid_i and grant_o;	-- Push condition (for RAM and ce frompush counter)
	
	-- ** Generate signal for rd_en from the RAM and for ce from pop counter ** --
	process(clk, data_o)
	begin
		if(clk'event and clk='1') then
			if(signal_past/=data_o) then
				new_pop <= '1';
				signal_past <= data_o;
			else
				new_pop <= '0';
			end if;
		end if;
	end process;
	poc <= new_pop;
	
	PUSH_Counter: entity work.Counter PORT MAP(
		clk => clk,
		ce => puc,
		count => Q_push_counter
	);
	
	POP_Counter: entity work.CounterFalling PORT MAP(
		clk => clk,
		ce => poc,
		count => Q_pop_counter
	);
	
	loss_counter_ce <= ce and poc and not comp_o;
	LOSS_Counter: entity work.Counter PORT MAP(
		clk => clk,
		ce => loss_counter_ce,
		count => loss_o
	);
	
	Inst_RAM: entity work.RAM PORT MAP(
		clk => clk,
		wr => puc,
		data_i => data_i,
		address_i => Q_push_counter,
		rd => poc,
		data_o => signal_ram_data_o,
		address_o => Q_pop_counter
	);
	
	Inst_Comparator: entity work.Comparator PORT MAP(
		A => signal_ram_data_o,
		B => data_o,
		Q => comp_o
	);
end Behavioral;