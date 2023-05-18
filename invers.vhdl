LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY std;
USE std.standard.all;
LIBRARY work;
USE work.ALL;




ENTITY invers IS

	PORT(
	nrst	: IN  std_logic;
    clk 	: IN std_logic;
	start 	: IN  std_logic;
	p 		: IN std_logic_vector(7 DOWNTO 0); 
	invp	: OUT std_logic_vector(7 DOWNTO 0);
	done  	: OUT std_logic
	);


END invers;


ARCHITECTURE clclt OF invers IS

COMPONENT multi IS
		PORT(
			ain 		: IN std_logic_vector(7 DOWNTO 0); 
			bin 		: IN std_logic_vector(7 DOWNTO 0); 
			rout		: OUT std_logic_vector(7 DOWNTO 0) 
		);
		END COMPONENT;
		
		
		TYPE temparray IS ARRAY ( 0 TO 6 ) OF std_logic_vector(7 DOWNTO 0);
		SIGNAL temp  : temparray;
		TYPE state IS (idle, exp);
		SIGNAL cur_st : state ;
		SIGNAL nxt_st : state;
		SIGNAL cntr	  : integer RANGE 0 TO 256;
		signal x : std_logic_vector(7 DOWNTO 0);
		signal xp : std_logic_vector(7 DOWNTO 0);
		signal y : std_logic_vector(7 DOWNTO 0);
		signal inv_done : std_logic;
		
		
BEGIN
	
	
	
	expose: multi PORT MAP ( ain => x, bin => xp , rout => y );  
	
	
	

 PROCESS(clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF nrst = '0' THEN
        invp <= (OTHERS => '0');
      ELSE
		 done <= '0';	
		cur_st <= nxt_st;
      IF cur_st = idle THEN
		
		x <= p;
		xp <= p;
        cntr <= 0;
		done <= '0';
		inv_done <= '0';
		
      ELSIF cur_st = exp THEN
		
		
		
		IF cntr < 7 THEN
			IF cntr /= 6 THEN
			x <= y;
			xp <= y;
			ELSIF cntr = 6 THEN
			x <= temp(0);
			xp <= temp(1);
				END IF;
			temp(cntr) <= y;
		  ELSIF cntr < 12 THEN
			x <= y;
			xp <= temp(cntr-5);
		  ELSIF cntr = 12 THEN
		  done <= '1';
		  inv_done <= '1';
		  invp <= y;
		  
		END IF;
		
		cntr <= cntr +1;
		
	
      END IF;
		
		
      END IF;
    END IF;
  END PROCESS;
  
  
   COMB: PROCESS (cur_st, start, inv_done)
  BEGIN
   
    CASE cur_st  IS
      WHEN idle =>
        IF start = '1' THEN
          nxt_st <= exp;
        END IF;
      WHEN exp =>
        IF inv_done = '1' THEN
        nxt_st <= idle;
        END IF;
      WHEN OTHERS => -- Final
        
    END CASE;  
  END PROCESS COMB;
  



END clclt;
