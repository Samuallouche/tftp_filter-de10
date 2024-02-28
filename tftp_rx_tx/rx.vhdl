library ieee;
use ieee.std_logic_1164.all;
entity tftp_rmii_rx is
port(
clk:in std_logic;
rx_d:in std_logic_vector(1 downto 0);
rx_er:in std_logic;
crs:in std_logic;
tx_ok:out std_logic;
tx_out:out std_logic_vector(1 downto 0));

end entity;

architecture beh of tftp_rmii_rx is
signal last_crs:std_logic:='1';
signal cnt1:integer:=0;
signal ok:integer:=0;
signal delay_one_clk:integer:=0;
signal cnt:integer:=0;
SIGNAL check_mode:integer:=0;
SIGNAL clear_mode :integer:=0;
 begin
	 check_valid_data:process(clk,crs)
 	variable cnt_num_of_zero:integer:=0;
	variable data_arr:bit:='0';
	VARIABLE buff_crs:std_logic_vector(1 downto 0):=(others=>'0');
	
	variable buff_data:std_logic_vector(1 downto 0):=(others => '0');
	 begin		
			 if rising_edge(clk) then
					if crs='1' then
						if rx_d="01" and ok=1 then
						data_arr:='1';
							delay_one_clk<=1;
							cnt1<=cnt1+1;
						elsif rx_d="00" then
							ok<=1;
						end if;
					end if;
					--------------------------------------------
					buff_crs:=crs & buff_crs(1);
					--------------------------------------------
					if check_mode=1 then	
						if buff_crs="00" then 
							data_arr:='0';
							clear_mode<=1;
						end if;
					end if;
					------------------------------------------
					if cnt1>8 then
						if crs='0' then
							check_mode<=1;
						end if;
					end if;
			-----------------------------------------------
					if clear_mode=1 then
						data_arr:='0';
						ok<=0;
						check_mode<=0;
						clear_mode<=0;
						cnt_num_of_zero:=0;
						cnt<=0;
						cnt1<=0;
					end if;
			------------------------------------
				if data_arr='1' then	
						tx_out<=buff_data;
						buff_data:=rx_d;
						--tx_out<=rx_d;
						tx_ok<='1';
				end if;
				if data_arr='0' then
						tx_out<=buff_data;
						buff_data:="00";
						--tx_out<="00";
						tx_ok<='0';	
				end if;	
		-------------------------RISING_EDGE
			end if;
	end process;
end beh;
		 
		 
