library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TransmitterTB is
end TransmitterTB;

architecture Behavioral of TransmitterTB is
    signal CLK: std_logic;
    signal Greset: std_logic := '1';
    signal TDR_LD: std_logic := '1';
    signal TDRE: std_logic;
    signal TDR_IN: std_logic_vector(7 downto 0) := "01110110";
    signal TxD: std_logic;
    signal TDRE_LD, TDRE_IN: std_logic;
    signal UART_SEL: std_logic := '1';
    
    signal FORCE0_TDRE: std_logic := '0';
    signal MUX_SIG: std_logic;
begin
    -- clock
    CLK_process: process is
        begin
    
            CLK <= '0';
            wait for 50 ns;
            CLK <= '1';
            wait for 50 ns;
        end process;

    FORCE0_TDRE <= '1' after 100 ns;

    transmitter: entity work.Transmitter(struct)
        port map(Greset, CLK, UART_SEL, TDR_LD, TDRE, TDR_IN, TxD, TDRE_LD, TDRE_IN);

    TDRE_reg: entity work.ENDFF(struct)
        port map(MUX_SIG, TDRE_LD, CLK, TDRE);
        
    mux: entity work.two_one_mux(struct)
        port map(TDRE_IN, '0', FORCE0_TDRE, MUX_SIG);
        

end Behavioral;
