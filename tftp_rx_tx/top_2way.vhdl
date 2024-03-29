library ieee;
use ieee.std_logic_1164.all;

entity way2_rmii is
    port (
        clk      : in  std_logic;
        clk_out  : out std_logic;
        rx_d_0   : in  std_logic_vector(1 downto 0);
        rx_er_0  : in  std_logic;
        crs_0    : in  std_logic;
        tx_en_0  : out std_logic;
        tx_d_0   : out std_logic_vector(1 downto 0);
        rx_d_1   : in  std_logic_vector(1 downto 0);
        rx_er_1  : in  std_logic;
        crs_1    : in  std_logic;
        tx_en_1  : out std_logic;
        tx_d_1   : out std_logic_vector(1 downto 0)
    );
end entity way2_rmii;

architecture beh1 of way2_rmii is

    component top_rmii is 
        port (
            clk   : in  std_logic;
            rx_d  : in  std_logic_vector(1 downto 0);
            rx_er : in  std_logic;
            crs   : in  std_logic;
            tx_en_f : out std_logic;
            tx_d_f  : out std_logic_vector(1 downto 0)
        );
    end component;
		--signal tx_en1_2_0 :std_logic;
		--signal tx_en0_2_1 :std_logic;
		--signal data1_2_0  :std_logic_vector(1 downto 0);
		--signal data0_2_1  :std_logic_vector(1 downto 0);
begin
    --------------------------------
    clk_out <= clk;
    -------------------------------------

    zero2one : top_rmii port map (
        clk   => clk,
        rx_d  => rx_d_0,
        rx_er => rx_er_0,
        crs   => crs_0,
        tx_en_f => tx_en_1,
        tx_d_f  => tx_d_1
    );

    one2zero : top_rmii port map (
        clk   => clk,
        rx_d  => rx_d_1,
        rx_er => rx_er_1,
        crs   => crs_1,
        tx_en_f => tx_en_0,
        tx_d_f  => tx_d_0 
    );
	 
	

end beh1;
