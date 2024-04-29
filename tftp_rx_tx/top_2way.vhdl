library ieee;
use ieee.std_logic_1164.all;
entity way2_rmii is
    port (
		led_test : out std_logic;
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
        tx_d_1   : out std_logic_vector(1 downto 0);
		reset    : in std_logic;
		  --------------------------------------------------
		  	memory_mem_a1                           : out   std_logic_vector(14 downto 0);                    -- mem_a
            memory_mem_ba1                          : out   std_logic_vector(2 downto 0);                     -- mem_ba
            memory_mem_ck1                          : out   std_logic;                                        -- mem_ck
            memory_mem_ck_n1                        : out   std_logic;                                        -- mem_ck_n
            memory_mem_cke1                         : out   std_logic;                                        -- mem_cke
            memory_mem_cs_n1                        : out   std_logic;                                        -- mem_cs_n
            memory_mem_ras_n1                       : out   std_logic;                                        -- mem_ras_n
            memory_mem_cas_n1                       : out   std_logic;                                        -- mem_cas_n
            memory_mem_we_n1                        : out   std_logic;                                        -- mem_we_n
            memory_mem_reset_n1                     : out   std_logic;                                        -- mem_reset_n
            memory_mem_dq1                          : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
            memory_mem_dqs1                         : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
            memory_mem_dqs_n1                       : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
            memory_mem_odt1                         : out   std_logic;                                        -- mem_odt
            memory_mem_dm1                          : out   std_logic_vector(3 downto 0);                     
            memory_oct_rzqin1                       : in    std_logic                     := 'X');
end entity way2_rmii;

architecture beh1 of way2_rmii is
 signal led_output: std_logic;
  signal led_output1: std_logic;

	COMPONENT soc_system IS
	PORT (
	clk_clk : in STD_LOGIC;
	custom_filter_0_filter_type_new_signal : out   std_logic_vector(31 downto 0);                    -- new_signal
	custom_filter_0_filter_type_new_signa  : out   std_logic_vector(31 downto 0);                    -- new_signa
	custom_filter_0_filter_type_new_sig    : out   std_logic_vector(31 downto 0);                    -- new_sig
	custom_filter_0_filter_type_new_si     : out   std_logic_vector(31 downto 0); 
	reset_reset_n                          : in    std_logic                     := 'X'  ;
					memory_mem_a                           : out   std_logic_vector(14 downto 0);                    -- mem_a
					memory_mem_ba                          : out   std_logic_vector(2 downto 0);                     -- mem_ba
					memory_mem_ck                          : out   std_logic;                                        -- mem_ck
					memory_mem_ck_n                        : out   std_logic;                                        -- mem_ck_n
					memory_mem_cke                         : out   std_logic;                                        -- mem_cke
					memory_mem_cs_n                        : out   std_logic;                                        -- mem_cs_n
					memory_mem_ras_n                       : out   std_logic;                                        -- mem_ras_n
					memory_mem_cas_n                       : out   std_logic;                                        -- mem_cas_n
					memory_mem_we_n                        : out   std_logic;                                        -- mem_we_n
					memory_mem_reset_n                     : out   std_logic;                                        -- mem_reset_n
					memory_mem_dq                          : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
					memory_mem_dqs                         : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
					memory_mem_dqs_n                       : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
					memory_mem_odt                         : out   std_logic;                                        -- mem_odt
					memory_mem_dm                          : out   std_logic_vector(3 downto 0);                     -- mem_dm
					memory_oct_rzqin                       : in    std_logic                     := 'X' );             -- oct_rzqin
	END COMPONENT soc_system;



    component top_rmii is 
        port (
		       led_test  :out std_logic;
             clk       : in  std_logic;
             rx_d      : in  std_logic_vector(1 downto 0);
             rx_er     : in  std_logic;
             crs       : in  std_logic;
             tx_en_f   : out std_logic;
             tx_d_f    : out std_logic_vector(1 downto 0);
				 data_in0  :in std_logic_vector(31 downto 0):=(others=>'0');
				 data_in1  : in std_logic_vector(31 downto 0):=(others=>'0');
				 data_in2  : in std_logic_vector(31 downto 0):=(others=>'0');
				 data_in3  : in std_logic_vector(31 downto 0):=(others=>'0'));
    end component;
			signal	 data_0 :std_logic_vector(31 downto 0):=(others=>'0');
			signal	 data_1 :std_logic_vector(31 downto 0):=(others=>'0');
			signal	 data_2 :std_logic_vector(31 downto 0):=(others=>'0');
			signal	 data_3 :std_logic_vector(31 downto 0):=(others=>'0');
begin
    ----------------------------------------
    clk_out <= clk;
    ----------------------------------------
	 
	 --------------------------------------------------
		U0: soc_system PORT MAP (
		clk_clk => clk,
		custom_filter_0_filter_type_new_signal =>data_0,
		custom_filter_0_filter_type_new_signa =>data_1,
		custom_filter_0_filter_type_new_sig=>data_2,
		custom_filter_0_filter_type_new_si =>data_3,
		reset_reset_n => reset, 
	---------------------------------------------------
				memory_mem_a                           => memory_mem_a1,                                     
            memory_mem_ba                          => memory_mem_ba1,                          
            memory_mem_ck                          => memory_mem_ck1,                          
            memory_mem_ck_n                        => memory_mem_ck_n1,                     
            memory_mem_cke                         => memory_mem_cke1,                        
            memory_mem_cs_n                        => memory_mem_cs_n1,                        
            memory_mem_ras_n                       => memory_mem_ras_n1,                       
            memory_mem_cas_n                       => memory_mem_cas_n1,                      
            memory_mem_we_n                        => memory_mem_we_n1,                        
            memory_mem_reset_n                     => memory_mem_reset_n1,                     
            memory_mem_dq                          => memory_mem_dq1,                          
            memory_mem_dqs                         => memory_mem_dqs1,                       
            memory_mem_dqs_n                       => memory_mem_dqs_n1,                       
            memory_mem_odt                         => memory_mem_odt1,                         
            memory_mem_dm                          => memory_mem_dm1,                          
            memory_oct_rzqin                       => memory_oct_rzqin1
				);

	----------------------------------------------------

    zero2one : top_rmii port map (
	   led_test      =>led_output,
		data_in0      =>data_0,
		data_in1      =>data_1,
		data_in2      =>data_2,
		data_in3      =>data_3,
      clk           => clk,
      rx_d          => rx_d_0,
      rx_er         => rx_er_0,
      crs           => crs_0,
      tx_en_f       => tx_en_1,
      tx_d_f        => tx_d_1);

    one2zero : top_rmii port map (
	 	 led_test => led_output1,
		 data_in0 => data_0,
		 data_in1 => data_1,
		 data_in2 => data_2,
		 data_in3 => data_3,
       clk      => clk,
       rx_d     => rx_d_1,
       rx_er    => rx_er_1,
       crs      => crs_1,
       tx_en_f  => tx_en_0,
       tx_d_f   => tx_d_0 );
	 
	 led_test<= led_output1 or led_output;
end beh1;
