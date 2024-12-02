library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for the UART module
entity UART is
 Port (
    Greset, CLK: in std_logic;                        -- Global reset and clock input
    RxD, UARTselect, R: in std_logic;                -- UART input signals: RxD (receiver data), UARTselect (selection signal), and R (read signal)
    ADDR: in std_logic_vector(1 downto 0);           -- Address input for register selection
    DATA_BUS_IN: in std_logic_vector(7 downto 0);    -- Data bus input (8-bit data to be written to the UART)
    DATA_BUS_OUT: out std_logic_vector(7 downto 0);  -- Data bus output (8-bit data read from the UART)
    TxD: out std_logic;                              -- Transmitter output data
    IRQ: out std_logic_vector(1 downto 0)            -- Interrupt request lines
 );
end UART;

-- Architecture definition for the UART module
architecture struct of UART is

    -- Internal signals for various subsystems
    signal BCLK, BCLKx8: std_logic;                                  -- Baud clock and 8x baud clock
    signal BRGSEL: std_logic_vector(2 downto 0);                     -- Baud rate generator selection
    signal RDRout, SCSRout, SCCRout: std_logic_vector(7 downto 0);   -- Outputs of RDR, SCSR, and SCCR registers
    signal AD_TDRload, AD_SCCRload: std_logic;                       -- Address decoder load signals for TDR and SCCR
    signal AD_TDRin, AD_SCCRin: std_logic_vector(7 downto 0);        -- Data inputs for TDR and SCCR from address decoder
    signal AD_TDREload, AD_TDREin: std_logic;                        -- Address decoder signals for TDRE register
    signal AD_RDRFload, AD_RDRFin: std_logic;                        -- Address decoder signals for RDRF register
    signal TDREload, TDREin, RDRFload, RDRFin,                      -- Signals for transmitter and receiver register control
           OEin, FEin, OEload, FEload, TDREout, RDRFout: std_logic; -- Signals for overrun error and framing error handling

    signal TC_TDREload: std_logic;                                   -- Transmitter control signal for TDRE load
    signal TC_TDREin: std_logic;                                     -- Transmitter control signal for TDRE input
    signal RC_RDRFload: std_logic;                                   -- Receiver control signal for RDRF load
    signal RC_RDRFin: std_logic;                                     -- Receiver control signal for RDRF input

    signal TIE, RIE: std_logic;                                      -- Transmitter and Receiver interrupt enables
begin

    -- SCCR: Serial Control and Configuration Register
    SCCR: entity work.SCCR(struct)
        port map(
            CLK, AD_SCCRin, AD_SCCRload, SCCRout, BRGSEL, TIE, RIE
        );

    -- SCSR: Serial Control and Status Register
    SCSR: entity work.SCSR(struct)
        port map(
            BCLKx8, TDREin, RDRFin, OEin, FEin, TDREload, RDRFload, 
            OEload, FEload, TDREout, RDRFout, SCSRout
        );

    -- SCSRcontrol: Control logic for the SCSR register
    SCSRcontrol: entity work.SCSRcontrol(struct)
        port map(
            UARTselect, TC_TDREload, AD_TDREload, TC_TDREin, AD_TDREin, 
            RC_RDRFload, AD_RDRFload, RC_RDRFin, AD_RDRFin, TDREload, 
            TDREin, RDRFload, RDRFin
        );

    -- Baud Rate Generator
    BaudRateGen: entity work.bodegen(Structural)
        port map(
            Greset, CLK, BRGSEL, BCLK, BCLKx8
        );

    -- Address Decoder
    AD: entity work.AddressDecoder(struct)
        port map(
            CLK, ADDR, R, UARTselect, RDRout, SCSRout, SCCRout, 
            DATA_BUS_IN, DATA_BUS_OUT, AD_TDRload, AD_SCCRload, 
            AD_TDRin, AD_SCCRin, AD_TDREload, AD_TDREin, 
            AD_RDRFload, AD_RDRFin
        );

    -- Transmitter module
    Transmitter: entity work.Transmitter(struct)
        port map(
            Greset, BCLK, UARTselect, AD_TDRload, TDREout, 
            AD_TDRin, TxD, TC_TDREload, TC_TDREin
        );

    -- Receiver module
    Receiver: entity work.Receiver(struct)
        port map(
            Greset, BCLKx8, RxD, RDRFout, RC_RDRFload, 
            RC_RDRFin, FEload, FEin, OEload, OEin, RDRout
        );

    -- Interrupt Generator
    interrupt_gen: entity work.interrupt_gen(struct)
        port map(
            TIE, RIE, RDRFout, SCSRout(1), TDREout, IRQ
        );

end struct;
