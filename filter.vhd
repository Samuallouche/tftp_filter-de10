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
    signal opcode            : std_logic_vector(7 downto 0);
    type Element is array (0 to 4) of STD_LOGIC_VECTOR(7 downto 0);
    signal data_type : Element := (others => (others => '0'));
	 signal ver_port_des          : std_logic_vector(7 downto 0);

begin
    process (reset, clk)
        variable cnt_bus               : integer:= 0;
        variable cnt_byte              : integer:= 0;
        variable cnt_lenghe_data       : integer:= 0;
        variable bus_temp              : std_logic_vector(7 downto 0);
        --variable ver_port_des          : std_logic_vector(7 downto 0);
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
            cnt_bus := 7;
            cnt_byte := 0;
            cnt_lenghe_data := 0;
            bus_temp := (others => '0');
            ver_port_des <= (others => '0');
				--:
            ver_opcode := (others => '0');
				--:
            length_total := 0;
            length_data := 0;
            cnt_type_data := 0;
            flag_port_cur := '0';
            flag_opcode_cur := '0';
            flag_length_data_cur := '0';
            flag_load_data := '0';
            data_type <= (others => (others => '0'));
        elsif rising_edge(clk) then
            bus_temp(cnt_bus -1) := data_in(0);
            bus_temp(cnt_bus) := data_in(1);
            cnt_bus := cnt_bus - 2;
            if cnt_bus < 1 then
                cnt_bus := 7;
                if cnt_byte = 45 then
                    ver_port_des <= bus_temp;
						  --:
                    if ver_port_des = X"45" then
                        flag_port_cur := '1';
                    end if;
                elsif cnt_byte = 47 then
                    length_total := to_integer(unsigned(bus_temp));
                elsif cnt_byte = 51 and flag_port_cur = '1' then
						   ver_opcode := bus_temp;
							
							if ver_opcode = X"01" then
                        flag_opcode_cur := '1';
								opcode <= X"01";
								length_data := length_total - 17;
							end if;
                elsif (cnt_byte >= 52 + (length_data - 5) and cnt_byte <= (52 + (length_data - 1))) and flag_opcode_cur = '1' then
							if bus_temp = X"2e" then
                            flag_load_data := '1';
							end if;
								    if flag_load_data = '1' then
                                data_type(cnt_type_data) <= bus_temp;
                                cnt_type_data := cnt_type_data + 1;
					            end if;
                    
                else
                    cnt_byte := cnt_byte + 1;
                end if;
            end if;
			end if;
				  bus_temp := (others => '0');
				  data_out <= data_in;
				  port_des <= ver_port_des;
    end process;
end beh;





