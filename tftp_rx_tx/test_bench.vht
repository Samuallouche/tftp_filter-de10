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
-- Generated on "02/01/2024 10:24:04"
                                                            
-- Vhdl Test Bench template for design  :  top_rmii
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY top_rmii_vhd_tst IS
END top_rmii_vhd_tst;
ARCHITECTURE top_rmii_arch OF top_rmii_vhd_tst IS
-- constants                                                 
-- signals

signal my_hex_value : std_logic_vector(623 downto 0) := X"0000000000000055555555555555555513ff8dd78b43000bbe189a4008004500003000000000ff113965c0a800fdc0a8000ac5ba0045001c3e200001726663313335302e747874006f6374657400";
    signal my_value : std_logic_vector(7 downto 0);                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL crs : STD_LOGIC;
SIGNAL rx_d : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL rx_er : STD_LOGIC;
SIGNAL tx_d : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL tx_en : STD_LOGIC;
COMPONENT top_rmii
	PORT (
	clk : IN STD_LOGIC;
	crs : IN STD_LOGIC;
	rx_d : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	rx_er : IN STD_LOGIC;
	tx_d : BUFFER STD_LOGIC_VECTOR(1 DOWNTO 0);
	tx_en : BUFFER STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : top_rmii
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	crs => crs,
	rx_d => rx_d,
	rx_er => rx_er,
	tx_d => tx_d,
	tx_en => tx_en
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
wait for 70  ns;    
 crs<='1';
 wait for 3000 ns;
 crs<='0';
 wait for 10 ns;
 crs<='1';
 wait for 10 ns;
 crs<='0';
 wait for 10 ns;
 crs<='1';
 wait for 10 ns;
 crs<='0';
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
					 rx_d(0) <= my_value(j*2);
					 rx_d(1) <=my_value((j*2)+1);
					  wait for 40 ns;
            end loop;
         end loop;         
	WAIT;                                                                                                               
END PROCESS ;                                         
END top_rmii_arch;
