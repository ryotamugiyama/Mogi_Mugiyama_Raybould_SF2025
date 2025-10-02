gen zqblock = block
drop block

gen zqpref = pref
drop pref

gen zqsize = size
drop size 

gen block = .
gen pref = .
gen size = .
local numwave = 0
foreach flag in $surveyflag{
    local ++numwave
	replace block = `flag'qblock if wave == `numwave'
	replace pref = `flag'qpref if wave == `numwave'
	replace size = `flag'qsize if wave == `numwave'
}

replace block = . if block == 99
replace pref = . if pref == 99
replace size = . if size == 9

lab var size "Residential location"
lab def sizelab ///
	1 "Metropolitan area" ///
	2 "Large city" ///
	3 "Small city" ///
	4 "Town/village"
lab val size sizelab