library ieee;
use ieee.std_logic_1164.all;
entity top_rmii is
port(
clk:in std_logic;
rx_d:in std_logic_vector(1 downto 0);
rx_er:in std_logic;
crs:in std_logic;
tx_en:out std_logic;
tx_d:out std_logic_vector(1 downto 0));
end entity top_rmii;

architecture beh of top_rmii is 

signal TX_OK_TEMP:std_logic;
signal X_IN_OUT:std_logic_vector(1 downto 0);
-------------------------------------------
component tftp_rmii_rx is 
port(clk:in std_logic;
rx_d:in std_logic_vector(1 downto 0);
rx_er:in std_logic;
crs:in std_logic;
tx_ok:out std_logic;
tx_out:out std_logic_vector(1 downto 0));
end component;
--------------------------------------------
component tftp_rmii_tx is
port(clk:in std_logic;
tx_ok:in std_logic;
rx_input:in std_logic_vector(1 downto 0);
tx_en:out std_logic;
tx_d:out std_logic_vector(1 downto 0));
end component;
-------------------------------------
begin
rx:tftp_rmii_rx port map(
clk =>clk,
rx_d => rx_d,
rx_er => rx_er,
tx_ok => TX_OK_TEMP,
tx_out => X_IN_OUT,
crs => crs);
-----------------------------------
tx:tftp_rmii_tx port map(
clk =>clk,
tx_ok => TX_OK_TEMP,
rx_input => X_IN_OUT,
tx_en => tx_en,
tx_d => tx_d);
---------------------------------------

end beh;
