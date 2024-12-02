library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for an 8-bit Input Register with Arithmetic Right Shift (IN_reg_8b_ar_sh)
-- This register supports an arithmetic right shift or loading a new value based on the SHIFTR signal.
entity IN_reg_8b_ar_sh is
    Port (
        LOAD, SHIFTR, CLK, ASin: in std_logic;             -- LOAD: Enable signal for loading data
                                                          -- SHIFTR: Select signal for shifting or loading
                                                          -- CLK: Clock signal
                                                          -- ASin: Arithmetic Shift Input for MSB (sign extension)
        INPUT: in std_logic_vector(7 downto 0);           -- 8-bit input data
        OUTPUT: out std_logic_vector(7 downto 0)          -- 8-bit output data
    );
end IN_reg_8b_ar_sh;

-- Architecture definition
architecture struct of IN_reg_8b_ar_sh is

    -- Internal signals
    signal signalENDFF: std_logic_vector(7 downto 0);     -- Stores the outputs of the flip-flops
    signal signalMUX: std_logic_vector(7 downto 0);       -- Stores the selected input (shifted or loaded data)
    signal signalQshift: std_logic_vector(7 downto 0);       -- Signal for the right-shifted version of the register contents
begin

    -- Arithmetic Right Shift Logic
    -- Shift all bits right by one position
    -- The most significant bit (MSB) is filled with ASin (used for sign extension)
    signalQshift(6 downto 0) <= signalENDFF(7 downto 1);  -- Shift bits 7 downto 1 to 6 downto 0
    signalQshift(7) <= ASin;                              -- Assign ASin to the most significant bit (MSB)

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
    
    -- Multiplexer for selecting between shift or load operation
    -- INPUT is selected when SHIFTR = '0'
    -- Arithmetic right-shifted value (signalQshift) is selected when SHIFTR = '1'
    two_one_mux_8b: entity work.two_one_mux_8b(struct)
        port map(
            INPUT,           -- Input data
            signalQshift,    -- Shifted data
            SHIFTR,          -- Select signal
            signalMUX        -- Output to flip-flops
        );
    
    -- Connect the internal flip-flop outputs to the module output
    OUTPUT <= signalENDFF;

end struct;
