use "data/NFI_sample.dta", clear

hist nopartner_dur1 if partnership4 == 1, width(1) by(gender, note("")) frequency
graph export "${exportdir}/figA2_histogram.pdf" ,replace
recode nopartner_dur1 (11/30 = 11), gen(nopartner_dur1_combine)
lab var nopartner_dur1_combine "Duration of not having a partner"

*** Table A12: Continuous modeling
local outcome1 "ferdes"
local outcome2 "ferdes23"
local outcome3 "ferdes13"
local outcome4 "ferdes12"
local outcome5 "ferdes_bysex53"
local outcome6 "ferdes_bysex54"

local control "c.age##c.age i.status_student logincome i.size "
local indep_model1 "partnership2 partnership3 nopartner_dur1"
local indep_model2 "partnership2 partnership3 partnership4 nopartner_dur1"
local indep_model3 "partnership2 partnership3 ib0.nopartner_dur1"
local indep_model4 "partnership2 partnership3 nopartner_dur1_combine"
local indep_model5 "partnership2 partnership3 partnership4 nopartner_dur1_combine"
local indep_model6 "partnership2 partnership3 ib0.nopartner_dur1_combine"

forvalues m = 1/6{
	forvalues s = 1/2{
		forvalues y = 2/4{
			reghdfe `outcome`y'' `indep_model`m'' `control' if gender == `s',absorb(id) vce(cluster id)
			est sto y`y'_model`m'_gender`s'
		}
	}
}

local order_var "partnership2 partnership3 partnership4 nopartner_dur1 nopartner_dur1_combine"
local order_var "`order_var' 1.nopartner_dur1 2.nopartner_dur1 3.nopartner_dur1 4.nopartner_dur1 5.nopartner_dur1 6.nopartner_dur1 7.nopartner_dur1 8.nopartner_dur1 9.nopartner_dur1"
local order_var "`order_var' 10.nopartner_dur1 11.nopartner_dur1 11.nopartner_dur1 12.nopartner_dur1 13.nopartner_dur1 14.nopartner_dur1 15.nopartner_dur1 16.nopartner_dur1 17.nopartner_dur1 18.nopartner_dur1 19.nopartner_dur1"
local order_var "`order_var' 20.nopartner_dur1 21.nopartner_dur1 21.nopartner_dur1 22.nopartner_dur1 23.nopartner_dur1 24.nopartner_dur1 25.nopartner_dur1 26.nopartner_dur1 27.nopartner_dur1 28.nopartner_dur1 29.nopartner_dur1"
local order_var "`order_var' 1.nopartner_dur1_combine 2.nopartner_dur1_combine 3.nopartner_dur1_combine 4.nopartner_dur1_combine 5.nopartner_dur1_combine 6.nopartner_dur1_combine 7.nopartner_dur1_combine 8.nopartner_dur1_combine 9.nopartner_dur1_combine 10.nopartner_dur1_combine 11.nopartner_dur1_combine"
local outputopt1 "replace"
local outputopt2 "append"

forvalues y = 2/4{
forvalues i = 1/2{
	esttab ///
	y`y'_model1_gender`i' y`y'_model2_gender`i' ///
	y`y'_model3_gender`i' y`y'_model4_gender`i' ///
	y`y'_model5_gender`i' y`y'_model6_gender`i' ///
	using "${exportdir}/tabA12_continuous_y`y'.rtf" ///
	,b(3) se nogaps scalar(r2 N_clust N_full) noobs lab nonumber ///
	star(* 0.05 ** 0.01 *** 0.001) compress ///
	order(`order_var') keep(`order_var') ///
	mtitle("Model 1" "Model 2" "Model 1" "Model 2" "Model 1" "Model 2" ) ///
	`outputopt`i'' 
}
}