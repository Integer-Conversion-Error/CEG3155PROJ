library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


--   s1      s2      output
--   0       0       IN0(0..8)
--   0       1       IN2(0..8)
--   1       0       IN1(0..8)
--   1       1       IN3(0..8)
entity MUX4to1_8b is
    port(
        IN0, IN1, IN2, IN3: in std_logic_vector(7 downto 0);
        s1, s2: in std_logic;
        OUTPUT: out std_logic_vector(7 downto 0)
    );
end MUX4to1_8b;

architecture struct of MUX4to1_8b is
    signal signalMUX1, signalMUX2: std_logic_vector(7 downto 0);
begin
    MUX1: entity work.two_one_mux_8b(struct)
        port map(IN0, IN1, s1, signalMUX1);
    MUX2: entity work.two_one_mux_8b(struct)
        port map(IN2, IN3, s1, signalMUX2);
    MUX3: entity work.two_one_mux_8b(struct)
        port map(signalMUX1, signalMUX2, s2, OUTPUT);
end ;
