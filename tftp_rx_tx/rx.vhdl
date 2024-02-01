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
 
signal data_arr:bit;

 begin
	 check_valid_data:process(clk,crs)
	 variable cnt1:integer:=0;
	variable ok:integer:=0;
	 	 variable cnt:integer:=0;
	 begin
	 if crs='1' then
			if rx_d="01" and ok=1 then
				data_arr<='1';
				cnt1:=cnt1+1;
			elsif rx_d="00" then
				ok:=1;
			end if;
		end if;
	if crs='0' and cnt1>8 then
		cnt:=cnt+1;
		if cnt=3 then
			data_arr<='0';
			ok:=0;
			cnt:=0;
			cnt1:=0;
		end if;
	end if;
	if crs='0' and cnt1<2 then
		data_arr<='0';
			ok:=0;
			cnt:=0;
			cnt1:=0;
	end if;
	end process;
	
 transmit_data:process(clk)
 begin
	if data_arr='1' and clk='1' then	 
			tx_out<=rx_d;
			tx_ok<='1';
	end if;
	if data_arr='0' and clk='1'then	
			tx_out<="00";
			tx_ok<='0';	
	end if;
end process;
 end beh;
 
 
