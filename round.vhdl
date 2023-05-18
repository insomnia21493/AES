LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY std;
USE std.standard.all;
LIBRARY work;
USE work.ALL;

ENTITY round IS

	PORT(
	rnrst	: IN  std_logic;
    rclk 	: IN std_logic;
	rstart	: IN  std_logic;
	pt 		: IN  std_logic_vector(127 DOWNTO 0);
	kt 		: IN  std_logic_vector(127 DOWNTO 0);
	ct 		: OUT std_logic_vector(127 DOWNTO 0);
	done	: OUT std_logic
	);


END round;

ARCHITECTURE run OF round IS
	TYPE matrix IS ARRAY ( 0 TO 3, 0 TO 3 ) OF std_logic_vector(7 DOWNTO 0);
	SIGNAL ptstate  : matrix;
	
	TYPE state IS (idle, sbbyte, shiftrow, mixall, addkey );
	SIGNAL cur_st : state ;
	SIGNAL nxt_st : state;
	SIGNAL cntr1	  : integer RANGE 0 TO 127;
	SIGNAL cntr2	  : integer RANGE 0 TO 127;

COMPONENT sbox IS
		PORT(
			snrst	: IN  std_logic;
			sclk 	: IN std_logic;
			start	: IN  std_logic;
			sin		: IN  std_logic_vector(7 DOWNTO 0);
			sout 	: OUT std_logic_vector(7 DOWNTO 0);
			done  	: OUT std_logic
		);
		END COMPONENT;
COMPONENT mixcolumn IS
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
			done  : OUT std_logic		);
		END COMPONENT;
		SIGNAL s0 : std_logic_vector(7 DOWNTO 0);
		SIGNAL s1 : std_logic_vector(7 DOWNTO 0);
		SIGNAL m1 : std_logic_vector(7 DOWNTO 0);
		SIGNAL m2 : std_logic_vector(7 DOWNTO 0);
		SIGNAL m3 : std_logic_vector(7 DOWNTO 0);
		SIGNAL m4 : std_logic_vector(7 DOWNTO 0);
		SIGNAL mo1 : std_logic_vector(7 DOWNTO 0);
		SIGNAL mo2 : std_logic_vector(7 DOWNTO 0);
		SIGNAL mo3 : std_logic_vector(7 DOWNTO 0);
		SIGNAL mo4 : std_logic_vector(7 DOWNTO 0);
		SIGNAL sstart	: std_logic;
		SIGNAL mstart	: std_logic;
		SIGNAL sdone	: std_logic;
		SIGNAL mdone	: std_logic;
		SIGNAL mrst		: std_logic;
		SIGNAL srst		: std_logic;
		SIGNAL clkr		: std_logic;
		SIGNAL goshift	: std_logic;
		SIGNAL gork	: std_logic;
		

BEGIN
		clkr <= rclk;
		
		sboxit: sbox PORT MAP ( snrst => srst , sclk => clkr  ,start => sstart , sin => s0 , sout => s1 , done => sdone );
		mixit:	mixcolumn PORT MAP ( mnrst => mrst , mclk => clkr , start => mstart , min1 => m1 , min2 => m2 , min3 => m3 
									, min4 => m4 , mout1 => mo1 , mout2 => mo2 , mout3 => mo3 , mout4 => mo4 , done => mdone);
		
		
	
	  PROCESS(rclk)
  BEGIN
    IF rclk'EVENT AND rclk = '1' THEN
      IF rnrst = '0' THEN
        ct <= (OTHERS => '0');
      ELSE
		 done <= '0';	
		cur_st <= nxt_st;
		
		IF cur_st = idle THEN
		ptstate(0,0) <= pt(127 DOWNTO 120);
		ptstate(1,0) <= pt(119 DOWNTO 112);
		ptstate(2,0) <= pt(111 DOWNTO 104);
		ptstate(3,0) <= pt(103 DOWNTO 96);
		ptstate(0,1) <= pt(95 DOWNTO 88);
		ptstate(1,1) <= pt(87 DOWNTO 80);
		ptstate(2,1) <= pt(79 DOWNTO 72);
		ptstate(3,1) <= pt(71 DOWNTO 64);
		ptstate(0,2) <= pt(63 DOWNTO 56);
		ptstate(1,2) <= pt(55 DOWNTO 48);
		ptstate(2,2) <= pt(47 DOWNTO 40);
		ptstate(3,2) <= pt(39 DOWNTO 32);
		ptstate(0,3) <= pt(31 DOWNTO 24);
		ptstate(1,3) <= pt(23 DOWNTO 16);
		ptstate(2,3) <= pt(15 DOWNTO 8);
		ptstate(3,3) <= pt(7  DOWNTO 0);
		
		sstart <= '1';
		srst <= '1';
		goshift <= '0';
		
		cntr1 <= 0;
		cntr2 <= 0;
		done <='0';
		
		ELSIF cur_st = sbbyte THEN
		
			s0 <= ptstate (cntr1 ,cntr2);
			
			
			IF sdone = '1' THEN
				

				
				ptstate (cntr1 ,cntr2) <= s1;
				IF cntr1 /= 3 THEN
				cntr1 <= cntr1 + 1;
				ELSIF cntr1 = 3 AND cntr2 /= 3 THEN
				cntr1 <= 0 ;
				cntr2 <= cntr2 +1;
				ELSIF cntr1 = 3 AND cntr2 = 3 THEN
				goshift <= '1';
				cntr1 <= 0;
				cntr2 <= 0;
				sstart<='0';
				END IF;
				
			END IF;
		
		
		ELSIF cur_st = shiftrow THEN
			
			goshift <='0';
				
			ptstate(1,0) <= ptstate(1,1);
			ptstate(1,1) <= ptstate(1,2);
			ptstate(1,2) <= ptstate(1,3);
			ptstate(1,3) <= ptstate(1,0);
			ptstate(2,0) <= ptstate(2,2);
			ptstate(2,1) <= ptstate(2,3);
			ptstate(2,2) <= ptstate(2,0);
			ptstate(2,3) <= ptstate(2,1);
			ptstate(3,0) <= ptstate(3,3);
			ptstate(3,1) <= ptstate(3,0);
			ptstate(3,2) <= ptstate(3,1);
			ptstate(3,3) <= ptstate(3,2);
			
			

			
		ELSIF cur_st = mixall THEN
		
		
			
				mrst <= '1';
				mstart <= '1';
		
				m1<= ptstate(0,cntr1);
				m2<= ptstate(1,cntr1);
				m3<= ptstate(2,cntr1);
				m4<= ptstate(3,cntr1);
			
			
			
			IF mdone = '1' THEN
				
				 ptstate(0,cntr1)<=mo1;
				 ptstate(1,cntr1)<=mo2;
				 ptstate(2,cntr1)<=mo3;
				 ptstate(3,cntr1)<=mo4;
				
				IF cntr1 =3 THEN
					gork <='1';
				END IF;
				IF cntr1 <3 THEN
			    cntr1<=cntr1+1;
			END IF;
			END IF;
			
		
		
		ELSIF cur_st = addkey THEN
			gork <= '0';
			
			ct(127 DOWNTO 120) 	 <= kt(127 DOWNTO 120) XOR ptstate(0,0);
			ct(119 DOWNTO 112) 	 <= kt(119 DOWNTO 112) XOR ptstate(1,0);
			ct(111 DOWNTO 104) 	 <= kt(111 DOWNTO 104) XOR ptstate(2,0);
			ct(103 DOWNTO 96) 	 <= kt(103 DOWNTO 96) XOR ptstate(3,0);
			ct(95  DOWNTO 88) 	 <= kt(95  DOWNTO 88) XOR ptstate(0,1);
			ct(87  DOWNTO 80)	 <= kt(87  DOWNTO 80) XOR ptstate(1,1);
			ct(79  DOWNTO 72)	 <= kt(79  DOWNTO 72) XOR ptstate(2,1);
			ct(71  DOWNTO 64)	 <= kt(71  DOWNTO 64) XOR ptstate(3,1);
			ct(63  DOWNTO 56)	 <= kt(63  DOWNTO 56) XOR ptstate(0,2);
			ct(55  DOWNTO 48)	 <= kt(55  DOWNTO 48) XOR ptstate(1,2);
			ct(47  DOWNTO 40) 	 <= kt(47  DOWNTO 40) XOR ptstate(2,2);
			ct(39  DOWNTO 32)	 <= kt(39  DOWNTO 32) XOR ptstate(3,2);
			ct(31  DOWNTO 24)	 <= kt(31  DOWNTO 24) XOR ptstate(0,3);
			ct(23  DOWNTO 16)	 <= kt(23  DOWNTO 16) XOR ptstate(1,3);
			ct(15  DOWNTO 8) 	 <= kt(15  DOWNTO 8)  XOR ptstate(2,3);
			ct(7   DOWNTO 0) 	 <= kt(7   DOWNTO 0)  XOR ptstate(3,3);
			
			done <='1';
			
	
      END IF;
		
		
      END IF;
    END IF;
  END PROCESS;
  
  
   COMB: PROCESS (cur_st, rstart, cntr1, cntr2, mdone, sdone, goshift)
  BEGIN
   
    CASE cur_st  IS
      WHEN idle =>
        IF rstart = '1' THEN
          nxt_st <= sbbyte;
        END IF;
      WHEN sbbyte =>
			IF goshift = '1' THEN
			nxt_st <= shiftrow;
			END IF;
		
		WHEN shiftrow =>
		
			nxt_st <= mixall;
		
		WHEN mixall =>
			
			IF gork = '1' THEN
			nxt_st <= addkey;
			nxt_st <= addkey;
			END IF;
		
		
		WHEN addkey =>
			
			nxt_st <= idle;
		
		
      WHEN OTHERS => -- Final
        
    END CASE;  
  END PROCESS COMB;
	

END run;