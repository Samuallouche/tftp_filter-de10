

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;                              

ENTITY tftp_filte_part_vhd_tst IS
END tftp_filte_part_vhd_tst;
ARCHITECTURE tftp_filte_part_arch OF tftp_filte_part_vhd_tst is         
-- signals                                                   

    signal my_hex_value : std_logic_vector(567 downto 0) := X"ffffffffffffffffff13ff8dd78b43000bbe189a4008004500003000000000ff113965c0a800fdc0a8000ac5ba0045001c3e200001726663313335302e747874006f6374657400";
    signal my_value : std_logic_vector(7 downto 0);
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL data_in : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
    SIGNAL data_out : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL tx_en : STD_LOGIC;

	 signal cnt_bus               : integer:= 0;
	 signal bus_temp              : std_logic_vector(7 downto 0);
COMPONENT tftp_filte_part
	PORT (
	clk : IN STD_LOGIC;
	data_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    tx_en : BUFFER STD_LOGIC;
	txd_out : BUFFER STD_LOGIC_VECTOR(1 DOWNTO 0);
	reset : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : tftp_filte_part
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	data_in => data_in,
	reset => reset,
	tx_en => tx_en,
	txd_out => data_out
	);

process
	begin
	clk<='1';
	wait for 5 ns;
	clk<='0';
	wait for 5 ns;
	end process;
                                            
PROCESS
    BEGIN
	 reset<='1'; 
	 data_in<= "UU";
	 wait for 80 ns;
	 reset<='0';
			for i in 70 downto 0 loop
            my_value <= my_hex_value(i*8+7 downto i*8);
            for j in 0 to 3 loop
                wait for 10 ns;
					 data_in(0) <= my_value(j*2);
					 data_in(1) <=my_value((j*2)+1);
					 
            end loop;
         end loop;
	
	 data_in<= "UU";
	 wait for 4000 ns;
	 reset<='1'; 
		  wait;
    END PROCESS;                                         
END tftp_filte_part_arch;


