library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for UART_FSM
-- This FSM manages state transitions and outputs based on state information and interrupts.
entity UART_FSM is
    Port (
        Greset, CLK: in std_logic;                                -- Global reset and clock input
        STATE_INFORMATION, IRQ: in std_logic_vector(1 downto 0); -- State and interrupt information inputs
        DATA_IN: in std_logic_vector(7 downto 0);                -- Input data
        R, UARTselect: out std_logic;                            -- Read signal and UART selection output
        ADDR: out std_logic_vector(1 downto 0);                  -- Address output
        DATA_OUT: out std_logic_vector(7 downto 0)               -- Data output
    );
end UART_FSM;

-- Architecture definition
architecture struct of UART_FSM is

    -- Internal signals for character definitions
    signal charM, charMcolor, charUnderscore, charS, charScolor, charg, chary, charr, charNewline, SCCRinit: std_logic_vector(7 downto 0);

    -- Signals for state information and FSM logic
    signal SI_load, SI0out, SI1out: std_logic;
    signal CHARSEL: std_logic_vector(2 downto 0);
    signal newStateCheck: std_logic;
    signal Y15_i, Y14_i, Y13_i, Y12_i, Y11_i, Y10_i, Y9_i, Y8_i, Y7_i, Y6_i, Y5_i, Y4_i, Y3_i, Y2_i, Y1_i, Y0_i: std_logic;
    signal y15, y14, y13, y12, y11, y10, y9, y8, y7, y6, y5, y4, y3, y2, y1, y0: std_logic;
    signal y15Bar, y14Bar, y13Bar, y12Bar, y11Bar, y10Bar, y9Bar, y8Bar, y7Bar, y6Bar, y5Bar, y4Bar, y3Bar, y2Bar, y1Bar, y0Bar: std_logic;
    signal resetcondition: std_logic;

    signal Y21_i, Y20_i, Y19_i, Y18_i, Y17_i, Y16_i: std_logic;
    signal y21, y20, y19, y18, y17, y16: std_logic;
    signal y21Bar, y20Bar, y19Bar, y18Bar, y17Bar, y16Bar: std_logic;

begin

    -- Check for new state information
    newStateCheck <= (SI1out xor STATE_INFORMATION(1)) or (SI0out xor STATE_INFORMATION(0));

    -- Update next state logic
    resetcondition <= (y21Bar and y20Bar and y19Bar and y18Bar and y17Bar and y16Bar and y15Bar and y14Bar and y13Bar and y12Bar and y11Bar and y10Bar and y9Bar and y8Bar and y7Bar and y6Bar and y5Bar and y4Bar and y3Bar and y2Bar and y1Bar and y0Bar);

    Y21_i <= (y13 and IRQ(0));
    Y20_i <= (y11 and IRQ(0));
    Y19_i <= (y9 and IRQ(0));
    Y18_i <= (y7 and IRQ(0));
    Y17_i <= (y5 and IRQ(0));
    Y16_i <= (y3 and IRQ(0));

    Y15_i <= (y14 and newStateCheck);
    Y14_i <= (y13 and IRQ(1) and not IRQ(0)) or (y14 and not newStateCheck);
    Y13_i <= (y12) or (y13 and not IRQ(1)) or (y21 and not IRQ(0));
    Y12_i <= (y11 and IRQ(1) and not IRQ(0));
    Y11_i <= (y10) or (y11 and not IRQ(1)) or (y20 and not IRQ(0));
    Y10_i <= (y9 and IRQ(1) and not IRQ(0));
    Y9_i <= (y8) or (y9 and not IRQ(1)) or (y19 and not IRQ(0));
    Y8_i <= (y7 and IRQ(1) and not IRQ(0));
    Y7_i <= (y6) or (y7 and not IRQ(1)) or (y18 and not IRQ(0));
    Y6_i <= (y5 and IRQ(1) and not IRQ(0));
    Y5_i <= (y4) or (y5 and not IRQ(1)) or (y17 and not IRQ(0));
    Y4_i <= (y3 and IRQ(1) and not IRQ(0));
    Y3_i <= (y2) or (y3 and not IRQ(1)) or (y16 and not IRQ(0));
    Y2_i <= (y1 and IRQ(1));
    Y1_i <= (y0) or (y15) or (y1 and not IRQ(1));
    Y0_i <= resetcondition;

    -- Character definitions
    charM <= "01001101";            -- ASCII for 'M'
    charUnderscore <= "01011111";   -- ASCII for '_'
    charS <= "01010011";            -- ASCII for 'S'
    charg <= "01100111";            -- ASCII for 'g'
    chary <= "01111001";            -- ASCII for 'y'
    charr <= "01110010";            -- ASCII for 'r'
    charNewline <= "00001010";      -- ASCII for newline
    SCCRinit <= "11000000";         -- Initialization value

    -- Save state information using flip-flops
    SI0: entity work.ENDFF(struct)
        port map(STATE_INFORMATION(0), SI_load, CLK, SI0out);

    SI1: entity work.ENDFF(struct)
        port map(STATE_INFORMATION(1), SI_load, CLK, SI1out);

    -- MUX for main and side street colors
    McolorMUX: entity work.MUX4to1_8b(struct)
        port map(charg, charr, chary, charr, SI1out, SI0out, charMcolor);

    ScolorMUX: entity work.MUX4to1_8b(struct)
        port map(charr, chary, charr, charg, SI1out, SI0out, charScolor);

    -- MUX for deciding data output
    CharMUX: entity work.MUX8to1_8b(struct)
        port map(charM, charMcolor, charUnderscore, charS, charScolor, charNewline, SCCRinit, "00000000", CHARSEL, DATA_OUT);

    -- State registers in one-hot encoding
    DFF0: entity work.dFF_2(rtl)
        port map(Y0_i, CLK, y0, y0Bar);
    DFF1: entity work.dFF_2(rtl)
        port map(Y1_i, CLK, y1, y1Bar);
    DFF2: entity work.dFF_2(rtl)
        port map(Y2_i, CLK, y2, y2Bar);
    DFF3: entity work.dFF_2(rtl)
        port map(Y3_i, CLK, y3, y3Bar);
    DFF4: entity work.dFF_2(rtl)
        port map(Y4_i, CLK, y4, y4Bar);
    DFF5: entity work.dFF_2(rtl)
        port map(Y5_i, CLK, y5, y5Bar);
    DFF6: entity work.dFF_2(rtl)
        port map(Y6_i, CLK, y6, y6Bar);
    DFF7: entity work.dFF_2(rtl)
        port map(Y7_i, CLK, y7, y7Bar);
    DFF8: entity work.dFF_2(rtl)
        port map(Y8_i, CLK, y8, y8Bar);
    DFF9: entity work.dFF_2(rtl)
        port map(Y9_i, CLK, y9, y9Bar);
    DFF10: entity work.dFF_2(rtl)
        port map(Y10_i, CLK, y10, y10Bar);
    DFF11: entity work.dFF_2(rtl)
        port map(Y11_i, CLK, y11, y11Bar);
    DFF12: entity work.dFF_2(rtl)
        port map(Y12_i, CLK, y12, y12Bar);
    DFF13: entity work.dFF_2(rtl)
        port map(Y13_i, CLK, y13, y13Bar);
    DFF14: entity work.dFF_2(rtl)
        port map(Y14_i, CLK, y14, y14Bar);
    DFF15: entity work.dFF_2(rtl)
        port map(Y15_i, CLK, y15, y15Bar);
    DFF16: entity work.dFF_2(rtl)
        port map(Y16_i, CLK, y16, y16Bar);
    DFF17: entity work.dFF_2(rtl)
       
