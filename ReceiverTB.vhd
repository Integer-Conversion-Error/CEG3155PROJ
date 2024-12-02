library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ReceiverTB is
end ReceiverTB;

architecture Behavioral of ReceiverTB is
    signal CLK: std_logic;
    signal Greset: std_logic := '1';
    signal RDRout: std_logic_vector(7 downto 0);
    signal RDRF: std_logic := '0';
    signal RxD: std_logic := '1';
    signal RDRFload, RDRFin: std_logic;
    signal FEload, FEin, OEload, OEin: std_logic;
begin
    -- clock
    CLK_process: process is
        begin
    
            CLK <= '0';
            wait for 50 ns;
            CLK <= '1';
            wait for 50 ns;
        end process;

    receiver: entity work.Receiver(struct)
        port map(Greset, CLK, RxD, RDRF, RDRFload, RDRFin, FEload, FEin, OEload, OEin, RDRout);

    RDRF_reg: entity work.ENDFF(struct)
        port map(RDRFin, RDRFload, CLK, RDRF);


end Behavioral;
