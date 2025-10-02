use "data/NFI_dataVariable.dta", clear

xtset id wave

keep if year >= 2009
keep if response == 1
keep if ageentry <= 34
keep if age <= 49
drop if havechild == 1
*drop if marstat == 3

xttab gender

ta revival gender
keep if revival == 0

xttab gender

sort gender
by gender: mdesc ferdes ferdes_bysex ///
	nopartner_dur1 ///
	status_student ///
	logincome ///
	size educ age
sort id year

drop if ferdes == .
drop if nopartner_dur1 == .
drop if status_student == .
drop if logincome == .
drop if size == .
drop if educ == .

xttab gender

gen n = 1
by id: egen sumn = sum(n)
ta sumn gender
drop if sumn == 1

xttab gender

save "data/NFI_sample.dta", replace