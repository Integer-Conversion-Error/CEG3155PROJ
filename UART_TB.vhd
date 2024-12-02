library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_TB is
end UART_TB;

architecture Behavioral of UART_TB is
    signal CLK: std_logic;
    signal Greset: std_logic := '0';
    signal RxD: std_logic := '1';
    signal UARTselect: std_logic := '0';
    signal R: std_logic := '0';
    signal ADDR: std_logic_vector(1 downto 0) := "00";
    signal DATA_IN: std_logic_vector(7 downto 0) := "01110110";
    signal DATA_OUT: std_logic_vector(7 downto 0);
    signal TxD: std_logic;
    signal IRQ: std_logic_vector(1 downto 0);
begin
    -- clock
    CLK_process: process is
        begin
    
            CLK <= '0';
            wait for 50 ns;
            CLK <= '1';
            wait for 50 ns;
        end process;
        
    RxD <= TxD after 1.6 us;    
    
     UART: entity work.UART(struct)
        port map(Greset, CLK, RxD, UARTselect, R, ADDR, DATA_IN, DATA_OUT, TxD, IRQ);

end Behavioral;
