gen zq02 = zq03 

gen work = .
local numwave = 0
foreach flag in $surveyflag{
    local ++numwave
	replace work = `flag'q02 if wave == `numwave'
}

recode work (2=0)(1=1)(9=.)

lab var work "Having a job"