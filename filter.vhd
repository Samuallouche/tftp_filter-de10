library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity tftp_filte_part is
    port (
        clk, reset: in std_logic;
        data_in: in std_logic_vector(1 downto 0);
        data_out: out std_logic_vector(1 downto 0)
    );
end tftp_filte_part;

architecture beh of tftp_filte_part is
    signal port_des          : std_logic_vector(7 downto 0);
	 signal bus_test :std_logic_vector(7 downto 0);
    signal opcode            : std_logic_vector(7 downto 0);
    type Element is array (0 to 4) of STD_LOGIC_VECTOR(7 downto 0);
    signal data_type : Element := (others => (others => '0'));
	 --signal ver_port_des          : std_logic_vector(7 downto 0);
	 signal cnt_bus               : integer:= 0;
	 signal cnt_fifo               : integer:= 0;
	 signal cnt1_fifo               : integer:= 0;


	 --signal bus_temp              : std_logic_vector(7 downto 0);
	signal flag_finish_pack :std_logic:='0';
	signal cnt_byte              : integer:= 0;
	--signal ver_opcode            : std_logic_vector(7 downto 0);

	component fifo_part
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		sclr		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		almost_full : OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;
	signal read_req:std_logic:='0';
	signal write_req:std_logic:='0';
	signal fifo_empty:std_logic;
	signal fifo_full:std_logic;
	signal d_out:STD_LOGIC_vector(7 downto 0);
	signal d_in:STD_LOGIC_vector(7 downto 0);
	signal upload_max:std_logic;
	signal fifo_reset:std_logic;
	

begin
fifo_part_inst : fifo_part PORT MAP (
		clock	 => clk,
		data	 => d_in,
		rdreq	 => read_req,
		sclr	 => fifo_reset,
		wrreq	 => write_req,
		empty	 => fifo_empty,
		full	 => fifo_full,
		almost_full => upload_max,
		q	 => d_out
	);

    process (reset, clk)
        --variable cnt_bus               : integer:= 0;
        --variable cnt_byte              : integer:= 0;
        variable cnt_lenghe_data       : integer:= 0;
        variable bus_temp              : std_logic_vector(7 downto 0);
        variable ver_port_des          : std_logic_vector(7 downto 0);
        variable ver_opcode            : std_logic_vector(7 downto 0);
        variable length_total          : integer:= 0;
        variable length_data           : integer:= 0;
        variable cnt_type_data         : integer:= 0;
        variable flag_port_cur         : std_logic := '0';
        variable flag_opcode_cur       : std_logic := '0';
        variable flag_length_data_cur  : std_logic := '0';
        variable flag_load_data        : std_logic := '0';
    begin
        if reset = '1' then
            cnt_bus <= 0;
            cnt_byte <= 0;
				flag_finish_pack <='0';
            cnt_lenghe_data := 0;
            bus_temp := (others => 'U');
            ver_port_des := (others => '0');
            ver_opcode := (others => '0');
            length_total := 0;
            length_data := 0;
            cnt_type_data := 0;
            flag_port_cur := '0';
            flag_opcode_cur := '0';
            flag_length_data_cur := '0';
            flag_load_data := '0';
            data_type <= (others => (others => '0'));
        elsif rising_edge(clk) then
		  if data_in/="UU" then
            bus_temp(cnt_bus) := data_in(0);
            bus_temp(cnt_bus + 1) := data_in(1);
					if cnt_bus = 6 then
						cnt_bus <= 0;
						bus_test<=bus_temp;
						if cnt_byte = 46 then
                    ver_port_des := bus_temp;
						  if ver_port_des = X"45" then
								port_des<= ver_port_des;
                        flag_port_cur := '1';
							end if;
						elsif cnt_byte = 48 then
								length_total := to_integer(unsigned(bus_temp));
						elsif cnt_byte = 52 and flag_port_cur = '1' then
								ver_opcode := bus_temp;
								if ver_opcode = X"01" then
                           flag_opcode_cur := '1';
									opcode <= ver_opcode;
									length_data := length_total - 16;
								end if;
						elsif (cnt_byte >= 53 + (length_data - 5) and cnt_byte <= (53 + (length_data - 1))) and flag_opcode_cur = '1' then
							if bus_temp = X"2e" then
                            flag_load_data := '1';
							end if;
							if flag_load_data = '1' then
                          data_type(cnt_type_data) <= bus_temp;
                           cnt_type_data := cnt_type_data + 1;
						   end if;
						elsif(cnt_byte = (48+length_total-5)) and flag_port_cur = '1' and flag_opcode_cur = '1' then
							flag_finish_pack<='1';
							end if;
						  cnt_byte<=cnt_byte+1;
					else
						cnt_bus <= cnt_bus +	2;
					end if;
			end if;
		end if;
    end process;
	fifo_process:process(clk,flag_finish_pack,reset)
	  begin
	  if reset='1' then
		write_req<='0';
		read_req<='0';
		elsif rising_edge(clk) then
		if (flag_finish_pack='0' or upload_max='0')then
			write_req <= '0';
			if data_in/="UU" then
				write_req <= '1';
				d_in<=data_in;
			end if;
		elsif (flag_finish_pack='1') or (upload_max='1') then
		read_req<='0';
		if fifo_empty='0' then
		read_req<='1';
		data_out<= d_out;
		end if;
		end if;
	  end if;
	  end process;	
end beh;





/**
 fifo_process:process(clk,flag_finish_pack,reset)
	 variable bus_temp_fifo  : std_logic_vector(7 downto 0);
	 variable flag_restart_fifo:std_logic:='1';
	 begin
	 if reset='1' then
		cnt_fifo <= 0;
		cnt1_fifo<=0;
		write_req<='0';
		fifo_reset <='1';
		flag_restart_fifo:='1';
		bus_temp_fifo := (others => 'U');
	 elsif (rising_edge(clk)) then
		fifo_reset<='0';
	   if((flag_finish_pack='0' or upload_max='0') ) then
		
			if data_in/="UU" then
				write_req <= '0';
            bus_temp_fifo(cnt_fifo) := data_in(0);
            bus_temp_fifo(cnt_fifo + 1) := data_in(1);
					if cnt_fifo = 6 then
					cnt_fifo<=0;
					write_req <= '1';
					d_in <=bus_temp_fifo;
					end if;
					cnt_fifo <= cnt_fifo +	2;
			end if;
		elsif (((flag_finish_pack='1') or (upload_max='1') )and flag_restart_fifo='1')  then 
			if fifo_empty='1' then
				fifo_reset<='1';
				flag_restart_fifo:='0';
			end if;
			read_req<='1';
			data_out(0)<= d_out(cnt1_fifo);
			data_out(1)<= d_out(cnt1_fifo+1);
			if cnt1_fifo=6 then
				cnt1_fifo<=0;
				read_req<='0';
			end if;
			cnt1_fifo<=cnt1_fifo+2;
			
		end if;
		end if;
	 end process;

**/