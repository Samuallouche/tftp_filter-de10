library ieee;
use ieee.std_logic_1164.all;
entity way2_rmii is
port(
clk:buffer std_logic;
rx_d_0:in std_logic_vector(1 downto 0);
rx_er_0:in std_logic;
crs_0:in std_logic;
tx_en_0:out std_logic;
tx_d_0:out std_logic_vector(1 downto 0);
rx_d_1:in std_logic_vector(1 downto 0);
rx_er_1:in std_logic;
crs_1:in std_logic;
tx_en_1:out std_logic;
tx_d_1:out std_logic_vector(1 downto 0));
end entity;

architecture beh1 of way2_rmii is

component top_rmii is 
port(clk:in std_logic;
rx_d:in std_logic_vector(1 downto 0);
rx_er:in std_logic;
crs:in std_logic;
tx_en:out std_logic;
tx_d:out std_logic_vector(1 downto 0));
end component;
begin
-------------------------------------
zero2one:top_rmii port map(
clk => clk,
rx_d => rx_d_0,
rx_er => rx_er_0,
crs => crs_0,
tx_en => tx_en_1 ,
tx_d => tx_d_1);
--------------------------------------------
one2zero:top_rmii port map(
clk => clk,
rx_d => rx_d_1,
rx_er => rx_er_1,
crs => crs_1,
tx_en => tx_en_0 ,
tx_d => tx_d_0);
end beh1;