library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for AddressDecoder
entity AddressDecoder is
 Port (
    CLK: in std_logic;                               -- Clock signal
    ADDR: in std_logic_vector(1 downto 0);           -- Address input to select registers
    R, UARTselect: in std_logic;                     -- R: Read signal, UARTselect: UART enable signal
    RDRout, SCSRout, SCCRout: in std_logic_vector(7 downto 0); -- Outputs from registers
    DATA_BUS_IN: in std_logic_vector(7 downto 0);    -- Input data bus
    DATA_BUS_OUT: out std_logic_vector(7 downto 0);  -- Output data bus
    AD_TDRload, AD_SCCRload: out std_logic;          -- Load signals for TDR and SCCR
    AD_TDRin, AD_SCCRin: out std_logic_vector(7 downto 0); -- Data inputs for TDR and SCCR
    AD_TDREload, AD_TDREin: out std_logic;           -- Load and input signals for TDRE
    AD_RDRFload, AD_RDRFin: out std_logic            -- Load and input signals for RDRF
 );
end AddressDecoder;

-- Architecture definition
architecture struct of AddressDecoder is
    signal MUX1out: std_logic_vector(7 downto 0);    -- Intermediate signal for first multiplexer

begin
    -- First multiplexer: Select between RDRout and SCSRout based on ADDR(0)
    MUX1: entity work.two_one_mux_8b(struct)
        port map(
            RDRout,         -- Input option 1
            SCSRout,        -- Input option 2
            ADDR(0),        -- Select signal
            MUX1out         -- Output
        );

    -- Second multiplexer: Select between MUX1out and SCCRout based on ADDR(1)
    MUX2: entity work.two_one_mux_8b(struct)
        port map(
            MUX1out,        -- Input option 1
            SCCRout,        -- Input option 2
            ADDR(1),        -- Select signal
            DATA_BUS_OUT    -- Output to data bus
        );

    -- Load signal for TDR: Active when ADDR = "00", write operation, and UART is selected
    AD_TDRload <= (not ADDR(1) and not ADDR(0) and not R and UARTselect);

    -- Load signal for SCCR: Active when ADDR = "10", write operation, and UART is selected
    AD_SCCRload <= (ADDR(1) and not R and UARTselect);

    -- Input data for TDR and SCCR: Forwarded from DATA_BUS_IN
    AD_TDRin <= DATA_BUS_IN;
    AD_SCCRin <= DATA_BUS_IN;

    -- Load signal for TDRE: Active when ADDR = "00" and write operation
    AD_TDREload <= (not ADDR(1) and not ADDR(0) and not R);

    -- Input signal for TDRE: Constant '0'
    AD_TDREin <= '0';

    -- Load signal for RDRF: Active when ADDR = "00" and read operation
    AD_RDRFload <= (not ADDR(1) and not ADDR(0) and R);

    -- Input signal for RDRF: Constant '0'
    AD_RDRFin <= '0';

end struct;
