


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux8x1 is
    Port ( 
           values : in STD_LOGIC_VECTOR (7 downto 0);
           Sel : in std_logic_vector(2 downto 0);
           Q : out STD_LOGIC);
end mux8x1;

architecture Structural of mux8x1 is


begin 
Q <= (not(sel(2)) and not(sel(1)) and not(sel(0)) and values(0)) 
or (not(sel(2)) and not(sel(1)) and sel(0) and values(1)) 
or (not(sel(2)) and sel(1) and not(sel(0)) and values(2))
or (not(sel(2)) and sel(1) and sel(0) and values(3))
or (sel(2) and not(sel(1)) and not(sel(0)) and values(4))
or (sel(2) and not(sel(1)) and sel(0) and values(5))
or (sel(2) and sel(1) and not(sel(0)) and values(6))
or (sel(2) and sel(1) and sel(0) and values(7));

end Structural;
