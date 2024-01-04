library ieee;
use ieee.std_logic_1164.all;
entity tftp_rmii_cl is
port(
clk:in std_logic;
rx_d:in std_logic_vector(1 downto 0);
rx_er:in std_logic;
crs:in bit;
data_out:out std_logic_vector(1 downto 0));
end entity;

architecture beh of tftp_rmii_cl is 
	signal data_arr:std_logic:='0';
	signal d_out:std_logic_vector(1 downto 0);
	signal its_transmit:std_logic:='0';
 begin
 check_valid_data:process(clk,crs)
 begin
	if crs='1' then
		if rising_edge(clk) then
		if rx_d="00" then
			data_arr<='1';
		end if;
		if data_arr='1' then
			if rx_d="10" then
				its_transmit<='0';
			end if;
			if rx_d="01" then
				its_transmit<='1';
			end if;
		end if;
		end if;
		end if;
end process;
 transmit_data:process(clk,rx_er,its_transmit)
 begin
 if rising_edge(clk) then 
	if  rx_er'EVENT AND rx_er='0' then
			if  its_transmit='1' then
				d_out<=rx_d;
			end if;
	else
	d_out<="00";
	end if;
 end if;
end process;
data_out<=d_out;
 end beh;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 