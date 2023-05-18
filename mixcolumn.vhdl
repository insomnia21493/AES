LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY std;
USE std.standard.all;
LIBRARY work;
USE work.ALL;

ENTITY mixcolumn IS

	PORT(
	mnrst	: IN  std_logic;
    mclk 	: IN std_logic;
	start	: IN  std_logic;
	min1	: IN  std_logic_vector(7 DOWNTO 0);
	min2	: IN  std_logic_vector(7 DOWNTO 0);
	min3	: IN  std_logic_vector(7 DOWNTO 0);
	min4	: IN  std_logic_vector(7 DOWNTO 0);
    mout1 : OUT std_logic_vector(7 DOWNTO 0);
    mout2 : OUT std_logic_vector(7 DOWNTO 0);
    mout3 : OUT std_logic_vector(7 DOWNTO 0);
    mout4 : OUT std_logic_vector(7 DOWNTO 0);
	done  : OUT std_logic
	);


END mixcolumn;

ARCHITECTURE replace OF mixcolumn IS
	
	COMPONENT multi IS
		PORT(
			ain 		: IN std_logic_vector(7 DOWNTO 0); 
			bin 		: IN std_logic_vector(7 DOWNTO 0); 
			rout		: OUT std_logic_vector(7 DOWNTO 0) 
		);
		END COMPONENT;
		
		TYPE state IS (idle, mix);
		SIGNAL cur_st : state ;
		SIGNAL nxt_st : state;
		SIGNAL cntr	  : integer RANGE 0 TO 16;
		
		SIGNAL x : std_logic_vector(7 DOWNTO 0);
		SIGNAL xp : std_logic_vector(7 DOWNTO 0);
		SIGNAL y : std_logic_vector(7 DOWNTO 0);
		SIGNAL a0 : std_logic_vector(7 DOWNTO 0);
		SIGNAL a1 : std_logic_vector(7 DOWNTO 0);
		SIGNAL a2 : std_logic_vector(7 DOWNTO 0);
		SIGNAL a3 : std_logic_vector(7 DOWNTO 0);
		SIGNAL mixdone : std_logic;

BEGIN
	
		
		mixmulti: multi PORT MAP ( ain => x, bin => xp , rout => y );  
		
		
		
		
	PROCESS(mclk)
  BEGIN
    IF mclk'EVENT AND mclk = '1' THEN
      IF mnrst = '0' THEN
        mout1 <= (OTHERS => '0');
        mout2 <= (OTHERS => '0');
        mout3 <= (OTHERS => '0');
        mout4 <= (OTHERS => '0');
      ELSE
		
		done <= '0';	
		cur_st <= nxt_st;
      IF cur_st = idle THEN
		
		mixdone <= '0';
		 
		x <= min1;
		xp <= "00000010";
        cntr <= 0;
		
      ELSIF cur_st = mix THEN
		
		IF cntr = 0 THEN
		  a0 <= y;
		  x	<= min2;
		  xp <= "00000011";
		END IF;
		IF cntr = 1 THEN
		  a1 <= y;
		  x	<= min3;
		  xp <= "00000001";
		END IF;
		IF cntr = 2 THEN
		  a2 <= y;
		  x	<= min4;
		  xp <= "00000001";
		END IF;
		IF cntr = 3 THEN
		  a3 <= y;
		  x	<= min1;
		  xp <= "00000001";
		END IF;
		IF cntr = 4 THEN
		  mout1 <= a0 xor a1 xor a2 xor a3;
		  a0 <= y;
		  x	<= min2;
		  xp <= "00000010";
		END IF;
		IF cntr = 5 THEN
		  a1 <= y;
		  x	<= min3;
		  xp <= "00000011";
		END IF;
		IF cntr = 6 THEN
		  a2 <= y;
		  x	<= min4;
		  xp <= "00000001";
		END IF;
		IF cntr = 7 THEN
		  a3 <= y;
		  x	<= min1;
		  xp <= "00000001";
		END IF;
		IF cntr = 8 THEN
		  mout2 <= a0 xor a1 xor a2 xor a3;
		  a0 <= y;
		  x	<= min2;
		  xp <= "00000001";
		END IF;
		IF cntr = 9 THEN
		  a1 <= y;
		  x	<= min3;
		  xp <= "00000010";
		END IF;
		IF cntr = 10 THEN
		  a2 <= y;
		  x	<= min4;
		  xp <= "00000011";
		END IF;
		IF cntr = 11 THEN
		  a3 <= y;
		  x	<= min1;
		  xp <= "00000011";
		END IF;
		IF cntr = 12 THEN
		  mout3 <= a0 xor a1 xor a2 xor a3;
		  a0 <= y;
		  x	<= min2;
		  xp <= "00000001";
		END IF;
		IF cntr = 13 THEN
		  a1 <= y;
		  x	<= min3;
		  xp <= "00000001";
		END IF;
		IF cntr = 14 THEN
		  a2 <= y;
		  x	<= min4;
		  xp <= "00000010";
		END IF;
		IF cntr = 15 THEN
		  mout4 <= y xor a0 xor a1 xor a2;
		  done <= '1';
		  mixdone <='1';
		END IF;
		
		
		
		IF cntr <16 THEN
		cntr <= cntr +1;
		END IF;
		
      END IF;
			
      END IF;
    END IF;
  END PROCESS;
  
  
   COMB: PROCESS (cur_st, start, mixdone)
  BEGIN
   
    CASE cur_st  IS
      WHEN idle =>
        IF start = '1' THEN
          nxt_st <= mix;
        END IF;
      WHEN mix =>
        IF mixdone = '1' THEN
        nxt_st <= idle;
        END IF;
      WHEN OTHERS => -- Final
        
    END CASE;  
  END PROCESS COMB;
  	
	

END replace;
