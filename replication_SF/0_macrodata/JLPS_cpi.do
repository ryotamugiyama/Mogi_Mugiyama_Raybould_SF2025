*import delimited "MacroData/zni2015r.csv", clear encoding(shift-jis)
import delimited "https://www.e-stat.go.jp/stat-search/file-download?statInfId=000032103937&fileKind=1", clear encoding(shift-jis)

rename v1 year
rename v2 cpi
destring, force replace
replace year = year + 1 /*JLPSの調査時点はT年1~3月なので、実態としてはT-1年の消費水準を反映しているとみる*/
drop if year < 2007 | year > 2023
/*基準年の数値を取ってくる*/
gen base = 0
replace base = cpi if year == 2020
egen cpi2020base = max(base)
replace cpi2020base = cpi2020base / cpi
drop base
save "data/CPI2020base.dta", replace
