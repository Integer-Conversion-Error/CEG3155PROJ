library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for the Receiver module
-- The Receiver module handles data reception, framing error detection, and overrun error detection for UART communication.
entity Receiver is
 Port (
    Greset, CLK: in std_logic;                       -- Global reset and clock input
    RxD, RDRF: in std_logic;                         -- RxD: Serial data input, RDRF: Receiver Data Register Full flag
    RDRFload, RDRFin: out std_logic;                 -- Load and input signals for the RDRF register
    FEload, FEin: out std_logic;                     -- Load and input signals for Framing Error detection
    OEload, OEin: out std_logic;                     -- Load and input signals for Overrun Error detection
    RDRout: out std_logic_vector(7 downto 0)         -- Output from the Receiver Data Register (8-bit parallel data)
 );
end Receiver;

-- Architecture definition
architecture struct of Receiver is

    -- Internal signals
    signal RSRload, RSRshiftR, RDRload: std_logic;   -- Control signals for the Receiver Shift Register (RSR) and Data Register (RDR)
    signal RSRout: std_logic_vector(7 downto 0);     -- Output of the Receiver Shift Register

begin
    -- Receiver Data Register (RDR)
    -- This 8-bit register stores the received parallel data from the RSR.
    RDR: entity work.Reg_8b(struct)
        port map(
            RDRload,        -- Load signal for RDR
            CLK,            -- Clock signal
            RSRout,         -- Input data from the Receiver Shift Register
            RDRout          -- Parallel output data
        );

    -- Receiver Shift Register (RSR)
    -- This 8-bit shift register receives serial data (RxD) and converts it into parallel data for the RDR.
    RSR: entity work.IN_reg_8b_ar_sh(struct)
        port map(
            RSRload,        -- Load signal for the RSR
            RSRshiftR,      -- Shift right signal for the RSR
            CLK,            -- Clock signal
            RxD,            -- Serial data input (RxD)
            "00000000",     -- Initial value for the RSR (reset state)
            RSRout          -- Parallel output data
        );

    -- Receiver Controller
    -- The controller manages the operation of the RSR and RDR, as well as error detection (Framing Error and Overrun Error).
    Controller: entity work.rx_controller(struct)
        port map(
            Greset,         -- Global reset
            CLK,            -- Clock signal
            RxD,            -- Serial data input (RxD)
            RDRF,           -- Receiver Data Register Full flag
            RSRload,        -- Load signal for the RSR
            RSRshiftR,      -- Shift right signal for the RSR
            RDRload,        -- Load signal for the RDR
            RDRFload,       -- Load signal for the RDRF register
            RDRFin,         -- Input signal for the RDRF register
            FEload,         -- Load signal for the Framing Error detection
            FEin,           -- Input signal for the Framing Error detection
            OEload,         -- Load signal for the Overrun Error detection
            OEin            -- Input signal for the Overrun Error detection
        );

end struct;
