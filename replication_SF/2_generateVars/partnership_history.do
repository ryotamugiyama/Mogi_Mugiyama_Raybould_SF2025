/*------------------------- 
partnership_history
1. marital partnership
2. coresidential partnership
3. non-coresidential partnership
4. ever partnership, but not now
5. non-partnership, never
-------------------------*/ 

capture drop partnership_history* 

gen partnership_history = partnership

gen partnership_history_first = .
replace partnership_history_first = zq58s if wave == 1
replace partnership_history_first = dq53s if wave == 5 & addedsample == 1
replace partnership_history_first = lq55s if wave == 13 & addedsample == 2

replace partnership_history = 5 if partnership == 4 & partnership_history_first == 2
replace partnership_history = . if partnership == 4 & partnership_history_first == 9
by id: replace partnership_history = 5 if partnership_history[_n-1] == 5 & partnership == 4
by id: replace partnership_history = . if partnership_history[_n-1] == . & partnership == 4 & id[_n-1] == id[_n]

xttrans partnership_history, freq
lab var partnership_history "Partnership status separating non-partnership"
lab def partnership_historylab ///
	1 "Marital partnership" ///
	2 "Coresidential partnership" ///
	3 "Non-coresidential partnership" ///
	4 "Previously had a partner" ///
	5 "Never had a partner"
lab val partnership_history partnership_historylab