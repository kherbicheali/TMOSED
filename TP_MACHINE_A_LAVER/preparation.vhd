--Bloc F
PORT (
	clk,init,Prog_1,Accept,Cancel,Door : in
std_logic ; 
	Moteur,Sens,Alarme,Validation : out std_logic
	) ;
signal debtempo, fintempo : std_logic ;
signal P0p,P1p,P2p,P3p,P4p,P5p,P6p : std_logic ;
signal P0s,P1s,P2s,P3s,P4s,P5s,P6s : std_logic ; 

process ( debtempo,fintempo,Prog_1,Accept,Cancel,door,P1p,P2p,P3p,P4p,P5p,P6p)
begin 
	P0s <= ( P0p and not(Prog_1) ) or ( P3p and Cancel ) ;
	P1s <= ( P0p and Prog_1 ) or ( P1p and ( not(Door) or Door ) ) ;
	P2s <= ( P1p and Door ) or ( P2p and Door ) ;
	P3s <= ( P2p and not(Door) ) or ( P3p and ( not(Cancel) or not(Accept) ) ) ; 
	P4s <= ( P3p and (Accept and debtempo) ) or ( P6p and fintempo ) or ( P4p and not(fintempo) ) ;
	P5s <= ( P4p and fintempo ) or ( P5p and not(debtempo) ) ;
	P6s <= ( P5p and debtempo ) or ( P6p and not(fintempo) ) ;
end process ;

--Bloc M
process (init, clk)
begin 
	if (init = '1') then 
		epT <= etatT1 ; 
		P0p <= '1' ;
		P1p <= '0' ;
		P2p <= '0' ;
		P3p <= '0' ;
		P4p <= '0' ;
		P5p <= '0' ;
		P6p <= '0' ;
	elsif ( (clk'event) and (clk='1') ) then 
		n <= n+1 ;
		if (n=10) then
			epT <= esT ;
			n <= 0 ;
		end if ; 
		P0p <= P0s; 
		P1p <= P1s; 
		P2p <= P2s; 
		P3p <= P3s; 
		P4p <= P4s; 
		P5p <= P5s; 
		P6p <= P6s;
	end if ; 
end process ; 

--Bloc G
Alarme <= '1' when (P2p = '1') else '0' ;
Moteur <= '1' when ( P4p = '1' or P6p = '1' ) else '0' ;
Sens <= '0' when (P4p = '1') else '1' ;
Validation <= '0' ;
  


