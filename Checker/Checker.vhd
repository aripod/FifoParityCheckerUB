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
           loss_o 		: out  STD_LOGIC_VECTOR (7 downto 0);
			  test : out STD_LOGIC);		
end Checker;

architecture Behavioral of Checker is

	type datapushed is array (0 to PUSH_AMOUNT-1) of STD_LOGIC_VECTOR(FIFO_WIDTH-1 downto 0);
	signal pushed 	: datapushed;					-- Array to store pushed data.
	signal poped	: datapushed;					-- Array to store poped data.
	signal pushed_index : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');		-- Index (MAX value 255) to stored pushed data to compare with poped data for data loss.
	signal poped_index : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');		-- Index (MAX value 255) to stored poped data to compare with pushed data for data loss.
	signal result_passed : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');				-- MAX value 255. Thereofre, TEST_LENGTH has to be equal or less than that.
	signal result_dropped : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');				-- MAX value 255. Thereofre, TEST_LENGTH has to be equal or less than that.
	signal result_loss : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');				-- MAX value 255. Thereofre, TEST_LENGTH has to be equal or less than that.
	
	signal count_pass_en : std_logic :='0';
	signal count_drop_en : std_logic :='0';
	
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
	
end Behavioral;