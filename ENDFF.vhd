library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--altered version of enARdFF from brightspace
ENTITY ENDFF IS
	PORT(
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q	: OUT	STD_LOGIC);
END ENDFF;

ARCHITECTURE struct OF ENDFF IS
	SIGNAL int_q : STD_LOGIC := '0';
    SIGNAL o_qBar : STD_LOGIC;
BEGIN

    oneBitRegister:
    PROCESS(i_clock)
    BEGIN
        IF (i_clock'EVENT and i_clock = '1') THEN
            IF (i_enable = '1') THEN
                int_q	<=	i_d;
            END IF;
        END IF;
    END PROCESS oneBitRegister;

	--  Output Driver

	o_q		<=	int_q;
	o_qBar		<=	not(int_q);

END struct;