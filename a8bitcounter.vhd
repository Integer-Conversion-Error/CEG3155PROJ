library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for an 8-bit counter (a8bitcounter)
-- This counter increments its value on the rising edge of Clk when En is asserted.
entity a8bitcounter is
    Port ( 
        En : in STD_LOGIC;                       -- Enable signal
        Clk : in STD_LOGIC;                      -- Clock signal
        Reset : in STD_LOGIC;                    -- Reset signal
        Count : out STD_LOGIC_Vector(7 downto 0) -- 8-bit counter output
    );
end a8bitcounter;

-- Architecture definition
architecture Structural of a8bitcounter is

    -- Internal signals
    signal countout : std_logic_vector(7 downto 0); -- Current count value
    signal Din : std_logic_vector(7 downto 0);      -- Next state of the counter

begin

    -- Logic for determining the next state of each bit in the counter
    Din(7) <= countout(7) xor (countout(6) and countout(5) and countout(4) and countout(3) and countout(2) and countout(1) and countout(0));
    Din(6) <= countout(6) xor (countout(5) and countout(4) and countout(3) and countout(2) and countout(1) and countout(0));
    Din(5) <= countout(5) xor (countout(4) and countout(3) and countout(2) and countout(1) and countout(0));
    Din(4) <= countout(4) xor (countout(3) and countout(2) and countout(1) and countout(0));
    Din(3) <= countout(3) xor (countout(2) and countout(1) and countout(0));
    Din(2) <= countout(2) xor (countout(1) and countout(0));
    Din(1) <= countout(1) xor countout(0);
    Din(0) <= not countout(0);

    -- Flip-flop instances for each bit of the counter
    D7 : entity work.enARdFF_2(struct)
        port map(Reset, Din(7), En, Clk, countout(7));
    D6 : entity work.enARdFF_2(struct)
        port map(Reset, Din(6), En, Clk, countout(6));
    D5 : entity work.enARdFF_2(struct)
        port map(Reset, Din(5), En, Clk, countout(5));
    D4 : entity work.enARdFF_2(struct)
        port map(Reset, Din(4), En, Clk, countout(4));
    D3 : entity work.enARdFF_2(struct)
        port map(Reset, Din(3), En, Clk, countout(3));
    D2 : entity work.enARdFF_2(struct)
        port map(Reset, Din(2), En, Clk, countout(2));
    D1 : entity work.enARdFF_2(struct)
        port map(Reset, Din(1), En, Clk, countout(1));
    D0 : entity work.enARdFF_2(struct)
        port map(Reset, Din(0), En, Clk, countout(0));

    -- Assign the internal counter value to the output
    Count <= countout;

end Structural;
