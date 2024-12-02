library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for a 12-bit left shift register (LShiftReg_12b)
-- The register can perform a left shift operation or load a new value based on the SHIFTL signal.
entity LShiftReg_12b is
    port(
        LOAD, SHIFTL, CLK: in std_logic;               -- LOAD: Enable signal for loading data
                                                      -- SHIFTL: Select signal for shifting or loading
                                                      -- CLK: Clock signal
        INPUT: in std_logic_vector(11 downto 0);      -- 12-bit input data
        OUTPUT: out std_logic_vector(11 downto 0)     -- 12-bit output data
    );
end LShiftReg_12b;

-- Architecture definition
architecture struct OF LShiftReg_12b is

    -- Internal signals
    signal signalENDFF: std_logic_vector(11 downto 0); -- Stores the outputs of the flip-flops
    signal signalMUX: std_logic_vector(11 downto 0);   -- Stores the selected input (shifted or loaded data)
    signal signalQshift: std_logic_vector(11 downto 0); -- Shifted version of the register contents

begin
    -- Left shift operation logic
    -- Shift all bits left by one position
    signalQshift(11 downto 1) <= signalENDFF(10 downto 0); -- Shift bits 10 downto 0 to 11 downto 1
    signalQshift(0) <= '0';                                -- Set the least significant bit to '0'

    -- Flip-flop instances for each bit
    -- Each flip-flop stores one bit of the register
    ENDFF_0: entity work.ENDFF(struct)
        port map(signalMUX(0), LOAD, CLK, signalENDFF(0));
    ENDFF_1: entity work.ENDFF(struct)
        port map(signalMUX(1), LOAD, CLK, signalENDFF(1));
    ENDFF_2: entity work.ENDFF(struct)
        port map(signalMUX(2), LOAD, CLK, signalENDFF(2));
    ENDFF_3: entity work.ENDFF(struct)
        port map(signalMUX(3), LOAD, CLK, signalENDFF(3));
    ENDFF_4: entity work.ENDFF(struct)
        port map(signalMUX(4), LOAD, CLK, signalENDFF(4));
    ENDFF_5: entity work.ENDFF(struct)
        port map(signalMUX(5), LOAD, CLK, signalENDFF(5));
    ENDFF_6: entity work.ENDFF(struct)
        port map(signalMUX(6), LOAD, CLK, signalENDFF(6));
    ENDFF_7: entity work.ENDFF(struct)
        port map(signalMUX(7), LOAD, CLK, signalENDFF(7));
    ENDFF_8: entity work.ENDFF(struct)
        port map(signalMUX(8), LOAD, CLK, signalENDFF(8));
    ENDFF_9: entity work.ENDFF(struct)
        port map(signalMUX(9), LOAD, CLK, signalENDFF(9));
    ENDFF_10: entity work.ENDFF(struct)
        port map(signalMUX(10), LOAD, CLK, signalENDFF(10));
    ENDFF_11: entity work.ENDFF(struct)
        port map(signalMUX(11), LOAD, CLK, signalENDFF(11));
    
    -- Multiplexer for selecting between shift or load operation
    -- INPUT is selected when SHIFTL = '0'
    -- Left-shifted value (signalQshift) is selected when SHIFTL = '1'
    two_one_mux_12b: entity work.two_one_mux_12b(struct)
        port map(
            INPUT,           -- Input data
            signalQshift,    -- Shifted data
            SHIFTL,          -- Select signal
            signalMUX        -- Output to flip-flops
        );

    -- Connect the internal flip-flop outputs to the module output
    OUTPUT <= signalENDFF;

end struct;
