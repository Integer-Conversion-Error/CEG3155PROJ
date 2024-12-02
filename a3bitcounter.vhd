library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for a 3-bit counter (a3bitcounter)
-- This counter increments its value on the rising edge of Clk when En is asserted.
entity a3bitcounter is
    Port ( 
        En : in STD_LOGIC;                       -- Enable signal
        Clk : in STD_LOGIC;                      -- Clock signal
        Reset : in STD_LOGIC;                    -- Reset signal
        Count : out STD_LOGIC_VECTOR(2 downto 0) -- 3-bit counter output
    );
end a3bitcounter;

-- Architecture definition
architecture Structural of a3bitcounter is

    -- Internal signals
    signal Din : std_logic_vector(2 downto 0);      -- Next state of the counter
    signal countout : std_logic_vector(2 downto 0); -- Current counter value

begin

    -- Logic for determining the next state of each bit in the counter
    Din(2) <= countout(2) xor (countout(1) and countout(0)); -- XOR logic for bit 2
    Din(1) <= countout(1) xor countout(0);                  -- XOR logic for bit 1
    Din(0) <= not countout(0);                              -- NOT logic for bit 0

    -- Flip-flop instances for each bit of the counter
    D2 : entity work.enARdFF_2(struct)
        port map(Reset, Din(2), En, Clk, countout(2));       -- Flip-flop for bit 2
    D1 : entity work.enARdFF_2(struct)
        port map(Reset, Din(1), En, Clk, countout(1));       -- Flip-flop for bit 1
    D0 : entity work.enARdFF_2(struct)
        port map(Reset, Din(0), En, Clk, countout(0));       -- Flip-flop for bit 0

    -- Assign the internal counter value to the output
    Count(2) <= countout(2);                                -- Output bit 2
    Count(1) <= countout(1);                                -- Output bit 1
    Count(0) <= countout(0);                                -- Output bit 0

end Structural;
