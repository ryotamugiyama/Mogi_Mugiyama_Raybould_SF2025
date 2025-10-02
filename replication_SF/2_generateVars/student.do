
/*******
statusのコードは以下のとおり
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
*******/

gen status = jc_1 if wave == 1

local numwave = 1
foreach flag in $surveyflag2{
    local ++numwave
	replace status = `flag'q03_1 if wave == `numwave'
}

	gen student = 0 if status ~= .
	replace student = 1 if status == 11 | status == 12
	replace student = . if status == 99

drop status