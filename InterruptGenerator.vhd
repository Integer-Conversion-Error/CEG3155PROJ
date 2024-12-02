library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity definition for the interrupt generator (interrupt_gen)
-- This module generates interrupt signals for UART operation based on input conditions.
entity interrupt_gen is
    Port (
        TIE, RIE, RDRF, OE, TDRE: in std_logic;          -- Inputs:
                                                        -- TIE: Transmitter Interrupt Enable
                                                        -- RIE: Receiver Interrupt Enable
                                                        -- RDRF: Receiver Data Register Full
                                                        -- OE: Overrun Error
                                                        -- TDRE: Transmitter Data Register Empty
        IRQ: out std_logic_vector(1 downto 0)           -- Outputs:
                                                        -- IRQ(0): Receiver interrupt
                                                        -- IRQ(1): Transmitter interrupt
    );
end interrupt_gen;

-- Architecture definition
architecture struct of interrupt_gen is
begin
    -- Receiver interrupt (IRQ(0))
    -- IRQ(0) is asserted when RIE (Receiver Interrupt Enable) is high
    -- and either RDRF (Receiver Data Register Full) or OE (Overrun Error) is high.
    IRQ(0) <= RIE and (RDRF or OE);

    -- Transmitter interrupt (IRQ(1))
    -- IRQ(1) is asserted when TIE (Transmitter Interrupt Enable) is high
    -- and TDRE (Transmitter Data Register Empty) is high.
    IRQ(1) <= TIE and TDRE;

end struct;
