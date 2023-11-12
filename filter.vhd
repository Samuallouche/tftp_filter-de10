library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity filter is
    port (
        clk, reset: in std_logic;
        data_in: in std_logic_vector(1 downto 0);
        data_out: out std_logic_vector(1 downto 0)
    );
end entity filter;

architecture beh of filter is
    signal port_des          : std_logic_vector(7 downto 0);
    signal opcode            : std_logic_vector(7 downto 0);
    signal length_data_name  : std_logic_vector(7 downto 0);
    type DynamicArray is array (integer range <>) of std_logic;
    variable data_name       : DynamicArray(0 to 7) := (others => '0');
    variable place_of_dot    : integer;

begin
    process (reset, clk)
        variable cnt_bus               : integer;
        variable cnt_byte              : integer := 0;
        variable cnt_lenghe_data       : integer := 0;
        variable bus_temp              : std_logic_vector(7 downto 0);
        variable ver_port_des          : std_logic_vector(7 downto 0);
        variable ver_opcode            : std_logic_vector(7 downto 0);
        variable length_data           : integer;
        variable flag_port_cur         : std_logic := '0';
        variable flag_opcode_cur       : std_logic := '0';
        variable flag_length_data_cur  : std_logic := '0';
        variable flag_load_data        : std_logic := '0';  -- Added this variable

    begin
        if reset = '1' then
            cnt_bus := 0;
            cnt_byte := 0;
            flag_load_data := '0';
            flag_length_data_cur := '0';
            flag_opcode_cur := '0';
            flag_port_cur := '0';  -- Reset the flag_load_data on reset
        elsif rising_edge(clk) then
            bus_temp(cnt_bus) := data_in(0);
            bus_temp(cnt_bus + 1) := data_in(1);
            cnt_bus := cnt_bus + 2;
            if cnt_bus = 8 then
                cnt_bus := 0;
                if cnt_byte = 45 then
                    ver_port_des := bus_temp;
                    if ver_port_des = X"45" then  -- Corrected variable name
                        flag_port_cur := '1';
                    end if;
                end if;
                if cnt_byte = 47 then
                    length_data := to_integer(unsigned(bus_temp));
                end if;
                if cnt_byte = 51 and flag_port_cur = '1' then
                    if ver_opcode = X"01" then
                        flag_opcode_cur := '1';
                    end if;
                end if;
                if cnt_byte >= 52 and cnt_byte <=(52 +length_data)then
                    data_name(cnt_lenghe_data) := bus_temp;
                    cnt_lenghe_data := cnt_lenghe_data + 1;
                    if cnt_byte = (52 +length_data) then
                        flag_load_data := '1';
                    end if;
                end if;
                if flag_load_data = '1' then
                    for i in 0 to (length_data) loop
                        if data_name(i) = X"2e" then
                            place_of_dot := i;
                        end if;
                    end loop;
                    
                end if;
            end if;
            bus_temp := (others => '0');
            cnt_byte := cnt_byte + 1;
            data_out <= data_in;
            port_des <= ver_port_des;
            length_data_name <= length_data - 16;
        end if;
    end process;
end architecture;
