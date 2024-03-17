library ieee;
use ieee.std_logic_1164.all;

entity tftp_rmii_rx is
    port (
        clk   : in  std_logic;
        rx_d  : in  std_logic_vector(1 downto 0);
        rx_er : in  std_logic;
        crs   : in  std_logic;
        tx_ok : out std_logic;
        tx_out: out std_logic_vector(1 downto 0)
    );
end entity;

architecture beh of tftp_rmii_rx is
    signal last_crs   : std_logic := '1';
    signal cnt1       : integer := 0;
    signal ok         : bit := '0';
    signal delay_one_clk : integer := 0;
    signal cnt        : integer := 0;
    signal check_mode : integer := 0;
    signal clear_mode : integer := 0;
    type buffer_type is array (0 to 1) of std_logic_vector(1 downto 0);
begin
    check_valid_data: process(clk, crs)
        variable cnt_num_of_zero : integer := 0;
        variable data_arr       : bit := '0';
        variable buff_crs       : std_logic_vector(1 downto 0) := (others => '0');
        variable buff_data      : buffer_type := (others => (others => '0'));
    begin
        if rising_edge(clk) then
            buff_crs := crs & buff_crs(1);
            if crs = '1' then
                if rx_d = "01" and ok = '1' then
                    delay_one_clk <= 1;
                    cnt1 <= cnt1 + 1;
                elsif rx_d = "00" then
                    ok <= '1';
                end if;
            end if;
            if delay_one_clk = 1 then 
                data_arr := '1';
            end if;
            if cnt1 > 8 then
                if crs = '0' then
                    check_mode <= 1;
                end if;
            end if;
            if check_mode = 1 then
                if buff_crs = "00" then 
                    data_arr := '0';
                    clear_mode <= 1;
                end if;
            end if;
            if clear_mode = 1 then
                ok <= '0';
                check_mode <= 0;
                clear_mode <= 0;
                cnt_num_of_zero := 0;
                cnt <= 0;
                delay_one_clk <= 0;
                cnt1 <= 0;
            end if;
            buff_data(1) := buff_data(0);
            buff_data(0) := rx_d;
            if data_arr = '1' then
                tx_out <= buff_data(1);
                tx_ok <= '1';
            end if;
            if data_arr = '0' then
                tx_ok <= '0';
                tx_out <= buff_data(1);
            end if; 
        end if;
    end process;
end beh;
