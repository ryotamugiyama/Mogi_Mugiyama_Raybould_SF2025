use "data/NFI_sample.dta", clear

local outcome1 "ferdes"
local outcome2 "ferdes23"
local outcome3 "ferdes13"
local outcome4 "ferdes12"
local outcome5 "ferdes_bysex53"
local outcome6 "ferdes_bysex54"

local control "c.age##c.age i.status_student logincome i.size "
local indep_model1 "partnership2 partnership3 partnership4"
local indep_model2 "partnership2 partnership3 nopartner_dur1_group_d1-nopartner_dur1_group_d11"
local indep_model3 "partnership2 partnership3 nopartner_dur2_group_d1-nopartner_dur2_group_d11"
local indep_model4 "partnership2 current_partner_dur_group_d1-current_partner_dur_group_d11 partnership4"
local indep_model5 "partnership2 current_partner_dur_group_d1-current_partner_dur_group_d11 nopartner_dur1_group_d1-nopartner_dur1_group_d11"
local indep_model6 "i.partnership_history"

forvalues m = 1/6{
	forvalues s = 1/2{
		*** Table 2/A3: Categorical outcome model
		*** Table A4: alternative measurement of non-partnership duration
		*** Table A6: Separating duration of non-cohabiting partnership
		*** Table A10: Past history
		forvalues y = 2/4{
			reghdfe `outcome`y'' `indep_model`m'' `control' if gender == `s',absorb(id) vce(cluster id)
			est sto y`y'_model`m'_gender`s'
		}
		*** Table A5: Continuous outcome model
		reghdfe `outcome1' `indep_model`m'' `control' if gender == `s',absorb(id) vce(cluster id)
		est sto y1_model`m'_gender`s'

		*** Table A8: Separating sex preference model
		forvalues y = 5/6{
			reghdfe `outcome`y'' `indep_model`m'' `control' if gender == `s',absorb(id) vce(cluster id)
			est sto y`y'_model`m'_gender`s'
		}
	}
}
*** Test coefficients differences for main results
forvalues y = 2/4{
forvalues s = 1/2{
	reghdfe `outcome`y'' `indep_model2' `control' if gender == `s',absorb(id) vce(cluster id)
	xlincom ///
	(d2_d1 = nopartner_dur1_group_d1 - nopartner_dur1_group_d2) ///
	(d3_d2 = nopartner_dur1_group_d2 - nopartner_dur1_group_d3) ///
	(d4_d3 = nopartner_dur1_group_d3 - nopartner_dur1_group_d4) ///
	(d5_d4 = nopartner_dur1_group_d4 - nopartner_dur1_group_d5) ///
	(d6_d5 = nopartner_dur1_group_d5 - nopartner_dur1_group_d6) ///
	(d7_d6 = nopartner_dur1_group_d6 - nopartner_dur1_group_d7) ///
	(d8_d7 = nopartner_dur1_group_d7 - nopartner_dur1_group_d8) ///
	(d9_d8 = nopartner_dur1_group_d8 - nopartner_dur1_group_d9) ///
	(d10_d9 = nopartner_dur1_group_d9 - nopartner_dur1_group_d10) ///
	(d11_d10 = nopartner_dur1_group_d10 - nopartner_dur1_group_d11) ///
	,post
	est sto y`y'_coef_diff_gender`s'
}
}

*** Table 2/A3 results for categoridal models ******************************************
local order_var "partnership2 partnership3 partnership4"
forvalues i = 1/11{
	local order_var "`order_var' nopartner_dur1_group_d`i'"
}
local outputopt1 "replace"
local outputopt2 "append"

forvalues g = 1/2{
	esttab ///
	y2_model1_gender`g' y2_model2_gender`g' ///
	y3_model1_gender`g' y3_model2_gender`g' ///
	y4_model1_gender`g' y4_model2_gender`g' ///
	using "${exportdir}/tab2_categorical.rtf" ///
	,b(3) se nogaps scalar(r2 N_clust N_full) noobs lab nonumber ///
	star(* 0.05 ** 0.01 *** 0.001) compress ///
	mtitle("Model 1" "Model 2" "Model 1" "Model 2" "Model 1" "Model 2" ) ///
	order(`order_var') ///
	`outputopt`g''  
}

*** Coefficient differences for adjacent categories of non-partnership duration 
	esttab ///
	y2_coef_diff_gender1 ///
	y3_coef_diff_gender1 ///
	y4_coef_diff_gender1 ///
	y2_coef_diff_gender2 ///
	y3_coef_diff_gender2 ///
	y4_coef_diff_gender2 ///
	,b(3) se nogaps noobs nonumber ///
	star(* 0.05 ** 0.01 *** 0.001) ///
	mtitle("Women" "Women" "Women" "Men" "Men" "Men")


*** Table A4: alternative measurement of duration of nonpartnership ******************************************

local order_var "partnership2 partnership3"
forvalues i = 1/11{
	local order_var "`order_var' nopartner_dur2_group_d`i'"
}
local outputopt1 "replace"
local outputopt2 "append"
forvalues g = 1/2{
	esttab ///
	y2_model3_gender`g' ///
	y3_model3_gender`g' ///
	y4_model3_gender`g' ///
	using "${exportdir}/tabA4_alternativedur.rtf" ///
	,b(3) se nogaps scalar(r2 N_clust N_full) noobs lab nonumber ///
	star(* 0.05 ** 0.01 *** 0.001) compress ///
	mtitle("Model 1" "Model 2" "Model 1" "Model 2" "Model 1" "Model 2" ) ///
	order(`order_var') keep(`order_var') ///
	`outputopt`g''  
}

*** Table A5 Continuous models ******************************************
local order_var "partnership2 partnership3 partnership4"
forvalues i = 1/11{
	local order_var "`order_var' nopartner_dur1_group_d`i'"
}

esttab ///
y1_model1_gender1 y1_model2_gender1 ///
y1_model1_gender2 y1_model2_gender2 ///
using "${exportdir}/tabA5_continuous.rtf" ///
,b(3) se nogaps scalar(r2 N_clust N_full) noobs lab nonumber ///
star(* 0.05 ** 0.01 *** 0.001) compress ///
mtitle("Model 1" "Model 2" "Model 1" "Model 2" ) ///
keep(`order_var') order(`order_var') ///
replace

*** Table A6: separating partnership duration ******************************************
local order_var "partnership2"
forvalues i = 1/11{
	local order_var "`order_var' current_partner_dur_group_d`i'"
}
local order_var "`order_var' partnership4"
forvalues i = 1/11{
	local order_var "`order_var' nopartner_dur1_group_d`i'"
}
local outputopt1 "replace"
local outputopt2 "append"
forvalues g = 1/2{
	esttab ///
	y2_model4_gender`g' y2_model5_gender`g' ///
	y3_model4_gender`g' y3_model5_gender`g' ///
	y4_model4_gender`g' y4_model5_gender`g' ///
	using "${exportdir}/tabA6_separatingpartnershipdur.rtf" ///
	,b(3) se nogaps scalar(r2 N_clust N_full) noobs lab nonumber ///
	star(* 0.05 ** 0.01 *** 0.001) compress ///
	mtitle("Model 1" "Model 2" "Model 1" "Model 2" "Model 1" "Model 2" ) ///
	order(`order_var') keep(`order_var') ///
	`outputopt`g''  
}

*** Table A9: sex preference model
local order_var "partnership2 partnership3 partnership4"
forvalues i = 1/11{
	local order_var "`order_var' nopartner_dur1_group_d`i'"
}
local outputopt1 "replace"
local outputopt2 "append"
forvalues s = 1/2{
	esttab ///
	y5_model1_gender`s' y5_model2_gender`s' ///
	y6_model1_gender`s' y6_model2_gender`s' ///
	using "${exportdir}/tabA9_sexpreference.rtf" ///
	,b(3) se nogaps scalar(r2 N_clust N_full) noobs lab nonumber ///
	star(* 0.05 ** 0.01 *** 0.001) compress ///
	order(`order_var') keep(`order_var') ///
	mtitle("Model 1" "Model 2" "Model 1" "Model 2") `outputopt`s''
}


*** Table A10: experience of partnership
local order_var "2.partnership_history 3.partnership_history 4.partnership_history 5.partnership_history"
local outputopt1 "replace"
local outputopt2 "append"
forvalues i = 1/2{
	esttab ///
	y2_model6_gender`i' ///
	y3_model6_gender`i' ///
	y4_model6_gender`i' ///
	using "${exportdir}/tabA10_experience.rtf" ///
	,b(3) se nogaps scalar(r2 N_clust N_full) noobs lab nonumber ///
	star(* 0.05 ** 0.01 *** 0.001) compress ///
	order(`order_var') keep(`order_var') ///
	mtitle("Continuous" "Want vs do not know" "Want vs do not want" "Do not know vs do not want" ) `outputopt`i''	
}



