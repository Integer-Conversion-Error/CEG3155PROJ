library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TransmitterController is
 Port (
    Greset, CLK: in std_logic;
    UARTselect, TDRE: in std_logic;
    TDREload, TDREin: out std_logic;
    TxDFFload, TxDFFset, TxDFFSEL: out std_logic;
    TSRload, TSRshiftR: out std_logic
 );
end TransmitterController;

architecture struct of TransmitterController is
    signal CTRload, CTRinc: std_logic;
    signal CTRout: std_logic;
    signal Y3_i, Y2_i, Y1_i, Y0_i: std_logic;
    signal y3, y2, y1, y0: std_logic;
    signal y3Bar, y2Bar, y1Bar, y0Bar: std_logic;
    signal resetcondition: std_logic; 
begin

    resetcondition <= (y3Bar and y2Bar and y1Bar and y0Bar);

    Y3_i <= (y2 and not UARTselect) or (y3 and CTRout);
    Y2_i <= (y1 and not TDRE and not UARTselect);
    Y1_i <= y0 or (y1 and (TDRE or UARTselect));
    Y0_i <= resetcondition or (y3 and not CTRout);

    counter: entity work.counter_transmitterFSM(struct)
        port map(CTRload, CTRinc, CLK, CTRout);

    DFF0: entity work.dFF_2(rtl)
        port map(Y0_i, CLK, y0, y0Bar);
    DFF1: entity work.dFF_2(rtl)
        port map(Y1_i, CLK, y1, y1Bar);
    DFF2: entity work.dFF_2(rtl)
        port map(Y2_i, CLK, y2, y2Bar);
    DFF3: entity work.dFF_2(rtl)
        port map(Y3_i, CLK, y3, y3Bar);

    TDREload <= y0;
    TDREin <= y0;
    TxDFFload <= '1';
    TxDFFset <=  y0 or y1;
    TSRload <= y2 or y3;
    TSRshiftR <= y3;
    CTRload <= y2 or y3;
    CTRinc <= y3;
    TxDFFSEL <= y3;

end ;
