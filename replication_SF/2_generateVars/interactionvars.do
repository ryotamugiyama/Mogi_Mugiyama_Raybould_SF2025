
recode educ (1/3 = 0)(4 = 1), gen(college)
lab var college "University graduates"
lab def collegelab 0 "Non-college graduates" 1 "College graduates"
lab val college collegelab
