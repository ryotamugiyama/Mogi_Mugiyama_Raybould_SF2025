gen dating = .
replace dating = zq58 if wave == 1
replace dating = aq59 if wave == 2
replace dating = bq51 if wave == 3
replace dating = cq54 if wave == 4
replace dating = dq53 if wave == 5
replace dating = eq52 if wave == 6
replace dating = fq55 if wave == 7
replace dating = gq54 if wave == 8
replace dating = hq55 if wave == 9
replace dating = iq56 if wave == 10
replace dating = jq53 if wave == 11
replace dating = kq58 if wave == 12
replace dating = lq55 if wave == 13
replace dating = mq58 if wave == 14
replace dating = nq55 if wave == 15
replace dating = oq59 if wave == 16
replace dating = pq65 if wave == 17

/****** generate marriage status ******
1 "婚約者がいる"
2 "特定の交際相手がいる"
3 "現在はいない"
8 "非該当"
9 "無回答"
***/

gen engaged = dating
recode engaged (1 = 1)(2/3 = 0)(8/9 = .) 
recode dating (1/2 = 1)(3 = 0)(8/9 = .)

foreach w in y m {
	gen dating_dur_`w' = .
	replace dating_dur_`w' = zq59_1`w' if wave == 1
	replace dating_dur_`w' = aq60_1`w' if wave == 2
	replace dating_dur_`w' = bq52_1`w' if wave == 3
	replace dating_dur_`w' = cq55_1`w' if wave == 4
	replace dating_dur_`w' = dq54_1`w' if wave == 5
	replace dating_dur_`w' = eq53_1`w' if wave == 6
	replace dating_dur_`w' = fq56_1`w' if wave == 7
	replace dating_dur_`w' = gq55_1`w' if wave == 8
	replace dating_dur_`w' = hq56_1`w' if wave == 9
	replace dating_dur_`w' = iq57_1`w' if wave == 10
	replace dating_dur_`w' = jq54_1`w' if wave == 11
	replace dating_dur_`w' = kq59_1`w' if wave == 12
	replace dating_dur_`w' = lq56_1`w' if wave == 13
	replace dating_dur_`w' = mq59_1`w' if wave == 14
	replace dating_dur_`w' = nq56_1`w' if wave == 15
	replace dating_dur_`w' = oq60_1`w' if wave == 16
	replace dating_dur_`w' = pq66_1`w' if wave == 17
}  // end of foreach w in varlist


gen dating_dur = dating_dur_y * 12 + dating_dur_m if dating_dur_y < 88

*

gen dating_long = dating
replace dating_long = 0 if dating_long == 1 & dating_dur < 12
