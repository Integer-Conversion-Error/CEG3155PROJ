library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for CLKcounter
-- This module implements a 12-bit counter controlled by input signals. The counter can load different values
-- based on the CTRSEL signal or increment its value with the CTRinc signal.
entity CLKcounter is
    Port (
        CTRload, CTRinc, CTRSEL, CLK: in std_logic;        -- Inputs:
                                                          -- CTRload: Load signal to initialize the counter
                                                          -- CTRinc: Increment signal to shift the counter
                                                          -- CTRSEL: Select signal to choose the initial load value
                                                          -- CLK: Clock signal
        c: out std_logic                                   -- Output:
                                                          -- c: The most significant bit (MSB) of the counter
    );
end CLKcounter;

-- Architecture definition
architecture struct of CLKcounter is

    -- Internal signals
    signal muxout: std_logic_vector(11 downto 0);         -- Output of the multiplexer (selected load value)
    signal COUNT: std_logic_vector(11 downto 0);          -- Internal signal to store the 12-bit counter value

begin

    -- Counter logic
    -- The counter is implemented using the LShiftReg_12b module, which supports loading a value or shifting left.
    counter: entity work.LShiftReg_12b(struct)
        port map(
            CTRload,         -- Load signal to initialize the counter
            CTRinc,          -- Increment (left shift) signal
            CLK,             -- Clock signal
            muxout,          -- Input value selected by the multiplexer
            COUNT            -- Output 12-bit counter value
        );

    -- Multiplexer logic
    -- Select between two different initial values based on the CTRSEL signal
    mux: entity work.two_one_mux_12b(struct)
        port map(
            "111111000000",  -- Option 1: Load value (e.g., 0xFC0)
            "111111111110",  -- Option 2: Load value (e.g., 0xFFE)
            CTRSEL,          -- Select signal to choose between the two options
            muxout           -- Selected value output to the counter
        );

    -- Output logic
    -- Assign the most significant bit (MSB) of the counter to the output `c`
    c <= COUNT(11);

end struct;
