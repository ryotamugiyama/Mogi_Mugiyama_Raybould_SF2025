gen ageentry = 0
replace ageentry = age if wave == 1 & addedsample == 0
replace ageentry = age if wave == 5 & addedsample == 1
replace ageentry = age if wave == 13 & addedsample == 2
by id: ereplace ageentry = max(ageentry)

lab var ageentry "Age at entry"