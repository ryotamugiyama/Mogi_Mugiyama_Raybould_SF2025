gen educ = .
replace educ = zq23a if addedsample == 0 /*初回サンプル*/
replace educ = dq69a if addedsample == 1 /*追加サンプル*/
replace educ = lq72a if addedsample == 2 /*refresh*/

* 在学中は実質卒業と同等とみなす
gen graduate = .
replace graduate = 1 if addedsample == 0 & (zq24 == 1 | zq24 == 3 | zq24 == 9)
replace graduate = 0 if addedsample == 0 & (zq24 == 2)
replace graduate = 1 if addedsample == 1 & (dq70 == 1 | dq70 == 3 | dq70 == 9)
replace graduate = 0 if addedsample == 1 & (dq70 == 2)
replace graduate = 1 if addedsample == 2 & (lq73 == 1 | lq73 == 3 | lq73 == 9)
replace graduate = 0 if addedsample == 2 & (lq73 == 2)

*** 学歴の格下げ（卒業していなかったら一つ下の段階の学歴を採用）

gen educ_old = educ
replace educ = 1 if educ == 2 & graduate == 0 // 高校→中学
replace educ = 2 if educ == 3 & graduate == 0 // 専門→高校
replace educ = 2 if educ == 4 & graduate == 0 // 短大高専→高校
replace educ = 2 if educ == 5 & graduate == 0 // 大学→高校
replace educ = 5 if educ == 6 & graduate == 0 // 大学院→大学

recode educ 1 = 1 2 = 1 3 = 2 4 = 3 5/6 = 4
recode educ (7/9 = .)

lab def educlab 1 "Junior high/Senior High" 2 "Vocational school" 3"Junior college" 4 "University or more"
lab val educ educlab