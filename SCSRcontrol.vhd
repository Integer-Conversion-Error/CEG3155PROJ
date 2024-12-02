library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for SCSRcontrol
-- This module controls the signals for Transmitter Data Register Empty (TDRE) and Receiver Data Register Full (RDRF).
-- It uses multiplexers to select between signals based on the UARTselect input.
entity SCSRcontrol is
 Port (
    UARTselect: in std_logic;                        -- Selection signal for UART mode (1 = UART operation, 0 = Test Controller operation)
    TC_TDREload, AD_TDREload: in std_logic;          -- Load signals for TDRE (from Test Controller and Address Decoder)
    TC_TDREin, AD_TDREin: in std_logic;              -- Input signals for TDRE (from Test Controller and Address Decoder)
    RC_RDRFload, AD_RDRFload: in std_logic;          -- Load signals for RDRF (from Receiver Controller and Address Decoder)
    RC_RDRFin, AD_RDRFin: in std_logic;              -- Input signals for RDRF (from Receiver Controller and Address Decoder)
    TDREload, TDREin: out std_logic;                 -- Output load and input signals for TDRE
    RDRFload, RDRFin: out std_logic                  -- Output load and input signals for RDRF
 );
end SCSRcontrol;

-- Architecture definition
architecture struct of SCSRcontrol is
begin
    -- MUX1: Selects between Test Controller and Address Decoder load signal for TDRE
    MUX1: entity work.two_one_mux(struct)
        port map(
            TC_TDREload,   -- Input from Test Controller
            AD_TDREload,   -- Input from Address Decoder
            UARTselect,    -- Select signal (UART mode or Test Controller mode)
            TDREload       -- Output to TDRE load
        );

    -- MUX2: Selects between Test Controller and Address Decoder input signal for TDRE
    MUX2: entity work.two_one_mux(struct)
        port map(
            TC_TDREin,     -- Input from Test Controller
            AD_TDREin,     -- Input from Address Decoder
            UARTselect,    -- Select signal
            TDREin         -- Output to TDRE input
        );

    -- MUX3: Selects between Receiver Controller and Address Decoder load signal for RDRF
    MUX3: entity work.two_one_mux(struct)
        port map(
            RC_RDRFload,   -- Input from Receiver Controller
            AD_RDRFload,   -- Input from Address Decoder
            UARTselect,    -- Select signal
            RDRFload       -- Output to RDRF load
        );

    -- MUX4: Selects between Receiver Controller and Address Decoder input signal for RDRF
    MUX4: entity work.two_one_mux(struct)
        port map(
            RC_RDRFin,     -- Input from Receiver Controller
            AD_RDRFin,     -- Input from Address Decoder
            UARTselect,    -- Select signal
            RDRFin         -- Output to RDRF input
        );
end struct;
