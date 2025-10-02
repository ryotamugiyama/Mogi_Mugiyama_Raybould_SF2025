use "data/NFI_sample.dta", clear

*** Table 1: descriptive statistics by gender ***************
dtable ///
	i.ferdes ///
	i.partnership nopartner_dur1_group_d* ///
	age i.status_student logincome i.size i.college ///
	,by(gender, nototals) ///
	factor(, stat(fvprop))

*** Table A1: descriptive statistics by gender and partnership status ***************
forvalues i = 1/2{
	dtable ///
	i.ferdes ///
	nopartner_dur1_group_d* ///
	age i.status_student logincome i.size i.college ///
	if gender == `i',by(partnership, nototals) 	
}


