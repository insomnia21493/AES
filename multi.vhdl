LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY std;
USE std.standard.all;
LIBRARY work;
USE work.ALL;




ENTITY multi IS

	PORT(
	ain 		: IN std_logic_vector(7 DOWNTO 0); 
	bin 		: IN std_logic_vector(7 DOWNTO 0); 
	rout	: OUT std_logic_vector(7 DOWNTO 0) 
	);
	
	
	
END multi;

ARCHITECTURE result OF multi IS

COMPONENT xmul IS
		PORT(
			A 		: IN std_logic_vector(7 DOWNTO 0); 
			Aout	: OUT std_logic_vector(7 DOWNTO 0)
		);
		END COMPONENT;
		
		SIGNAL x0 : std_logic_vector(7 DOWNTO 0); 
		SIGNAL x1 : std_logic_vector(7 DOWNTO 0); 
		SIGNAL x2 : std_logic_vector(7 DOWNTO 0); 
		SIGNAL x3 : std_logic_vector(7 DOWNTO 0); 
		SIGNAL x4 : std_logic_vector(7 DOWNTO 0); 
		SIGNAL x5 : std_logic_vector(7 DOWNTO 0); 
		SIGNAL x6 : std_logic_vector(7 DOWNTO 0); 
		SIGNAL x7 : std_logic_vector(7 DOWNTO 0); 
		
		SIGNAL y0 : std_logic_vector(7 DOWNTO 0); 
		SIGNAL y1 : std_logic_vector(7 DOWNTO 0); 
		SIGNAL y2 : std_logic_vector(7 DOWNTO 0); 
		SIGNAL y3 : std_logic_vector(7 DOWNTO 0); 
		SIGNAL y4 : std_logic_vector(7 DOWNTO 0); 
		SIGNAL y5 : std_logic_vector(7 DOWNTO 0); 
		SIGNAL y6 : std_logic_vector(7 DOWNTO 0); 
		SIGNAL y7 : std_logic_vector(7 DOWNTO 0); 

BEGIN
		x0 <= ain;
		xmul1: xmul PORT MAP ( A => x0, Aout => x1);
		xmul2: xmul PORT MAP ( A => x1, Aout => x2);
		xmul3: xmul PORT MAP ( A => x2, Aout => x3);
		xmul4: xmul PORT MAP ( A => x3, Aout => x4);
		xmul5: xmul PORT MAP ( A => x4, Aout => x5);
		xmul6: xmul PORT MAP ( A => x5, Aout => x6);
		xmul7: xmul PORT MAP ( A => x6, Aout => x7);
		
		y0 <= x0 WHEN 	bin(0) = '1' ELSE
				(OTHERS => '0');
		y1 <= x1 WHEN 	bin(1) = '1' ELSE
				(OTHERS => '0');
		y2 <= x2 WHEN 	bin(2) = '1' ELSE
				(OTHERS => '0');
		y3 <= x3 WHEN 	bin(3) = '1' ELSE
				(OTHERS => '0');
		y4 <= x4 WHEN 	bin(4) = '1' ELSE
				(OTHERS => '0');
		y5 <= x5 WHEN 	bin(5) = '1' ELSE
				(OTHERS => '0');
		y6 <= x6 WHEN 	bin(6) = '1' ELSE
				(OTHERS => '0');
		y7 <= x7 WHEN 	bin(7) = '1' ELSE
				(OTHERS => '0');
			
		rout <= y0 XOR y1 XOR y2 XOR y3 XOR y4 XOR y5 XOR y6 XOR y7;
		

END result;