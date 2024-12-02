library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for counter_transmitterFSM
-- This module implements a counter for the transmitter FSM. The counter can either load a predefined value
-- or increment its value based on control signals.
entity counter_transmitterFSM is
    Port (
        CTRload, CTRinc, CLK: in std_logic;        -- Inputs:
                                                  -- CTRload: Load signal to initialize the counter
                                                  -- CTRinc: Increment signal to shift the counter left
                                                  -- CLK: Clock signal
        c: out std_logic                          -- Output:
                                                  -- c: The most significant bit (MSB) of the counter
    );
end counter_transmitterFSM;

-- Architecture definition
architecture struct of counter_transmitterFSM is

    -- Internal signal to store the 8-bit counter value
    signal COUNT: std_logic_vector(7 downto 0);

begin

    -- Counter logic
    -- The counter is implemented using the LShiftReg_8b module, which supports loading a predefined value or shifting left.
    counter: entity work.LshiftReg_8b(struct)
        port map(
            CTRload,        -- Load signal to initialize the counter
            CTRinc,         -- Increment (left shift) signal
            CLK,            -- Clock signal
            "11111111",     -- Input value to load into the counter (all bits set to 1)
            COUNT           -- Output 8-bit counter value
        );

    -- Output logic
    -- Assign the most significant bit (MSB) of the counter (COUNT(7)) to the output `c`
    c <= COUNT(7);

end struct;
