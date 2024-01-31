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
component tftp_rmii_rx is 
port(clk:in std_logic;
rx_d:in std_logic_vector(1 downto 0);
rx_er:in std_logic;
crs:in std_logic;
tx_en:out std_logic;
tx_d:out std_logic_vector(1 downto 0));
end component;
begin
rx:tftp_rmii_rx port map(
clk =>clk,
rx_d => rx_d,
rx_er => rx_er,
tx_en => tx_en,
tx_d => tx_d,
crs => crs);

---------------------------------------

end beh;
