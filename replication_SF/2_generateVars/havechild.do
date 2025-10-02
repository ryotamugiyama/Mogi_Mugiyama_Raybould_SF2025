** wave2~5における子ども人数と末子年齢の作成 *********************************************************************
** householdnum 同居人数
gen householdnum = .
replace householdnum = aq11_1 if wave == 2
replace householdnum = bq13_1 if wave == 3
replace householdnum = cq17_1 if wave == 4
replace householdnum = dq10_1 if wave == 5

**同居している子どもの人数と，そのうち最も年齢の低い子どもの年齢を求める（w2~5）
forvalues i = 1/12{
	gen mem`i'rel = .	
}

replace mem1rel = aq11_2a if wave == 2
replace mem2rel = aq11_2b if wave == 2
replace mem3rel = aq11_2c if wave == 2
replace mem4rel = aq11_2d if wave == 2
replace mem5rel = aq11_2e if wave == 2
replace mem6rel = aq11_2f if wave == 2
replace mem7rel = aq11_2g if wave == 2
replace mem8rel = aq11_2h if wave == 2

replace mem1rel = bq13_2bz if wave == 3
replace mem2rel = bq13_2cz if wave == 3
replace mem3rel = bq13_2dz if wave == 3
replace mem4rel = bq13_2ez if wave == 3
replace mem5rel = bq13_2fz if wave == 3
replace mem6rel = bq13_2gz if wave == 3
replace mem7rel = bq13_2hz if wave == 3
replace mem8rel = bq13_2iz if wave == 3
replace mem9rel = bq13_2jz if wave == 3
replace mem10rel = bq13_2kz if wave == 3
replace mem11rel = bq13_2lz if wave == 3
replace mem12rel = bq13_2mz if wave == 3

replace mem1rel = cq17bz if wave == 4
replace mem2rel = cq17cz if wave == 4
replace mem3rel = cq17dz if wave == 4
replace mem4rel = cq17ez if wave == 4
replace mem5rel = cq17fz if wave == 4
replace mem6rel = cq17gz if wave == 4
replace mem7rel = cq17hz if wave == 4
replace mem8rel = cq17iz if wave == 4

replace mem1rel = dq10_22z if wave == 5
replace mem2rel = dq10_23z if wave == 5
replace mem3rel = dq10_24z if wave == 5
replace mem4rel = dq10_25z if wave == 5
replace mem5rel = dq10_26z if wave == 5
replace mem6rel = dq10_27z if wave == 5
replace mem7rel = dq10_28z if wave == 5
replace mem8rel = dq10_29z if wave == 5
replace mem9rel = dq10_210z if wave == 5

forvalues i = 1/12{
	gen mem`i'age = . 
}
replace mem1age = aq11_2ab if wave == 2
replace mem1age = aq11_2ab if wave == 2
replace mem2age = aq11_2bb if wave == 2
replace mem3age = aq11_2cb if wave == 2
replace mem4age = aq11_2db if wave == 2
replace mem5age = aq11_2eb if wave == 2
replace mem6age = aq11_2fb if wave == 2
replace mem7age = aq11_2gb if wave == 2
replace mem8age = aq11_2hb if wave == 2

replace mem1age = bq13_2bc if wave == 3
replace mem2age = bq13_2cc if wave == 3
replace mem3age = bq13_2dc if wave == 3
replace mem4age = bq13_2ec if wave == 3
replace mem5age = bq13_2fc if wave == 3
replace mem6age = bq13_2gc if wave == 3
replace mem7age = bq13_2hc if wave == 3
replace mem8age = bq13_2ic if wave == 3
replace mem9age = bq13_2jc if wave == 3
replace mem10age = bq13_2kc if wave == 3
replace mem11age = bq13_2lc if wave == 3
replace mem12age = bq13_2mc if wave == 3

replace mem1age = cq17bc if wave == 4
replace mem2age = cq17cc if wave == 4
replace mem3age = cq17dc if wave == 4
replace mem4age = cq17ec if wave == 4
replace mem5age = cq17fc if wave == 4
replace mem6age = cq17gc if wave == 4
replace mem7age = cq17hc if wave == 4
replace mem8age = cq17ic if wave == 4

replace mem1age = dq10_22c if wave == 5
replace mem2age = dq10_23c if wave == 5
replace mem3age = dq10_24c if wave == 5
replace mem4age = dq10_25c if wave == 5
replace mem5age = dq10_26c if wave == 5
replace mem6age = dq10_27c if wave == 5
replace mem7age = dq10_28c if wave == 5
replace mem8age = dq10_29c if wave == 5
replace mem9age = dq10_210c if wave == 5


forvalues i = 1/12{
	gen mem`i'child = .
forvalues j = 2/5{
	capture replace mem`i'child = 0 if mem`i'rel < 88888 & wave == `j'
	capture replace mem`i'child = 1 if mem`i'rel >= 500 & mem`i'rel < 600 & wave == `j'
}
}

gen numchild = 0 

forvalues i = 1/12{
	forvalues j = 2/5{
		capture replace numchild = numchild + mem`i'child if mem`i'child ~= . & wave == `j'
	}
}

forvalues j = 2/5{
	replace numchild = . if response == 0 & wave == `j'
	replace numchild = . if householdnum == 99 & wave == `j'
}

qui forvalues i=1/8{
		gen age`i'child = .
	forvalues j=2/5{
		capture replace age`i'child = mem`i'age if mem`i'child == 1 & wave == `j'
		capture replace age`i'child = . if mem`i'child == 0 & wave == `j'
		capture replace age`i'child = . if mem`i'child == . & wave == `j'
	}
}
	
gen ychild = .
qui forvalues j = 2/5{
	replace ychild = age1child if age1child ~= . & age1child < 999 & wave == `j'
}

qui forvalues i = 2/8{
	forvalues j = 2/5{
		replace ychild = age`i'child if age`i'child ~= . & age`i'child < 999 & age`i'child < ychild & wave == `j'
	}
}


** wave1における子ども人数と末子年齢の作成 *********************************************************************

*元号の区分：1"西暦""2"昭和"3"平成"8"非該当"9"無回答"
*wave1では、西暦で回答している場合は、下2ケタのみが入っている。wave6では4ケタすべて入っている。

** wave1子ども人数
replace numchild = zq14_31 if wave == 1
replace numchild = 0 if zq14_31 == 88 & wave == 1
replace numchild = . if zq14_31 == 99 & wave == 1


** wave1における1~6番目の子どもの年齢
qui forvalues i=1/6{
	replace age`i'child = 2007 - (1900 + 1 + zq14c`i'y) if zq14c`i'a == 1 & zq14c`i'y >= 89 & zq14c`i'y <= 99 & wave == 1
	replace age`i'child = 2007 - (2000 + 1 + zq14c`i'y) if zq14c`i'a == 1 & zq14c`i'y >= 0 & zq14c`i'y <= 7 & wave == 1
	replace age`i'child = 2007 - (1900 + 25 + 1 + zq14c`i'y) if zq14c`i'a == 2 & wave == 1
	replace age`i'child = 2007 - (1900 + 88 + 1 + zq14c`i'y) if zq14c`i'a == 3 & wave == 1
	replace age`i'child = . if numchild == . & wave == 1
	replace age`i'child = . if zq14c`i'y == 999 & wave == 1
}

** wave1末子年齢
qui forvalues i=1/6{
	replace ychild = age`i'child if numchild == `i'
}
replace ychild = . if numchild == 0 | numchild == .

replace ychild = 0 if ychild == -1 /*調査年と同年に生まれた者は0歳とみなす．2006年1~3月に生まれた子どもは1歳若くとっている可能性がある．*/

** wave6以降における子ども人数と末子年齢の作成 *********************************************************************
	
/*子ども人数*/
replace numchild = eq11s if wave == 6
replace numchild = fq09s if wave == 7
replace numchild = gq12s if wave == 8
replace numchild = hq12s if wave == 9
replace numchild = iq12s if wave == 10
replace numchild = jq11s if wave == 11
replace numchild = kq13s if wave == 12
replace numchild = lq13s if wave == 13
replace numchild = mq14s if wave == 14
replace numchild = nq12s if wave == 15
replace numchild = oq14s if wave == 16
replace numchild = pq15s if wave == 17

forvalues j = 6/$latestwave{
	replace numchild = 0 if numchild == 88 & wave == `j'
	replace numchild = . if numchild == 99 & wave == `j'
}


/*1番目から10番目の子どもの出生年*/	

qui forvalues i = 1/10{
	gen birthyearof`i'child = .
	capture replace birthyearof`i'child = eq11_`i'b if wave == 6  
	capture replace birthyearof`i'child = fq09_`i'b if wave == 7  
	capture replace birthyearof`i'child = gq12_`i'b if wave == 8  
	capture replace birthyearof`i'child = hq12_`i'b if wave == 9  
	capture replace birthyearof`i'child = iq12_`i'by if wave == 10  /*wave10からは月も尋ねるようになった．*/
	capture replace birthyearof`i'child = jq11_`i'by if wave == 11  /*wave10からは月も尋ねるようになった．*/
	capture replace birthyearof`i'child = kq13_`i'by if wave == 12  /*wave10からは月も尋ねるようになった．*/
	capture replace birthyearof`i'child = lq13_`i'by if wave == 13  /*wave10からは月も尋ねるようになった．*/
	capture replace birthyearof`i'child = mq14_`i'by if wave == 14  /*wave10からは月も尋ねるようになった．*/
	capture replace birthyearof`i'child = nq12_`i'by if wave == 15  /*wave10からは月も尋ねるようになった．*/
	capture replace birthyearof`i'child = oq14_`i'by if wave == 16  /*wave10からは月も尋ねるようになった．*/
	capture replace birthyearof`i'child = pq15_`i'ay if wave == 17  /*wave10からは月も尋ねるようになった．*/
	
	capture replace birthmonthof`i'child = iq12_`i'bm if wave == 10  /*wave10からは月も尋ねるようになった．*/
	capture replace birthmonthof`i'child = jq11_`i'bm if wave == 11  /*wave10からは月も尋ねるようになった．*/
	capture replace birthmonthof`i'child = kq13_`i'bm if wave == 12  /*wave10からは月も尋ねるようになった．*/
	capture replace birthmonthof`i'child = lq13_`i'bm if wave == 13  /*wave10からは月も尋ねるようになった．*/
	capture replace birthmonthof`i'child = mq14_`i'bm if wave == 14  /*wave10からは月も尋ねるようになった．*/
	capture replace birthmonthof`i'child = nq12_`i'bm if wave == 15  /*wave10からは月も尋ねるようになった．*/
	capture replace birthmonthof`i'child = oq14_`i'bm if wave == 16  /*wave10からは月も尋ねるようになった．*/
	capture replace birthmonthof`i'child = pq15_`i'am if wave == 17  /*wave10からは月も尋ねるようになった．*/

	gen gengoof`i'child = .
	capture replace gengoof`i'child = eq11_`i'a if wave == 6
	capture replace gengoof`i'child = fq09_`i'a if wave == 7
	capture replace gengoof`i'child = gq12_`i'a if wave == 8
	capture replace gengoof`i'child = hq12_`i'a if wave == 9
	capture replace gengoof`i'child = iq12_`i'a if wave == 10
	capture replace gengoof`i'child = jq11_`i'a if wave == 11
	capture replace gengoof`i'child = kq13_`i'a if wave == 12
	capture replace gengoof`i'child = lq13_`i'a if wave == 13
	capture replace gengoof`i'child = mq14_`i'a if wave == 14
	capture replace gengoof`i'child = nq12_`i'a if wave == 15
}

qui forvalues i=1/9{
	forvalues j = 6/15{
		capture replace age`i'child = (2006 + `j') - (1 + birthyearof`i'child) if gengoof`i'child == 1 & wave == `j'
		capture replace age`i'child = (2006 + `j') - (1900 + 25 + 1 + birthyearof`i'child) if gengoof`i'child == 2 & wave == `j'
		capture replace age`i'child = (2006 + `j') - (1900 + 88 + 1 + birthyearof`i'child) if gengoof`i'child == 3 & wave == `j'
		capture replace age`i'child = . if numchild`j' == . & wave == `j'
		capture replace age`i'child = . if birthyearof`i'child == 9999 & wave == `j'
	}
	*** wave 16以降は西暦しか尋ねなくなっているのでgengoは不要
	forvalues j = 16/$latestwave{
		capture replace age`i'child = (2006 + `j') - (1 + birthyearof`i'child) if wave == `j'
		capture replace age`i'child = . if numchild`j' == . & wave == `j'
		capture replace age`i'child = . if birthyearof`i'child == 9999 & wave == `j'		
	}
}
	
gen havechild = .
replace havechild = 0 if numchild == 0
replace havechild = 1 if numchild >= 1 & numchild <= 99
