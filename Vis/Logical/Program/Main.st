
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	//je¿eli nasta³a noc
	IF noc AND NOT noc0 THEN
		stan := NOC;		
	END_IF;
	
	//Je¿eli kliknêliœmy start i dopiero uruchamiamy sygnalizacjê
	IF stan = OFF AND start THEN
		stan := zolte;//zapal ¿ó³te
	//Je¿eli nie jest klikniêty Start wy³¹czamy sygnalizacjê
	ELSIF NOT start THEN 
		stan := OFF;
	END_IF;
	
	//ustawienie timera dodaj¹cego auta na 400 ms
	TON_AUTA.PT := T#400ms;
	TON_AUTA.IN := 1;
	
	//Je¿eli minê³o 400 ms
	IF TON_AUTA.Q THEN
		//Je¿eli jest noc
		IF noc THEN
			IF auta1>0 AND (licznik = 2 OR licznik = 4 OR licznik = 6) THEN
				auta1 := auta1 -1;
			END_IF;
			IF auta2>0 AND (licznik = 1 OR licznik = 3 OR licznik = 5) THEN
				auta2 := auta2 -1;
			END_IF;
			IF licznik = 2  THEN
				auta1 := auta1 + 2;
			END_IF;
			IF licznik = 6  THEN
				auta2 := auta2 + 2;
				licznik := 0;
			END_IF;
		//Je¿eli jest dzieñ
		ELSE
			IF licznik >= 3  THEN
				auta1 := auta1 + 2;
				auta2 := auta2 + 1;
				licznik := 0;
			END_IF;
			CASE stan OF
				zielone:
					IF auta1>1 THEN
						auta1 := auta1 -2;
					END_IF;
				czerwone:
					IF auta2>1 THEN
						auta2 := auta2 -2;
					END_IF;
				czekaj:
					IF swiatlo = 2 AND auta1>1 THEN
						auta1 := auta1 -2;	
					ELSIF swiatlo = 4 AND auta2 >1 THEN
						auta2 := auta2 -2;
					END_IF;
			END_CASE;		
		END_IF;
		licznik := licznik + 1;
		TON_AUTA.IN := 0;
	END_IF; 
	
	//maszyna stanów		
	CASE stan OF
		OFF:
			zielone1 := 0;
			zolte1 := 0;
			czerwone1 := 0;
			zielone2 := 0;
			zolte2 := 0;
			czerwone2 := 0;
			
			TON_Zielone.IN := 0;
			TON_Zolte.IN := 0;
			TON_Czerwone.IN := 0;
		zielone:
			zielone1:= 1;
			zolte1 := 0;
			czerwone1:= 0;
			
			zielone2 := 0;
			zolte2 := 0;
			czerwone2 := 1;
			
			TON_Zielone.PT := T#5s;
			TON_Zielone.IN := 1;
			IF TON_Zielone.Q THEN
				stan := czekaj;
				swiatlo := zolte;//zapamiêtanie nastêpnego kroku
				TON_Zielone.IN := 0;
			END_IF;
		zolte:
			zielone1 :=0;
			zolte1 := 1;
			czerwone1 := 0;
			
			zielone2 := 0;
			zolte2 := 1;
			czerwone2 := 1;
			
			TON_Zolte.PT := T#1s;
			TON_Zolte.IN := 1;
			IF TON_Zolte.Q THEN
				stan := czerwone;
				TON_Zolte.IN := 0;
			END_IF;
		
		czerwone:
			zielone1 := 0;
			zolte1 := 0;
			czerwone1 := 1;
			
			zielone2 := 1;
			zolte2 := 0;
			czerwone2 := 0;
			
			TON_Czerwone.PT := T#5s;
			TON_Czerwone.IN := 1;
			IF TON_Czerwone.Q THEN
				stan := czekaj;
				swiatlo := zolto_czerwone;//zapamiêtanie nastêpnego kroku
				TON_Czerwone.IN := 0;
			END_IF;
		
		zolto_czerwone:
			zielone1 :=0;
			zolte1 := 1;
			czerwone1 := 1;
			
			zielone2 := 0;
			zolte2 := 1;
			czerwone2 := 0;
			
			TON_Zolte.PT := T#1s;
			TON_Zolte.IN := 1;
			IF TON_Zolte.Q THEN
				stan := zielone;
				TON_Zolte.IN := 0;
			END_IF;
		czekaj:
			czekaj_ := TRUE;		
			IF przycisk THEN
				stan := swiatlo;
				przycisk := FALSE;
				czekaj_ := FALSE;
			END_IF;
		NOC:
			zielone1 := 0;
			zolte1 := 0;
			czerwone1 := 0;
			zielone2 := 0;
			zolte2 := 0;
			czerwone2 := 0;
			
			TON_Zolte.PT := T#1s;
			TON_Zolte.IN := 1;
			IF TON_Zolte.Q THEN
				stan := noc_zolte;
				TON_Zolte.IN := 0;
			END_IF;
		noc_zolte:
			zielone1 := 0;
			zolte1 := 1;
			czerwone1 := 0;
			zielone2 := 0;
			zolte2 := 1;
			czerwone2 := 0;
			
			TON_Zolte.PT := T#1s;
			TON_Zolte.IN := 1;
			IF TON_Zolte.Q THEN
				stan := NOC;
				TON_Zolte.IN := 0;
			END_IF;
			IF NOT noc THEN
	  			stan := zolte;
			END_IF;
				
	END_CASE;
	//przypisanie obecnego stanu zmiennej noc do zmiennej noc0
	noc0 := noc;
	IF noc THEN
		kolory_nocy := 213;
	ELSE
		kolory_nocy := 187;			
	END_IF;	
	
	//uruchomienie timerów
	TON_Zielone ();
	TON_Zolte();
	TON_Czerwone();
	TON_AUTA();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM