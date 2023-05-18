LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY std;
USE std.standard.all;
LIBRARY work;
USE work.ALL;

ENTITY xmul IS

	PORT(
	A 		: IN std_logic_vector(7 DOWNTO 0); 
	Aout	: OUT std_logic_vector(7 DOWNTO 0) 
	);
END xmul;

ARCHITECTURE behave OF xmul IS

BEGIN
	
	
Aout(0) <= A(7);
Aout(1) <= A(0) xor A(7);
Aout(2) <= A(1);
Aout(3) <= A(2) xor A(7);
Aout(4) <= A(3) xor A(7);
Aout(5) <= A(4);
Aout(6) <= A(5);
Aout(7) <= A(6);

END behave;

