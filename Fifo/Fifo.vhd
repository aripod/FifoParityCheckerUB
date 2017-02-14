library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
entity Fifo is
	Generic (
		constant DATA_WIDTH  : positive := 4;
		constant FIFO_DEPTH	: positive := 4
	);
	Port ( 
		clk		: in  STD_LOGIC;
		rst_n		: in  STD_LOGIC;
		push_valid_i	: in  STD_LOGIC;
		push_data_i	: in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		pop_grant_i	: in  STD_LOGIC;
		pop_data_o	: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		pop_valid_o	: out STD_LOGIC;
		push_grant_o	: out STD_LOGIC
	);
end Fifo;
 
architecture Behavioral of Fifo is
	signal status_empty : std_logic:='1';
	signal status_full : std_logic:='0';
begin
	-- Memory Pointer Process
	fifo_proc : process (clk)
		type FIFO_Memory is array (0 to FIFO_DEPTH - 1) of STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		variable Memory : FIFO_Memory;
		
		variable Head : natural range 0 to FIFO_DEPTH - 1;
		variable Tail : natural range 0 to FIFO_DEPTH - 1;
		
		variable Looped : boolean;
	begin
		if(clk'event and clk='1') then
			if(rst_n = '0') then
				Head := 0;
				Tail := 0;
				
				Looped := false;
				
				status_full  <= '0';
				status_empty <= '1';
				pop_data_o <= (others =>'0');
			else
				pop_data_o <= Memory(Tail);
				if (pop_grant_i = '1') then
					if ((Looped = true) or (Head /= Tail)) then
						-- Update data output
						--pop_data_o <= Memory(Tail);
						
						-- Update Tail pointer as needed
						if ((Tail = FIFO_DEPTH - 1) and status_empty/='1') then
							Tail := 0;
							
							Looped := false;
						else
							Tail := Tail + 1;
						end if;
					end if;
				end if;
				
				if (push_valid_i = '1') then
					if ((Looped = false) or (Head /= Tail)) then
						-- Write Data to Memory
						Memory(Head) := push_data_i;
						
						-- Increment Head pointer as needed
						if (Head = FIFO_DEPTH - 1) then
							Head := 0;
							
							Looped := true;
						else
							Head := Head + 1;
						end if;
					end if;
				end if;
				
				-- Update Empty and Full flags
				if (Head = Tail) then
					if Looped then
						status_full <= '1';
					else
						status_empty <= '1';
					end if;
				else
					status_empty	<= '0';
					status_full	<= '0';
				end if;
			end if;
		end if;
	end process;
	
	pop_valid_o <= status_empty;
	push_grant_o <= not status_full;
		
end Behavioral;