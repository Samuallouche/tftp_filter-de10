LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY tftp_filte_part_vhd_tst IS
END tftp_filte_part_vhd_tst;

ARCHITECTURE tftp_filte_part_arch OF tftp_filte_part_vhd_tst IS
    -- constants

    -- signals
    signal my_hex_value : std_logic_vector(495 downto 0) := X"00508dd78b43000bbe189a4008004500003000000000ff113965c0a800fdc0a8000ac5ba0045001c3e200001726663313335302e747874006f6374657400";
    signal my_value : std_logic_vector(7 downto 0);
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL data_in : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
    SIGNAL data_out : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL reset : STD_LOGIC := '0';

    -- COMPONENT declaration
    COMPONENT tftp_filte_part
        PORT (
            clk : IN STD_LOGIC;
            data_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            reset : IN STD_LOGIC
        );
    END COMPONENT;

BEGIN
    -- COMPONENT instantiation
    i1 : tftp_filte_part
        PORT MAP (
            clk => clk,
            data_in => data_in,
            data_out => data_out,
            reset => reset
        );

    -- Clock process
    PROCESS
    BEGIN  
     	clk<='1';
		wait for 5 ns;
		clk<='0';
		wait for 5 ns;
        
    END PROCESS;
	 PROCESS
    BEGIN 
     	for i in 0 to 61 loop
            my_value <= my_hex_value(i*2+1 downto i*2);
            for j in 3 downto 0 loop
                data_in <= my_value(((j*2)+1) downto (j*2) );
		        wait for 10 ns;
            end loop;
        end loop;
    END PROCESS;
END tftp_filte_part_arch;
