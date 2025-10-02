/*----------------------------------------------------*/
   /* [>   1.  replace individual income   <] */ 
/*----------------------------------------------------*/

capture drop incomeR

gen incomeR = income 

by id: replace incomeR = incomeR[_n-1] ///
	if year >= 2008 & response == 1 & ///
	income == . 

by id: replace incomeR = incomeR[_n-1] ///
	if year >= 2008 & response == 1 & ///
	incomeR == . & incomeR[_n-1] != . 

lab var incomeR "Income (million JPY)"

merge m:1 year using "data/CPI2020base.dta", keep(match master) nogen
replace income = income * cpi2020base
replace incomeR = incomeR * cpi2020base

gen logincome = log(income * 10 + 1)
gen logincomeR = log(incomeR * 10 + 1)
*replace logincomeR = log(1) if incomeR == 0

lab var logincome "Logged annual income"
lab var logincomeR "Logged income"

sort id wave
xtset id wave
gen lead_logincome = F1.income
gen lead_logincomeR = F1.logincomeR

lab var lead_logincomeR "Logged income"