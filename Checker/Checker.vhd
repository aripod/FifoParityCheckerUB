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
	signal saved: std_logic := '0';
	
	signal count_pass_en : std_logic :='0';
	signal count_drop_en : std_logic :='0';
	
	signal pass : STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0) :=(others=>'0');
	signal present : STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0) :=(others=>'0');
	signal aux : STD_LOGIC_VECTOR (FIFO_WIDTH-1 downto 0) :=(others=>'0');
	
	signal stest: std_logic :='0';
	
begin

	
	process(clk, grant_i, valid_o)
		begin
		if(clk'event and clk='0') then
			stest <= not stest;
			if(grant_i='1') then
				if(valid_o='1') then
					result_passed <= result_passed + 1;
				else
					result_dropped <= result_dropped + 1;
				end if;
			end if;
		end if;
	end process;
	test <= stest;
	passed_o <= result_passed;
	dropped_o <= result_dropped;
	
--	process(clk, ce)		-- Process to store PUSHED and POPED data and to analyze lost data.
--		begin
--		if(clk'event and clk='1') then
--			if(ce='1') then			-- Collects data
--				if(valid_i='1' and grant_o/='1') then	-- If something wants to be pushed (valid_i=1) and the fifo can take it (grant_o/=0).
--					if(to_integer(unsigned(pushed_index)) < TEST_LENGTH) then
--						pushed(to_integer(unsigned(pushed_index))) <= data_i;
--						pushed_index <= pushed_index + 1;
--					end if;
--				end if;
--				
--				if(grant_i='1') then				-- If it is set to pop (It cannot check for valid_o as it might be 0 due to ParityCheck).
--					if(to_integer(unsigned(poped_index)) < TEST_LENGTH) then
--						pushed(to_integer(unsigned(poped_index))) <= data_o;
--						poped_index <= poped_index + 1;
--					end if;
--					if(valid_o='1') then
--						result_passed <= result_passed + 1;
--					else
--						result_dropped <= result_dropped + 1;
--					end if;
--				end if;
--			else							-- Analysis data
--				for i in 0 to TEST_LENGTH-1 loop
--					if(pushed(to_integer(unsigned(pushed_index))) /= pushed(to_integer(unsigned(poped_index)))) then
--						result_dropped <= result_dropped + 1;
--					end if;
--				end loop;
--				pushed_index <= (others=>'0');
--				poped_index <= (others=>'0');
--			end if;
--		end if;
--	end process;
--	
--	passed_o <= result_passed;
--	dropped_o <= result_dropped;
--	loss_o <= result_loss;
	
--	process(ce, data_i)		-- Process to store data that is PUSHED.
--		begin
--		if(ce='1') then
--			if(saved='0') then
--				saved <= '1';
--			else
--				if(to_integer(unsigned(pushed_index)) < TEST_LENGTH) then
--					if(valid_i='1' and grant_o/='0') then
--						pushed(to_integer(unsigned(pushed_index))) <= data_i;
--						pushed_index <= pushed_index + 1;
--					end if;
--				end if;
--			end if;
--		end if;
--	end process;
--	


	
--	process(ce, data_o)		-- Process to store data that is POPED.
--		begin
--		if(ce='1') then
--			if(saved='0') then
--				saved <= '1';
--			else
--				if(to_integer(unsigned(poped_index)) < TEST_LENGTH) then
--					if(grant_i='1') then
--						poped(to_integer(unsigned(poped_index))) <= data_o;
--						if(poped(to_integer(unsigned(poped_index))) /= pushed(to_integer(unsigned(poped_index)))) then
--							result_loss <= result_loss + 1;
--						end if;
--						poped_index <= poped_index + 1;
--					end if;
--				if(valid_o='1') then
--						result_passed <= result_passed + 1;
--					else
--						result_dropped <= result_dropped + 1;
--					end if;
--				end if;
--			end if;
--		end if;
--	end process;
	
end Behavioral;