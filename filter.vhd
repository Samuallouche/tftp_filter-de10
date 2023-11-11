library ieee;
use ieee.std_logic_1164.all;
entity filter is
    port(
    clk,reset:in std_logig;
    data_in:in std_logic_vector(1 downto 0);
    data_out:out std_logic_vector(1 downto 0)

        );
    end;
    architecture beh of filter is
        signal port_des std_logic_vector(7 downto 0);
        signal flag_port_cur std_logic:<='0';
        signal flag_opcode_cur std_logic:<='0';
        signal opcode std_logic_vector(7 downto 0);
        variable length_data_name std_logic_vector(7 downto 0);

    begin
    process(reset,clk)
    variable cnt_bus:integer;
    variable cnt_byte:integer:<=0;
    variable bus_temp:std_logic_vector(7 downto 0);
    variable ver_port_des std_logic_vector(7 downto 0);
    variable ver_opcode std_logic_vector(7 downto 0);
    variable length_data std_logic_vector(7 downto 0);


    begin
        if reset='1' then
            cnt_bus<:0;
            cnt_byte<=0;
        elsif rising_edge(clk) then
            bus_temp(cnt_bus)<= data_in(0);
            bus_temp(cnt_bus+1)<= data_in(1);
            cnt_bus<=cnt_bus+2;
            if cnt_bus=8 then
                cnt_bus<:0;
                if  cnt_byte=45 then    --התייחסות רק לחלק של הפורטים לזיהווי אם מדובר בtftp
                     ver_port_des<=bus_temp;
                    if ver_port_process=0x45 then
                    flag_port_cur<:'1';
                    end if;
                end if;
                if cnt_byte=47 then-- אורך שם הקובץ
                    length_data<=bus_temp;
                end if
                if  cnt_byte=51 && flag_port_cur='1' then  
                ver_opcode<=bus_temp;
                    if ver_opcode=0x01 then
                         flag_opcode_cur<='1';
                    end if
                 
                end if;
                 bus_temp<=(others =>0);
                 cnt_byte<:cnt_byte+1;
                 data_out<=data_in;
                 port_des<=ver_port_des;
                length_data_name<=length_data-16;
                --take out the data
                end if;
            
            end if;
        end process;
    
    end architecture;