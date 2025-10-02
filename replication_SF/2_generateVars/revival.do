gen revival = 0
replace revival = 1 if wave == 1 & addedsample == 0
replace revival = 5 if wave == 5 & addedsample == 1
replace revival = 13 if wave == 13 & addedsample == 2
by id: replace revival = revival[_n-1] + response if id[_n-1] ~= .

replace revival = 999 if revival < wave
replace revival = 0 if revival == wave
replace revival = 1 if revival == 999
replace revival = . if response == 0 | response == .

gen attrition = 0 if response == 1
replace attrition  = . if revival == 1
by id: replace attrition = 1 if attrition == 0 & response == 1 & response[_n+1] == 0 
