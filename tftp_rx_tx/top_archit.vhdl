library ieee;
use ieee.std_logic_1164.all;

entity top_rmii is
    port (
		led_test:out std_logic;
	 		reset		:	 IN STD_LOGIC;
        clk   : in  std_logic;
        rx_d  : in  std_logic_vector(1 downto 0);
        rx_er : in  std_logic;
        crs   : in  std_logic;
        tx_en_f : out std_logic;
        tx_d_f  : out std_logic_vector(1 downto 0);
				data_in0 : in std_logic_vector(31 downto 0):=(others=>'0');
				 data_in1 :in std_logic_vector(31 downto 0):=(others=>'0');
				 data_in2 :in std_logic_vector(31 downto 0):=(others=>'0');
				 data_in3 :in std_logic_vector(31 downto 0):=(others=>'0')
    );
end entity top_rmii;

architecture beh of top_rmii is 
    signal TX_OK_TEMP : std_logic;
    signal X_IN_OUT   : std_logic_vector(1 downto 0);
	 signal tx_en_sig :std_logic;
	 signal data_sig  :std_logic_vector(1 downto 0);
	 
	 
	 component filter is
	port(
		led_test :out std_logic;
		clk,tx_en_in: in std_logic;
        data_in    : in std_logic_vector(1 downto 0);
		  tx_en_out  : out std_logic;
		  data_good  : out std_logic;
        data_out   : out std_logic_vector(1 downto 0);
		  reset :in std_logic;
		  data_in0 : in std_logic_vector(31 downto 0):=(others=>'0');
		 data_in1 : in std_logic_vector(31 downto 0):=(others=>'0');
		 data_in2 :in std_logic_vector(31 downto 0):=(others=>'0');
		 data_in3 :in std_logic_vector(31 downto 0):=(others=>'0')
		  );
		  
	end component;

    component tftp_rmii_rx is 
        port (
            clk   : in  std_logic;
            rx_d  : in  std_logic_vector(1 downto 0);
            rx_er : in  std_logic;
            crs   : in  std_logic;
            tx_ok : out std_logic;
            tx_out: out std_logic_vector(1 downto 0)
        );
    end component;

    component tftp_rmii_tx is
        port (
            clk      : in  std_logic;
            tx_ok    : in  std_logic;
            rx_input : in  std_logic_vector(1 downto 0);
            tx_en    : out std_logic;
            tx_d     : out std_logic_vector(1 downto 0)
        );
    end component;

begin
    rx : tftp_rmii_rx port map (
        clk   => clk,
        rx_d  => rx_d,
        rx_er => rx_er,
        tx_ok => TX_OK_TEMP,
        tx_out => X_IN_OUT,
        crs   => crs
    );
	 
	  tx : tftp_rmii_tx port map (
        clk      => clk,
        tx_ok    => TX_OK_TEMP,
        rx_input => X_IN_OUT,
        tx_en    => tx_en_sig,
        tx_d     =>	data_sig
    );

	 
	 filter_cop: filter port map (
	 led_test =>led_test,
		reset=>reset,
		clk => clk,
		tx_en_in =>tx_en_sig,
		data_in =>data_sig ,
		tx_en_out =>tx_en_f,
   	data_out =>tx_d_f,
		data_in0 =>data_in0,
		data_in1 =>data_in1,
		data_in2 =>data_in2,
		data_in3 =>data_in3
		);

   
end beh;
