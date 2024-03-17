library ieee;
use ieee.std_logic_1164.all;

entity tftp_rmii_tx is
    port (
        clk      : in  std_logic;
        tx_ok    : in  std_logic;
        rx_input : in  std_logic_vector(1 downto 0);
        tx_en    : out std_logic;
        tx_d     : out std_logic_vector(1 downto 0)
    );
end entity;

architecture beh of tftp_rmii_tx is 
begin
    process(tx_ok, clk)
    begin
        if rising_edge(clk) then
            if tx_ok = '1' then 
                tx_en <= '1';
                tx_d  <= rx_input;
            elsif tx_ok = '0' then
                tx_en <= '0';
                tx_d  <= "00";
            end if;
        end if;
    end process;
end beh;
