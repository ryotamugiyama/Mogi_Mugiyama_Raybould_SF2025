
gen partnership = .
replace partnership = 1 if marstat == 2
replace partnership = 2 if marstat == 1 & cohabit == 1
replace partnership = 2 if marstat == 3 & cohabit == 1
replace partnership = 3 if marstat == 1 & cohabit == 0 & dating == 1
replace partnership = 4 if marstat == 1 & cohabit == 0 & dating == 0
replace partnership = 3 if marstat == 3 & cohabit == 0 & dating == 1
replace partnership = 4 if marstat == 3 & cohabit == 0 & dating == 0

lab var partnership "Partnership status"
lab def partnershiplab ///
	1 "Marital partnership" ///
	2 "Coresidential partnership" ///
	3 "Non-coresidential partnership" ///
	4 "Non-partnership"

tab partnership, gen(partnership)
lab var partnership1 "Marital partnership"	
lab var partnership2 "Coresidential partnership"
lab var partnership3 "Non-coresidential partnership"
lab var partnership4 "Non-partnership"
	
lab val partnership partnershiplab

gen partnership_first = .
replace partnership_first = partnership if wave == 1
replace partnership_first = partnership if wave == 5 & addedsample == 1
replace partnership_first = partnership if wave == 13 & addedsample == 2
by id: replace partnership_first = partnership_first[_n-1] if partnership_first[_n-1] != . & partnership_first == .
replace partnership_first = . if response == 0

recode partnership_first (1 = 1)(2/3 = 2)(4 = 3) ,gen(partnership_first_c3)
recode partnership_first (1 = 1)(2/4 = 2) ,gen(partnership_first_c2)

*** Lagged variable
xtset id wave 
gen partnership_lag = L.partnership
gen partnership_lead = F.partnership

lab var partnership_lag "Partnership status 1-year lag"
lab val partnership_lag partnershiplab
lab var partnership_lead "Partnership status 1-year lead"
lab val partnership_lead partnershiplab


