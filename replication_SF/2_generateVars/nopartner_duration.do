gen past_partner_exp = .
replace past_partner_exp = 1 if partnership == 4 & zq58s == 1 & wave == 1 & addedsample == 0
replace past_partner_exp = 0 if partnership == 4 & zq58s == 2 & wave == 1 & addedsample == 0
replace past_partner_exp = 1 if partnership == 4 & marstat == 3 & wave == 1 & addedsample == 0
replace past_partner_exp = 1 if partnership == 4 & dq53s == 1 & wave == 5 & addedsample == 1
replace past_partner_exp = 0 if partnership == 4 & dq53s == 2 & wave == 5 & addedsample == 1
replace past_partner_exp = 1 if partnership == 4 & marstat == 3 & wave == 5 & addedsample == 1
replace past_partner_exp = 1 if partnership == 4 & lq55s == 1 & wave == 13 & addedsample == 2
replace past_partner_exp = 0 if partnership == 4 & lq55s == 2 & wave == 13 & addedsample == 2
replace past_partner_exp = 1 if partnership == 4 & marstat == 3 & wave == 13 & addedsample == 2

gen past_partner_dur = .
replace past_partner_dur = zq59_1y * 12 + zq59_1m if past_partner_exp == 1 & wave == 1 & addedsample == 0 & zq59_1y < 88
*** 無回答ケースおよびwave5, 13には年齢および性別から推定される予測値を代入
reg past_partner_dur c.age##i.gender if past_partner_dur != .
predict past_partner_dur_pred if past_partner_exp == 1
replace past_partner_dur = past_partner_dur_pred if past_partner_dur == . & past_partner_dur_pred != .

 
/*------------------------- 
nopartner_dur1（交際相手いない期間, underestimation ver）: 
交際相手がいる = 0 year
交際相手がいない
	- wave 1/5/13時点で交際相手がいない & 過去に交際相手がいた経験がある = 1 year（つまり、別れたばかりと考える）
	- wave 1/5/13時点で交際相手がいない & 過去に交際相手がいた経験がない = Age - 20 year
	- wave t時点で交際相手がいない = 1年前の値に1を加算
-------------------------*/ 
xtset id year
gen nopartner_dur1 = .
replace nopartner_dur1 = 0 if (partnership >= 1 & partnership <= 3)
replace nopartner_dur1 = 1 if partnership == 4 & past_partner_exp == 1
replace nopartner_dur1 = age - 20 if partnership == 4 & past_partner_exp == 0 
replace nopartner_dur1 = L1.nopartner_dur1 + 1 if L1.nopartner_dur1 != . & nopartner_dur1 == . & partnership != . & response != 0
replace nopartner_dur1 = 1 if nopartner_dur1 == 0 & partnership == 4 // 0年を1年に含める
replace nopartner_dur1 = . if revival == 1 // 復活サンプルについては正確な年数が計算できないのでひとまず欠損

/*------------------------- 
nopartner_dur2（交際相手いない期間, overestimation ver）: 
交際相手がいる = 0 year
交際相手がいない
	- wave 1/5/13時点で交際相手がいない & 過去に交際相手がいた経験がある = Age - 20 year - past duration（つまり、付き合っていたのは20歳からだと考える）
	- wave 1/5/13時点で交際相手がいない & 過去に交際相手がいた経験がない = Age - 20 year
	- wave t時点で交際相手がいない - 1年前の値に1を加算
-------------------------*/ 
gen nopartner_dur2 = .
replace nopartner_dur2 = 0 if (partnership >= 1 & partnership <= 3)
replace nopartner_dur2 = age - (20 + ceil((past_partner_dur - 5)/12)) if partnership == 4 & past_partner_exp == 1 & age > 20 + ceil((past_partner_dur - 5)/12)
replace nopartner_dur2 = 1 if partnership == 4 & past_partner_exp == 1 & age <= 20 + ceil((past_partner_dur - 5)/12)
replace nopartner_dur2 = age - 20 if partnership == 4 & past_partner_exp == 0 
replace nopartner_dur2 = L1.nopartner_dur2 + 1 if L1.nopartner_dur2 != . & nopartner_dur2 == . & partnership != . & response != 0
replace nopartner_dur2 = 1 if nopartner_dur2 == 0 & partnership == 4 // 0年を1年に含める
replace nopartner_dur2 = . if revival == 1 // 復活サンプルについては正確な年数が計算できないのでひとまず欠損

lab var nopartner_dur1 "Duration of not having a partner"
lab var nopartner_dur2 "Duration of not having a partner"

gen partner_exp = .
replace partner_exp = 1 if (partnership >= 1 & partnership <= 3)
replace partner_exp = 1 if partnership == 4 & past_partner_exp == 1
replace partner_exp = 0 if partnership == 4 & past_partner_exp == 0
replace partner_exp = L1.partner_exp if partner_exp == . & L1.partner_exp != . & response != 0
replace partner_exp = . if revival == 1

lab var partner_exp "Experience of having a partner"

 
/*------------------------- 
現在の交際相手との交際年数
current_partner_dur
-------------------------*/ 
gen current_partner_dur = .
replace current_partner_dur = dating_dur / 12 if partnership == 3
replace current_partner_dur = 0 if partnership == 1 // cohabitation = 0
replace current_partner_dur = 0 if partnership == 2 // cohabitation = 0
replace current_partner_dur = 0 if partnership == 4 // cohabitation = 0
lab var current_partner_dur "Duration of current non-coresidential partner"

*** 無回答ケースには年齢および性別から推定される予測値を代入（交際ありのうち無回答は4%ほど）
reg current_partner_dur c.age##i.gender if partnership == 3
predict current_partner_dur_pred if partnership == 3
replace current_partner_dur = current_partner_dur_pred if current_partner_dur == . & current_partner_dur_pred != .

gen current_partner_dur_group = ceil(current_partner_dur)
replace current_partner_dur_group = 11 if 11 <= current_partner_dur & current_partner_dur <= 9999

forvalues j = 1/11{
	gen current_partner_dur_group_d`j' = 0 if current_partner_dur_group != . & current_partner_dur_group != `j'
	replace current_partner_dur_group_d`j' = 1 if current_partner_dur_group != . & current_partner_dur_group == `j'
	lab var current_partner_dur_group_d`j' "Current partnership `j' year"
}

/*----------------------------------------------------*/
   /* [>   Partnership duration variables   <] */ 
/*----------------------------------------------------*/
forvalues i = 1/2{

	*** Partnership duration group 1: middle-range **********************
	gen nopartner_dur`i'_group1 = .
	replace nopartner_dur`i'_group1 = 0 if nopartner_dur`i' == 0
	replace nopartner_dur`i'_group1 = 1 if nopartner_dur`i' & nopartner_dur`i' == 1
	replace nopartner_dur`i'_group1 = 2 if 2 <= nopartner_dur`i' & nopartner_dur`i' <= 3
	replace nopartner_dur`i'_group1 = 3 if 4 <= nopartner_dur`i' & nopartner_dur`i' <= 6
	replace nopartner_dur`i'_group1 = 4 if 7 <= nopartner_dur`i' & nopartner_dur`i' <= 10
	replace nopartner_dur`i'_group1 = 5 if 11 <= nopartner_dur`i' & nopartner_dur`i' <= 9999
	local name1 "Non-partnership 1 year"
	local name2 "Non-partnership 2-3 year"
	local name3 "Non-partnership 4-6 year"
	local name4 "Non-partnership 7-10 year"
	local name5 "Non-partnership 11+ year"
	forvalues j = 1/5{
		gen nopartner_dur`i'_group1_d`j' = 0 if nopartner_dur`i'_group1 != . & nopartner_dur`i'_group1 != `j'
		replace nopartner_dur`i'_group1_d`j' = 1 if nopartner_dur`i'_group1 != . & nopartner_dur`i'_group1 == `j'
		lab var nopartner_dur`i'_group1_d`j' "`name`j''"
	}

	*** Partnership duration group 2: somewhat detailed **********************
	gen nopartner_dur`i'_group2 =.
	replace nopartner_dur`i'_group2 = 0 if nopartner_dur`i' == 0
	replace nopartner_dur`i'_group2 = nopartner_dur`i' if 1 <= nopartner_dur`i' & nopartner_dur`i' <= 10 
	replace nopartner_dur`i'_group2 = 11 if 11 <= nopartner_dur`i' & nopartner_dur`i' <= 9999 
	forvalues j = 1/11{
		gen nopartner_dur`i'_group2_d`j' = 0 if nopartner_dur`i'_group2 != . & nopartner_dur`i'_group2 != `j'
		replace nopartner_dur`i'_group2_d`j' = 1 if nopartner_dur`i'_group2 != . & nopartner_dur`i'_group2 == `j'
		lab var nopartner_dur`i'_group2_d`j' "Non-partnership `j' year"
	}
	gen nopartner_dur`i'_group2_cont = nopartner_dur`i'_group2 
	replace nopartner_dur`i'_group2_cont = nopartner_dur`i'_group2 - 1 if nopartner_dur`i'_group2 >= 1
	gen nopartner_dur`i'_group2_log = log(nopartner_dur`i'_group2_cont + 1)

	/*group2を最終的な分析結果として採用するためこの変数に正式名をつける*/
	clonevar nopartner_dur`i'_group = nopartner_dur`i'_group2
	forvalues j = 1/11{
		clonevar nopartner_dur`i'_group_d`j' = nopartner_dur`i'_group2_d`j'
	}
	clonevar nopartner_dur`i'_group_cont = nopartner_dur`i'_group2_cont
	clonevar nopartner_dur`i'_group_log = nopartner_dur`i'_group2_log

	*** Partnership duration group 3: most detailed **********************
	gen nopartner_dur`i'_group3 =.
	replace nopartner_dur`i'_group3 = 0 if nopartner_dur`i' == 0
	replace nopartner_dur`i'_group3 = nopartner_dur`i' if 1 <= nopartner_dur`i' & nopartner_dur`i' <= 15 
	replace nopartner_dur`i'_group3 = 16 if 16 <= nopartner_dur`i' & nopartner_dur`i' <= 9999 
	forvalues j = 1/16{
		gen nopartner_dur`i'_group3_d`j' = 0 if nopartner_dur`i'_group3 != . & nopartner_dur`i'_group3 != `j'
		replace nopartner_dur`i'_group3_d`j' = 1 if nopartner_dur`i'_group3 != . & nopartner_dur`i'_group3 == `j'
		lab var nopartner_dur`i'_group3_d`j' "Non-partnership `j' year"
	}	
	gen nopartner_dur`i'_group3_cont = nopartner_dur`i'_group3
	replace nopartner_dur`i'_group3_cont = nopartner_dur`i'_group3 - 1 if nopartner_dur`i'_group3 >= 1
	gen nopartner_dur`i'_group3_log = log(nopartner_dur`i'_group3_cont + 1)
}
