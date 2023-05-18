LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY std;
USE std.standard.all;
LIBRARY work;
USE work.ALL;

ENTITY sbox IS

	PORT(
	snrst	: IN  std_logic;
    sclk	: IN std_logic;
	start	: IN  std_logic;
	sin		: IN  std_logic_vector(7 DOWNTO 0);
    sout	: OUT std_logic_vector(7 DOWNTO 0);
	done  	: OUT std_logic
	);


END sbox;


ARCHITECTURE transfer OF sbox IS


COMPONENT invers IS
		PORT(
			nrst: IN  std_logic;
			clk : IN std_logic;
			start : IN  std_logic;
			p 		: IN std_logic_vector(7 DOWNTO 0); 
			invp	: OUT std_logic_vector(7 DOWNTO 0);
			done  : OUT std_logic
		);
		END COMPONENT;
		TYPE state IS (idle, chng,final);
		SIGNAL cur_st : state ;
		SIGNAL nxt_st : state;
		
		SIGNAL x : std_logic_vector(7 DOWNTO 0);
		SIGNAL y : std_logic_vector(7 DOWNTO 0);
		SIGNAL t : std_logic_vector(7 DOWNTO 0);
		SIGNAL d : std_logic;
		SIGNAL sdone : std_logic;
		SIGNAL invstart : std_logic;
		SIGNAL rst : std_logic;
		SIGNAL setclk : std_logic;
		
		
		
BEGIN
	
	rst <= snrst;
	setclk <= sclk;
	
	
	invcompute: invers PORT MAP ( nrst => rst, clk => setclk, start => invstart, p => x, invp => y, done => d);


  PROCESS(sclk)
  BEGIN
    IF sclk'EVENT AND sclk = '1' THEN
      IF snrst = '0' THEN
        sout <= (OTHERS => '0');
      ELSE
		 done <= '0';	
		cur_st <= nxt_st;
			x <= sin;
						
				
      IF cur_st = idle THEN
		
		done<='0';	
		sdone<='0';		
		invstart <= '1';
		
      ELSIF cur_st = chng THEN
		
		invstart <='0';
		
		IF d = '1' THEN
		  sout(0) <= y(0) xor y(4) xor y(5) xor y(6) xor y(7) xor '1';
		  sout(1) <= y(0) xor y(1) xor y(5) xor y(6) xor y(7) xor '1';
		  sout(2) <= y(0) xor y(1) xor y(2) xor y(6) xor y(7) ;
		  sout(3) <= y(0) xor y(1) xor y(2) xor y(3) xor y(7);
		  sout(4) <= y(0) xor y(1) xor y(2) xor y(3) xor y(4);
		  sout(5) <= y(1) xor y(2) xor y(3) xor y(4) xor y(5) xor '1';
		  sout(6) <= y(2) xor y(3) xor y(4) xor y(5) xor y(6) xor '1';
		  sout(7) <= y(3) xor y(4) xor y(5) xor y(6) xor y(7);
		  done <= '1';
		  sdone<= '1';
		END IF;
		
	
      END IF;
		
		
      END IF;
    END IF;
  END PROCESS;
  
  
   COMB: PROCESS (cur_st, start, sdone)
  BEGIN
   
    CASE cur_st  IS
      WHEN idle =>
        IF start = '1' THEN
          nxt_st <= chng;
        END IF;
      WHEN chng =>
        IF sdone = '1' THEN
        nxt_st <= idle;
        END IF;
      WHEN OTHERS => -- Final
        
	
		
    END CASE;  
  END PROCESS COMB;
  

END transfer;
