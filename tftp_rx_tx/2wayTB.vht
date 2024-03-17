

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY way2_rmii_vhd_tst IS
END way2_rmii_vhd_tst;
ARCHITECTURE way2_rmii_arch OF way2_rmii_vhd_tst IS
-- constants                                                 
-- signals 
signal my_hex_value : std_logic_vector(623 downto 0) := X"000000000000005555555555555555555713ff8dd78b43000bbe1a4008004500003000000000ff113965c0a800fdc0a8000ac5ba0045001c3e200001726663313335302e747874006f6374657400";
    signal my_value : std_logic_vector(7 downto 0);                                                    
SIGNAL clk : STD_LOGIC;
signal clk_out:std_logic;
SIGNAL crs_0 : STD_LOGIC;
SIGNAL crs_1 : STD_LOGIC;
SIGNAL rx_d_0 : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL rx_d_1 : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL rx_er_0 : STD_LOGIC;
SIGNAL rx_er_1 : STD_LOGIC;
SIGNAL tx_d_0 : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL tx_d_1 : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL tx_en_0 : STD_LOGIC;
SIGNAL tx_en_1 : STD_LOGIC;
COMPONENT way2_rmii
	PORT (
	clk : in STD_LOGIC;
	clk_out:out std_logic;
	crs_0 : IN STD_LOGIC;
	crs_1 : IN STD_LOGIC;
	rx_d_0 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	rx_d_1 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	rx_er_0 : IN STD_LOGIC;
	rx_er_1 : IN STD_LOGIC;
	tx_d_0 : BUFFER STD_LOGIC_VECTOR(1 DOWNTO 0);
	tx_d_1 : BUFFER STD_LOGIC_VECTOR(1 DOWNTO 0);
	tx_en_0 : BUFFER STD_LOGIC;
	tx_en_1 : BUFFER STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : way2_rmii
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
		clk_out => clk_out,
	crs_0 => crs_0,
	crs_1 => crs_1,
	rx_d_0 => rx_d_0,
	rx_d_1 => rx_d_1,
	rx_er_0 => rx_er_0,
	rx_er_1 => rx_er_1,
	tx_d_0 => tx_d_0,
	tx_d_1 => tx_d_1,
	tx_en_0 => tx_en_0,
	tx_en_1 => tx_en_1
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
wait for 40  ns;    
 crs_0<='1';
 wait for 3000 ns;
 crs_0<='0';
 wait for 40 ns;
 crs_0<='1';
 wait for 40 ns;
 crs_0<='0';
 wait for 40 ns;
 crs_0<='1';
 wait for 40 ns;
 crs_0<='0';
 wait for 40 ns;
 crs_0<='1';
 wait for 40 ns;
 crs_0<='0';
 wait for 40 ns;
 crs_0<='1';
 wait for 40 ns;
 crs_0<='0';
 wait for 1000 ns;
END PROCESS init;                                            
always : PROCESS                                                                                 
BEGIN                                                         
    clk<='1';
wait for 20 ns;
clk<='0';
wait for 20 ns;    -- code executes for every event on sensitivity list                                                          
END PROCESS always; 
PROCESS                                                                                 
BEGIN   
   for i in 77 downto 0 loop 
	            my_value <= my_hex_value(i*8+7 downto i*8);                              
            for j in 0 to 3 loop
					 rx_d_0(0) <= my_value(j*2);
					 rx_d_0(1) <=my_value((j*2)+1);
					  wait for 40 ns;
            end loop;
         end loop;         
	WAIT;                                                                                                               
END PROCESS ;                                           
END way2_rmii_arch;
