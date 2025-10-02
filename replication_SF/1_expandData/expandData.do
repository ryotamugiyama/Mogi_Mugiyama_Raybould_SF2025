*** id
gen addedsample = 0 if cn == 1
replace addedsample = 1 if cn == 2
replace addedsample = 2 if cn == 3
sort addedsample 
by addedsample: gen id = _n + addedsample * 10000

*** expand data
expand ${latestwave}
sort id
by id: gen wave = _n

drop if wave < 5 & addedsample == 1
drop if wave < 13 & addedsample == 2

*** response
gen zqsurvey = .
replace zqsurvey = 1 if wave == 1 & addedsample == 0

gen response = 0
local numwave = 0
foreach flag in $surveyflag{
    local ++numwave
	replace response = 1 if wave == `numwave' & `flag'qsurvey != .
}

	
sort id wave 

