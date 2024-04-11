library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity filter is
	generic(
	 preamble : integer := 8); 
    port (
        clk,tx_en_in: in std_logic;
        data_in: in std_logic_vector(1 downto 0);
		  tx_en_out:out std_logic;
		  data_good:out std_logic;
        data_out: out std_logic_vector(1 downto 0)); 
end filter;
architecture beh of filter is
type   Element is array (0 to 4) of STD_LOGIC_VECTOR(7 downto 0);
   signal data_type : Element := (others => (others => '0'));
	signal port_des: std_logic_vector(7 downto 0):=(others=>'0');
	signal len:      integer:=0;
	signal op_code:  std_logic_vector(7 downto 0):=(others=>'0');
	signal data_arr : std_logic:='0';
	type buffer_type is array (3 downto 0) of std_logic_vector(1 downto 0);
	signal buffer_en: std_logic_vector(3 downto 0):=(others=>'0');
	signal bus_temp :std_logic_vector(7 downto 0);
	signal reset_Sig :std_logic:='0';
	signal cnt_byte              : integer:= 0;
	signal delay_data :std_logic_vector(1 downto 0);
	begin
process(clk,tx_en_in)
	   variable buffer_data:buffer_type:= (others => (others => '0'));
		variable cnt_bus               : integer:= 0;
		variable cnt_type_data :integer := 0; 
		variable reset_data :std_logic_vector(3 downto 0):="1111";
	begin
if rising_edge(clk) then
		buffer_data:= data_in & buffer_data(3 downto 1);
		tx_en_out<=buffer_en(0); 
	if tx_en_in='0' then 	
		port_des<=(others=>'0');
		if reset_Sig='1' then
			buffer_data(0):="00";
			data_good<='0';			
		end if;
		reset_Sig<='0';
		data_good<='0';
		len<=0;
		op_code<=(others=>'0');
		data_arr<='0';
		data_type<=(others => (others => '0'));
		cnt_type_data:=0;
		cnt_bus:=0;
		cnt_byte<=0;	
		--bus_temp<=(others=>'0');
	else
		reset_data:="1111";
		cnt_bus:=cnt_bus+1;
		if cnt_bus = 4 then
			cnt_bus:=0;
			cnt_byte<=cnt_byte+1;
			bus_temp(7 downto 6)<=buffer_data(3);
			bus_temp(5 downto 4)<=buffer_data(2);
			bus_temp(3 downto 2)<=buffer_data(1);
			bus_temp(1 downto 0)<=buffer_data(0);
			---------------------------------------------
			if cnt_byte=38+preamble then
				if bus_temp=X"45" then
					port_des<=bus_temp;
				end if;
			elsif (cnt_byte=40+preamble) and port_des=X"45" then
				len<=  to_integer(unsigned(bus_temp));
			elsif (cnt_byte = 44 + preamble ) then 
				if bus_temp= X"01" then
					op_code<=bus_temp;
				end if;
			elsif cnt_byte=44+preamble then
				if (op_code/=X"01") and (port_des/=X"45") then
						-----שחרור מידע מהפיפו
				end if;
			elsif ((cnt_byte>=45+preamble) and (cnt_byte<= 30+len+preamble)) then 
				if bus_temp = X"2e" then
					data_type<= (others => (others => '0'));
					cnt_type_data:=0;
					data_arr<='1';
				elsif data_arr='1' then
					data_type(cnt_type_data) <= bus_temp;
					cnt_type_data := cnt_type_data + 1;
				end if;
				if cnt_type_data=5 then
						data_arr<='0';
					end if;
			elsif (cnt_byte=31+len+preamble) and op_code=X"01" and port_des=X"45" then
				 if data_type(0)=X"74" and data_type(1)=X"78" and data_type(2)=X"74" then-----------לזהות מתי במידע שנשמר מגיע בית שהוא 0 וזה אומר שסוג המידע נגמר 
						reset_Sig<='1';
						reset_data:="0000";
						data_good<='1';
				 end if;		
		end if;
		---------------------------------------------------------
	  end if;
	end if;
		buffer_en<=tx_en_in & buffer_en(3 downto 1) and reset_data;
		data_out<= delay_data;
		delay_data<= buffer_data(0);
end if;
end process;
end beh;
