*** recent status

gen recentstatus = .
replace recentstatus = jl_1 if wave == 1 // 最後職。wave 1でのみ収集されている

*** job-seaerch activities

gen jobsearch = .
replace jobsearch = zq03_2 if wave == 1

local numwave = 1
foreach flag in $surveyflag2{
    local ++numwave
	replace jobsearch = `flag'q02_2 if wave == `numwave'
}

*** status

gen status = jc_1 if wave == 1

local numwave = 1
foreach flag in $surveyflag2{
    local ++numwave
	replace status = `flag'q03_1 if wave == `numwave'
}




*** recode status ************************************************

/*
statusのコードは以下のとおり．
1	経営者、役員
2	正社員・正職員
3	パート・アルバイト・契約・臨時・嘱託
4	派遣社員
5	請負社員
6	自営業主、自由業者
7	家族従業者
8	内職
9	その他
10	無職(学生は除く)
11	学生(働いていない)
12	学生(現在非正規で働いている)
88	非該当
99	無回答

** 190705修正：請負社員を非正規ではなく自営にいれる。雇用契約じゃないから
** 200420修正：どうやら請負社員はcontract employeeに近い。ちょっとこれを考慮して再リコード
*/

gen status1 = .
replace status1 = 1 if status == 1 | status == 2
replace status1 = 2 if status == 3
replace status1 = 2 if status == 4 | status == 5
replace status1 = 3 if status == 6 | status == 7 | status == 8
replace status1 = 4 if status == 88 // 無職なら非該当には入らないはずだが1つだけある
replace status1 = . if status == 9 | status == 99
replace status1 = 4 if status == 10 | status == 11
replace status1 = 2 if status == 12

lab var status1 "Employment status"
lab def status1lab ///
	1 "Regular employment" ///
	2 "Nonstandard employment" ///
	3 "Self-employed" ///
	4 "Without a job" 
lab val status1 status1lab

gen status2 = status1
replace status2 = 5 if status2 == 4 & jobsearch == 1
lab var status2 "Employment status"
lab def status2lab ///
	1 "Regular employment" ///
	2 "Nonstandard employment" ///
	3 "Self-employed" ///
	4 "Unemployment" /// 
	5 "Inactive"  
lab val status2 status2lab

gen status_student = status1
replace status_student = 5 if student == 1

lab var status_student "Employment status"
lab def status_studentlab ///
	1 "Regular employment" ///
	2 "Nonstandard employment" ///
	3 "Self-employed" ///
	4 "Unemployment" /// 
	5 "Enrolled in school"  

lab val status_student status_studentlab

