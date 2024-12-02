library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for an 8-bit register (Reg_8b)
-- This register stores an 8-bit input value and outputs it based on the LOAD (enable) signal and CLK.
entity Reg_8b is
    port(
        LOAD, CLK: in std_logic;                          -- LOAD is the enable signal, CLK is the clock input
        INPUT: in std_logic_vector(7 downto 0);           -- 8-bit input data to be stored in the register
        OUTPUT: out std_logic_vector(7 downto 0)          -- 8-bit output data from the register
    );
end Reg_8b;

-- Architecture definition
architecture struct OF Reg_8b is

    -- Internal signal to hold the 8-bit data from the flip-flops
    signal signalENDFF: std_logic_vector(7 downto 0);

begin
    -- Instantiate 8 flip-flops (ENDFF) for each bit of the register
    -- Each flip-flop stores one bit of the INPUT vector and outputs it to signalENDFF

    ENDFF_0: entity work.ENDFF(struct)
        port map(
            INPUT(0),  -- Input bit 0
            LOAD,      -- Enable signal
            CLK,       -- Clock signal
            signalENDFF(0) -- Output bit 0
        );

    ENDFF_1: entity work.ENDFF(struct)
        port map(
            INPUT(1), LOAD, CLK, signalENDFF(1) -- Input and output for bit 1
        );

    ENDFF_2: entity work.ENDFF(struct)
        port map(
            INPUT(2), LOAD, CLK, signalENDFF(2) -- Input and output for bit 2
        );

    ENDFF_3: entity work.ENDFF(struct)
        port map(
            INPUT(3), LOAD, CLK, signalENDFF(3) -- Input and output for bit 3
        );

    ENDFF_4: entity work.ENDFF(struct)
        port map(
            INPUT(4), LOAD, CLK, signalENDFF(4) -- Input and output for bit 4
        );

    ENDFF_5: entity work.ENDFF(struct)
        port map(
            INPUT(5), LOAD, CLK, signalENDFF(5) -- Input and output for bit 5
        );

    ENDFF_6: entity work.ENDFF(struct)
        port map(
            INPUT(6), LOAD, CLK, signalENDFF(6) -- Input and output for bit 6
        );

    ENDFF_7: entity work.ENDFF(struct)
        port map(
            INPUT(7), LOAD, CLK, signalENDFF(7) -- Input and output for bit 7
        );

    -- Assign the internal signal (signalENDFF) to the OUTPUT port
    OUTPUT <= signalENDFF;

end struct;
