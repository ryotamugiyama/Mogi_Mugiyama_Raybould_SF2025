use "data/NFI_sample.dta", clear

local outcome1 "ferdes"
local outcome2 "ferdes23"
local outcome3 "ferdes13"
local outcome4 "ferdes12"

gen age_sq = age^2
tab size, gen(size)
tab status_student, gen(status_student)
local control "age age_sq status_student2-status_student5 logincome size2-size4 "
local indep_model1 "partnership2 partnership3 partnership4"
local indep_model2 "partnership2 partnership3 nopartner_dur1_group_d1-nopartner_dur1_group_d11"
forvalues m = 1/2{
	forvalues s = 1/2{
		forvalues y = 2/4{
			xthybrid `outcome`y'' `indep_model`m'' `control' if gender == `s',clusterid(id) vce(cluster id) se p
			est sto y`y'_model`m'_gender`s'
		}
	}
}
local order_var "W__partnership2 W__partnership3 W__partnership4"
forvalues i = 1/11{
	local order_var "`order_var' W__nopartner_dur1_group_d`i'"
}
local order_var "`order_var' B__partnership2 B__partnership3 B__partnership4"
forvalues i = 1/11{
	local order_var "`order_var' B__nopartner_dur1_group_d`i'"
}
local outputopt1 "replace"
local outputopt2 "append"
forvalues g = 1/2{
	esttab ///
	y2_model1_gender`g' y2_model2_gender`g' ///
	y3_model1_gender`g' y3_model2_gender`g' ///
	y4_model1_gender`g' y4_model2_gender`g' ///
	using "${exportdir}/tabA11_hybrid.rtf" ///
	,b(3) se nogaps scalar(r2 N_clust N_full) noobs lab nonumber ///
	order(`order_var') keep(`order_var') ///
	star(* 0.05 ** 0.01 *** 0.001) compress ///
	mtitle("Model 1" "Model 2" "Model 1" "Model 2" "Model 1" "Model 2" ) ///
	`outputopt`g'' 
}

