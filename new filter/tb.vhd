-- Copyright (C) 2023  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "03/14/2024 19:04:03"
                                                            
-- Vhdl Test Bench template for design  :  test_filter
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY test_filter_vhd_tst IS
END test_filter_vhd_tst;
ARCHITECTURE test_filter_arch OF test_filter_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL data_in : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL data_out : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL reset : STD_LOGIC;
SIGNAL tx_en_in : STD_LOGIC;
SIGNAL tx_en_out : STD_LOGIC;
signal my_hex_value : std_logic_vector(559 downto 0) := X"ffffffffffffffff00508dd78b43000bbe189a4008004500003000000000ff113965c0a800fdc0a8000ac5ba0045001c3e200001726663313335302e747874006f6374657400";
 signal my_value : std_logic_vector(7 downto 0);
 signal cnt_bus               : integer:= 0;
 signal bus_temp              : std_logic_vector(7 downto 0);
COMPONENT test_filter
	PORT (
	clk : IN STD_LOGIC;
	data_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	data_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	reset : IN STD_LOGIC;
	tx_en_in : IN STD_LOGIC;
	tx_en_out : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : test_filter
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	data_in => data_in,
	data_out => data_out,
	reset => reset,
	tx_en_in => tx_en_in,
	tx_en_out => tx_en_out
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
	 tx_en_in<='0'; 
	 data_in<= "00";
	 wait for 80 ns;
			for i in 69 downto 0 loop
            my_value <= my_hex_value(i*8+7 downto i*8);
            for j in 0 to 3 loop
				wait for 10 ns;
					 data_in(0) <= my_value(j*2);
					 data_in(1) <=my_value((j*2)+1);
					 tx_en_in<='1';

            end loop;
         end loop;
	 data_in<= "00";
	 tx_en_in<='0'; 
	 wait for 40000 ns;
	 tx_en_in<='0'; 
	 data_in<= "00";
	 wait for 80 ns;
			for i in 69 downto 0 loop
            my_value <= my_hex_value(i*8+7 downto i*8);
            for j in 0 to 3 loop
				wait for 10 ns;
					 data_in(0) <= my_value(j*2);
					 data_in(1) <=my_value((j*2)+1);
					 tx_en_in<='1';

            end loop;
         end loop;
	 data_in<= "00";
	 	 
	 wait for 4000 ns; 
	 tx_en_in<='0'; 
		  wait;
    END PROCESS;                                                               
END test_filter_arch;
