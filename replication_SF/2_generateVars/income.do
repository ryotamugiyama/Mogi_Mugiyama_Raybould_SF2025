gen income = .

replace income = zq47a if wave == 1
replace income = aq48a if wave == 2
replace income = bq36a if wave == 3
replace income = cq37a if wave == 4
replace income = dq35a if wave == 5
replace income = eq34a if wave == 6
replace income = fq38a if wave == 7
replace income = gq36a if wave == 8
replace income = hq37a if wave == 9
replace income = iq37a if wave == 10
replace income = jq35a if wave == 11
replace income = kq38a if wave == 12
replace income = lq37a if wave == 13
replace income = mq38a if wave == 14
replace income = nq35a if wave == 15
replace income = oq38a if wave == 16
replace income = pq45a if wave == 17


/*top coded income*/
recode income (1=0)(2=12.5)(3=50)(4=112.5)(5=200)(6=300)(7=400)(8=525)(9=725)(10=1050)(11=1500)(12=2000)(13=2250)(14=.)(99 = .)

replace income = income * 1.4 if income == 2250

replace income = income * 10

lab var income "Income (thousand JPY)"
