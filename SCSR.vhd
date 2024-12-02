library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for SCSR (Serial Control and Status Register)
-- This module manages various control and status flags for UART, such as Transmitter Data Register Empty (TDRE),
-- Receiver Data Register Full (RDRF), Overrun Error (OE), and Framing Error (FE).
entity SCSR is
 Port (
    CLK: in std_logic;                           -- Clock input
    TDREin, RDRFin, OEin, FEin: in std_logic;    -- Input signals for TDRE, RDRF, Overrun Error (OE), and Framing Error (FE)
    TDREload, RDRFload, OEload, FEload: in std_logic; -- Load signals for respective flags
    TDREout, RDRFout: out std_logic;             -- Outputs for TDRE and RDRF status flags
    SCSRout: out std_logic_vector(7 downto 0)    -- 8-bit output containing the status of all flags
 );
end SCSR;

-- Architecture definition
architecture struct of SCSR is
    -- Internal signal to hold the outputs of all 8 flip-flops
    signal signalENDFF: std_logic_vector(7 downto 0);
begin
    -- Flip-flop for the Framing Error (FE) flag
    FE: entity work.ENDFF(struct)
        port map(
            FEin,       -- Input for Framing Error
            FEload,     -- Load signal for Framing Error
            CLK,        -- Clock signal
            signalENDFF(0) -- Output connected to the first bit of signalENDFF
        );

    -- Flip-flop for the Overrun Error (OE) flag
    OE: entity work.ENDFF(struct)
        port map(
            OEin,       -- Input for Overrun Error
            OEload,     -- Load signal for Overrun Error
            CLK,        -- Clock signal
            signalENDFF(1) -- Output connected to the second bit of signalENDFF
        );

    -- Unused bits of the register (set to '0')
    ENDFF_2: entity work.ENDFF(struct)
        port map(
            '0',        -- Fixed input of '0'
            '0',        -- Fixed load signal of '0'
            CLK,        -- Clock signal
            signalENDFF(2) -- Output connected to the third bit of signalENDFF
        );
    ENDFF_3: entity work.ENDFF(struct)
        port map(
            '0', '0', CLK, signalENDFF(3)
        );
    ENDFF_4: entity work.ENDFF(struct)
        port map(
            '0', '0', CLK, signalENDFF(4)
        );
    ENDFF_5: entity work.ENDFF(struct)
        port map(
            '0', '0', CLK, signalENDFF(5)
        );

    -- Flip-flop for the Receiver Data Register Full (RDRF) flag
    RDRF: entity work.ENDFF(struct)
        port map(
            RDRFin,     -- Input for RDRF
            RDRFload,   -- Load signal for RDRF
            CLK,        -- Clock signal
            signalENDFF(6) -- Output connected to the seventh bit of signalENDFF
        );

    -- Flip-flop for the Transmitter Data Register Empty (TDRE) flag
    TDRE: entity work.ENDFF(struct)
        port map(
            TDREin,     -- Input for TDRE
            TDREload,   -- Load signal for TDRE
            CLK,        -- Clock signal
            signalENDFF(7) -- Output connected to the eighth bit of signalENDFF
        );

    -- Assign the internal signal to the output port
    SCSRout <= signalENDFF;                      -- Connect the full 8-bit status register to the output
    TDREout <= signalENDFF(7);                   -- Connect the TDRE status bit to the TDREout output
    RDRFout <= signalENDFF(6);                   -- Connect the RDRF status bit to the RDRFout output

end struct;
