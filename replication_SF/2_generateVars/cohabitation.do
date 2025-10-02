gen cohabit = .
replace cohabit = w1cohc if wave == 1
replace cohabit = w2cohc if wave == 2
replace cohabit = w3cohc if wave == 3
replace cohabit = w4cohc if wave == 4
replace cohabit = w5cohc if wave == 5
replace cohabit = w6cohc if wave == 6
replace cohabit = fq10_2c if wave == 7
replace cohabit = gq13_2c if wave == 8
replace cohabit = hq13_2c if wave == 9
replace cohabit = iq13_2c if wave == 10
replace cohabit = jq12_2c if wave == 11
replace cohabit = kq14_2c if wave == 12
replace cohabit = lq14_2c if wave == 13
replace cohabit = mq15_2c if wave == 14
replace cohabit = nq13_2c if wave == 15
replace cohabit = oq15_2c if wave == 16
replace cohabit = pq16_2c if wave == 17

recode cohabit (2 = 0)(9 = .)


