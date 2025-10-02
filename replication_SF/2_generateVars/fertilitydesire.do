 /*------------------------- 
fertility desire: wantchild
-------------------------*/ 

gen wantchild = .
replace wantchild = bq13_5 if wave == 3
replace wantchild = cq17_3 if wave == 4
replace wantchild = dq10_3 if wave == 5
replace wantchild = eq12_3 if wave == 6
replace wantchild = fq11 if wave == 7
replace wantchild = gq13_3 if wave == 8
replace wantchild = hq13_3 if wave == 9
replace wantchild = iq13_3 if wave == 10
replace wantchild = jq12_3 if wave == 11
replace wantchild = kq14_3 if wave == 12
replace wantchild = lq14_4 if wave == 13
replace wantchild = mq15_3 if wave == 14
replace wantchild = nq13_4 if wave == 15
replace wantchild = oq15_3 if wave == 16
replace wantchild = pq16_3 if wave == 17

*** Fertility desire
gen ferdes = .
replace ferdes = 3 if wantchild == 2 
replace ferdes = 3 if wantchild == 3 
replace ferdes = 3 if wantchild == 4
replace ferdes = 2 if wantchild == 5
replace ferdes = 1 if wantchild == 1
lab var ferdes "Fertility desire"
lab def ferdeslab ///
	1 "Do not want" ///
	2 "Do not know" ///
	3 "Want"
lab val ferdes ferdeslab

*** Fertility desire, binary variable
gen ferdes23 = .
replace ferdes23 = 0 if ferdes == 2
replace ferdes23 = 1 if ferdes == 3
gen ferdes12 = .
replace ferdes12 = 0 if ferdes == 1
replace ferdes12 = 1 if ferdes == 2
gen ferdes13 = .
replace ferdes13 = 0 if ferdes == 1
replace ferdes13 = 1 if ferdes == 3
lab var ferdes23 "Want vs Do not know"
lab var ferdes13 "Want vs Do not want"
lab var ferdes12 "Do not know vs Do not want"

*** Fertility desire, separating child's sex
gen ferdes_bysex = .
replace ferdes_bysex = 3 if wantchild == 2 
replace ferdes_bysex = 4 if wantchild == 3 
replace ferdes_bysex = 5 if wantchild == 4
replace ferdes_bysex = 2 if wantchild == 5
replace ferdes_bysex = 1 if wantchild == 1
lab var ferdes_bysex "Fertility desire"
lab def ferdes_bysexlab ///
	1 "Do not want" ///
	2 "Do not know" ///
	3 "Want a boy" ///
	4 "Want a girl" ///
	5 "Want a child regardless of sex" 
lab val ferdes_bysex ferdes_bysexlab
gen ferdes_bysex53 = .
replace ferdes_bysex53 = 1 if ferdes_bysex == 3
replace ferdes_bysex53 = 0 if ferdes_bysex == 5
gen ferdes_bysex54 = .
replace ferdes_bysex54 = 1 if ferdes_bysex == 4
replace ferdes_bysex54 = 0 if ferdes_bysex == 5