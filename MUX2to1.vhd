library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- OUT1 <= IN1 when SEL is 0
-- OUT1 <= IN2 when SEL is 1
entity two_one_mux is
    port(
        IN1, IN2: in std_logic;
        Sel: in std_logic;
        OUT1: out std_logic
    );
end two_one_mux;

architecture struct OF two_one_mux is
begin
    OUT1 <= ((IN1 and not(Sel)) or (IN2 and Sel));
end struct;