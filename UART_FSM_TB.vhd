library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity UART_FSM_TB is
end UART_FSM_TB;

architecture Behavioral of UART_FSM_TB is
    signal CLK: std_logic;
    signal Greset: std_logic := '0';
    signal IRQ: std_logic_vector(1 downto 0) := "00";
    signal STATE_INFORMATION: std_logic_vector(1 downto 0) := "00";
    signal DATA_IN: std_logic_vector(7 downto 0);
    signal UARTselect: std_logic;
    signal R: std_logic;
    signal ADDR: std_logic_vector(1 downto 0);
    signal DATA_OUT: std_logic_vector(7 downto 0);
    signal TxD: std_logic;
    signal RxD: std_logic := '1';
--    signal clk_1M, clk_100k, clk_10k, clk_1k, clk_100, clk_10, clk_1: std_logic;
    signal FSMCLK, UARTCLK, FSMCLKFINAL, rand: std_logic;
begin
    -- clock
    CLK_process: process is
        begin
    
            CLK <= '0';
            wait for 50 ns;
            CLK <= '1';
            wait for 50 ns;
            
            if (now >= 7000 ns) then
               RxD <= TxD;
            end if;
            
        end process;
    

           
    CLKDIV: entity work.bodegen(structural)
        port map(Greset, CLK, "000", FSMCLK, UARTCLK);
    
    CLKDIV2: entity work.bodegen(structural)
        port map(Greset, FSMCLK, "001", rand, FSMCLKFINAL);
    
    UART_FSM: entity work.UART_FSM(struct)
        port map(Greset, FSMCLKFINAL, STATE_INFORMATION, IRQ, DATA_IN, R, UARTselect, ADDR, DATA_OUT);
        
    UART: entity work.UART(struct)
        port map(Greset, UARTCLK, RxD, UARTselect, R, ADDR, DATA_OUT, DATA_IN, TxD, IRQ);

end Behavioral;
