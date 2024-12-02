library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for SCCR (Serial Control and Configuration Register)
-- This module implements an 8-bit register for UART control and configuration.
-- It outputs signals like SEL (selection bits), TIE (transmitter interrupt enable), and RIE (receiver interrupt enable).
entity SCCR is
 Port (
    CLK: in std_logic;                           -- Clock input
    SCCRin: in std_logic_vector(7 downto 0);     -- 8-bit input data for the SCCR
    SCCRload: in std_logic;                      -- Load signal to update the SCCR register
    SCCRout: out std_logic_vector(7 downto 0);   -- 8-bit output representing the SCCR register
    SELout: out std_logic_vector(2 downto 0);    -- Output representing the selection bits (bits 2 downto 0)
    TIE: out std_logic;                          -- Output for Transmitter Interrupt Enable (bit 7)
    RIE: out std_logic                           -- Output for Receiver Interrupt Enable (bit 6)
 );
end SCCR;

-- Architecture definition
architecture struct of SCCR is

    -- Internal signal to store the 8-bit register value
    signal signalENDFF: std_logic_vector(7 downto 0);

begin
    -- Flip-flops for each bit of the SCCR register
    -- Each flip-flop updates its value based on the SCCRin input, SCCRload signal, and clock edge
    
    -- SEL (Selection Bits: bits 0 to 2)
    ENDFF_0: entity work.ENDFF(struct)
        port map(
            SCCRin(0),   -- Input for bit 0
            SCCRload,    -- Load signal
            CLK,         -- Clock input
            signalENDFF(0) -- Output for bit 0
        );
    ENDFF_1: entity work.ENDFF(struct)
        port map(
            SCCRin(1), SCCRload, CLK, signalENDFF(1) -- Input and output for bit 1
        );
    ENDFF_2: entity work.ENDFF(struct)
        port map(
            SCCRin(2), SCCRload, CLK, signalENDFF(2) -- Input and output for bit 2
        );

    -- Remaining bits (3 to 7)
    ENDFF_3: entity work.ENDFF(struct)
        port map(
            SCCRin(3), SCCRload, CLK, signalENDFF(3) -- Input and output for bit 3
        );
    ENDFF_4: entity work.ENDFF(struct)
        port map(
            SCCRin(4), SCCRload, CLK, signalENDFF(4) -- Input and output for bit 4
        );
    ENDFF_5: entity work.ENDFF(struct)
        port map(
            SCCRin(5), SCCRload, CLK, signalENDFF(5) -- Input and output for bit 5
        );
    ENDFF_6: entity work.ENDFF(struct)
        port map(
            SCCRin(6), SCCRload, CLK, signalENDFF(6) -- Input and output for bit 6
        );
    ENDFF_7: entity work.ENDFF(struct)
        port map(
            SCCRin(7), SCCRload, CLK, signalENDFF(7) -- Input and output for bit 7
        );

    -- Outputs
    SCCRout <= signalENDFF;                       -- The entire 8-bit register value is assigned to SCCRout
    SELout <= signalENDFF(2 downto 0);            -- Assign bits 0 to 2 as SELout (Selection Bits)
    TIE <= signalENDFF(7);                        -- Assign bit 7 as TIE (Transmitter Interrupt Enable)
    RIE <= signalENDFF(6);                        -- Assign bit 6 as RIE (Receiver Interrupt Enable)

end struct;
