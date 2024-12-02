library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for the Transmitter module
entity Transmitter is
    Port (
        Greset, CLK: in std_logic;                         -- Global reset and clock input
        UARTselect, TDRload, TDRE: in std_logic;           -- UART select, TDR load signal, and transmitter data register empty flag
        TDRin: in std_logic_vector(7 downto 0);            -- 8-bit input data to be transmitted
        TxD: out std_logic;                                -- Transmitter serial data output
        TDREload, TDREin: out std_logic                    -- Output signals for controlling the TDRE register
    );
end Transmitter;

-- Architecture definition for the Transmitter module
architecture struct of Transmitter is

    -- Internal signals for connecting subcomponents
    signal TDRout, TSRout: std_logic_vector(7 downto 0);   -- Outputs of the TDR and TSR registers
    signal TxDFFload, TxDFFset, TxDFFSEL: std_logic;       -- Signals for controlling the TxD flip-flop
    signal TSRload, TSRshiftR, TSRshiftout: std_logic;     -- Signals for controlling the TSR register
    signal TxDFFMUXout: std_logic;                        -- Output of the multiplexer feeding the TxD flip-flop

begin
    -- Transmitter Data Register (TDR)
    -- Stores the 8-bit data to be transmitted
    TDR: entity work.Reg_8b(struct)
        port map(
            TDRload,            -- Load signal for TDR
            CLK,                -- Clock input
            TDRin,              -- 8-bit input data
            TDRout              -- 8-bit output data from TDR
        );

    -- Transmitter Shift Register (TSR)
    -- Shifts out the data serially for transmission
    TSR: entity work.reg_8b_ar_sh(struct)
        port map(
            TSRload,            -- Load signal for TSR
            TSRshiftR,          -- Shift right signal for TSR
            CLK,                -- Clock input
            TDRout,             -- Input data from TDR
            TSRout,             -- 8-bit output data from TSR
            TSRshiftout         -- Serial output bit from TSR
        );

    -- 2-to-1 Multiplexer for TxD Flip-Flop Input
    -- Selects between the TSR output and a set signal for the TxD flip-flop
    TxDFFMUX: entity work.two_one_mux(struct)
        port map(
            TxDFFset,           -- Set signal input for the multiplexer
            TSRshiftout,        -- Serial data from TSR
            TxDFFSEL,           -- Select signal for the multiplexer
            TxDFFMUXout         -- Output of the multiplexer
        );

    -- TxD Flip-Flop
    -- Holds the serial data to be transmitted on the TxD line
    TxDFF: entity work.ENDFF(struct)
        port map(
            TxDFFMUXout,        -- Input data for the flip-flop
            TxDFFload,          -- Load signal for the flip-flop
            CLK,                -- Clock input
            TxD                -- Serial output data
        );

    -- Controller
    -- Handles the control logic for the transmitter
    Controller: entity work.tx_controller(struct)
        port map(
            Greset,             -- Global reset
            CLK,                -- Clock input
            UARTselect,         -- UART select signal
            TDRE,               -- Transmitter Data Register Empty flag
            TDREload,           -- TDRE load signal output
            TDREin,             -- TDRE input signal output
            TxDFFload,          -- TxD flip-flop load signal
            TxDFFset,           -- TxD flip-flop set signal
            TxDFFSEL,           -- TxD flip-flop multiplexer select signal
            TSRload,            -- TSR load signal
            TSRshiftR           -- TSR shift right signal
        );

end struct;
