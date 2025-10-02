gen marstat = .

replace marstat = zq50 if wave == 1
replace marstat = aq52 if wave == 2
replace marstat = bq42 if wave == 3
replace marstat = cq45 if wave == 4
replace marstat = dq43 if wave == 5
replace marstat = eq41 if wave == 6
replace marstat = fq44 if wave == 7
replace marstat = gq43 if wave == 8
replace marstat = hq44 if wave == 9
replace marstat = iq45 if wave == 10
replace marstat = jq42 if wave == 11
replace marstat = kq46 if wave == 12
replace marstat = lq44 if wave == 13 & addedsample == 0
replace marstat = lq44 if wave == 13 & addedsample == 1
replace marstat = lq44re_2 if wave == 13 & addedsample == 2
replace marstat = mq46 if wave == 14
replace marstat = nq44 if wave == 15
replace marstat = oq47 if wave == 16
replace marstat = pq54 if wave == 17

/****** generate marriage status ******/
* 1"未婚"2"既婚"3"死別"4"離別"（w1）
* 1"既婚"2"未婚"3"死別"4"離別"（w2-）
* w2以降をw1に合わせるかたちで修正
	
recode marstat (1=2)(2=1) if wave >= 2
recode marstat (3=3)(4=3)(9=.)

ta wave marstat,r