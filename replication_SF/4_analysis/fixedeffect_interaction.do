use "data/NFI_sample.dta", clear

local outcome1 "ferdes"
local outcome2 "ferdes23"
local outcome3 "ferdes13"
local outcome4 "ferdes12"

forvalues p = 2/4{
	gen par`p' = partnership`p'
	gen par`p'_age = partnership`p' * age
	gen par`p'_col = partnership`p' * college
}
forvalues d = 1/11{
	gen dur`d' = nopartner_dur1_group_d`d'
	gen dur`d'_age = nopartner_dur1_group_d`d' * age
	gen dur`d'_col = nopartner_dur1_group_d`d' * college
}

local control "c.age##c.age i.status_student logincome i.size "
local indep_model3 "par2 par3 par4 par2_age par3_age par4_age"
local indep_model4 "par2 par3 dur1 dur2 dur3 dur4 dur5 dur6 dur7 dur8 dur9 dur10 dur11 par2_age par3_age dur1_age dur2_age dur3_age dur4_age dur5_age dur6_age dur7_age dur8_age dur9_age dur10_age dur11_age"
local indep_model5 "par2 par3 par4 par2_col par3_col par4_col"
local indep_model6 "par2 par3 dur1 dur2 dur3 dur4 dur5 dur6 dur7 dur8 dur9 dur10 dur11 par2_col par3_col dur1_col dur2_col dur3_col dur4_col dur5_col dur6_col dur7_col dur8_col dur9_col dur10_col dur11_col"

forvalues m = 3/6{
	forvalues s = 1/2{
	forvalues y = 2/4{
		reghdfe `outcome`y'' `indep_model`m'' `control' if gender == `s',absorb(id) vce(cluster id)
		est sto y`y'_model`m'_gender`s'
	}
	}
}

local order_var "par2 par3 par4"
forvalues i = 1/11{
	local order_var "`order_var' dur`i'"
}
local order_var "`order_var' par2_age par3_age par4_age"
forvalues i = 1/11{
	local order_var "`order_var' dur`i'_age"
}
local outputopt1 "replace"
local outputopt2 "append"

forvalues g = 1/2{
	esttab ///
	y2_model3_gender`g' y2_model4_gender`g' ///
	y3_model3_gender`g' y3_model4_gender`g' ///
	y4_model3_gender`g' y4_model4_gender`g' ///
	using "${exportdir}/tabA7_interaction_age.rtf" ///
	,b(3) se nogaps scalar(r2 N_clust N_full) noobs lab nonumber ///
	star(* 0.05 ** 0.01 *** 0.001) compress ///
	keep(`order_var') order(`order_var') ///
	mtitle("Model 3" "Model 4" "Model 3" "Model 4" "Model 3" "Model 4") `outputopt`g''  
}

local order_var "par2 par3 par4"
forvalues i = 1/11{
	local order_var "`order_var' dur`i'"
}
local order_var "`order_var' par2_col par3_col par4_col"
forvalues i = 1/11{
	local order_var "`order_var' dur`i'_col"
}

forvalues g = 1/2{
	esttab ///
	y2_model5_gender`g' y2_model6_gender`g' ///
	y3_model5_gender`g' y3_model6_gender`g' ///
	y4_model5_gender`g' y4_model6_gender`g' ///
	using "${exportdir}/tabA8_interaction_educ.rtf" ///
	,b(3) se nogaps scalar(r2 N_clust N_full) noobs lab nonumber ///
	star(* 0.05 ** 0.01 *** 0.001) compress ///
	keep(`order_var') order(`order_var') ///
	mtitle("Model 5" "Model 6" "Model 5" "Model 6" "Model 5" "Model 6") `outputopt`g''  
}


*** Marginal effects
local control "c.age##c.age i.status_student logincome i.size "
local indep_model3 "i.partnership##c.age"
local outcome2 "ferdes23"
local outcome3 "ferdes13"
local outcome4 "ferdes12"

forvalues y = 2/4{
forvalues i = 1/4{
	reghdfe `outcome`y'' `indep_model3' `control' if gender == 2,absorb(id) vce(cluster id)
	estpost margins, at(partnership = `i' age = (20(1)49))
	est sto y`y'_margin_par`i'
	
	esttab y`y'_margin_par`i' ///
	using "${exportdir}/figA1_margin_y`y'_par`i'.csv" ///
	,b ci wide plain noobs replace nonumber nomtitles
}
}