LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY tftp_filte_part_vhd_tst IS
END tftp_filte_part_vhd_tst;

ARCHITECTURE tftp_filte_part_arch OF tftp_filte_part_vhd_tst IS
    -- constants

    -- signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL data_in : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
    SIGNAL data_out : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL reset : STD_LOGIC := '0';
	  signal hex_str : std_logic_vector(7)

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
     	
		wait for 5 ns;
		
		wait for 5 ns;
    END PROCESS;
	 

END tftp_filte_part_arch;
