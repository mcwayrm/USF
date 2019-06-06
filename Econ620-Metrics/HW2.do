clear
set more off
log close _all
cap log using homework#2.log, text replace 

/*****************
Description:
	 Assignments for Graduate Econometrics Homework #2: C1, C2, C5
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home "home"
local input	"home\raw"
local output "home\output"
local edit "home\edit"
**************************************************************************
display "Analysis run by $USER for Homework #2 at `date' and `time'"
cd "`home'"

//******** Computer Exercise C1
//(i)
use `input'\WAGE1.dta, clear
describe
sort educ
tabstat(educ), s(mean, min, max)

//(ii)
tabstat(wage), s(mean, sd, min, max)

//(v)
count if female == 0
count if female == 1

//******** Computer Exercise C2
//(i)
use `input'\BWGHT.dta, clear
describe
count if male == 0
count if male == 0 & cigs != 0
count if male == 0 & packs != 0

//(ii)
tabstat(cigs), s(mean)
tabstat(cigs) if male == 0, s(mean) 
ttest cigs, by(male)

//(iii)
tabstat(cigs) if (male == 0 & cigs != 0), s(mean)

//(iv)
sum(fatheduc)
tabstat(fatheduc), s(mean)
count if male == 1
count if fatheduc !=.

//(v)
tabstat(faminc), s(mean, sd)
sort faminc


//******** Computer Exercise C5
//(i)
use `input'\FERTIL2.dta
describe
tabstat(children), s(mean, min, max)

//(ii)
tabstat(electric), s(mean)

//(iii)
tabstat(children) if electric == 0, s(mean)
tabstat(children) if electric == 1, s(mean)

cd "`output'"
cap log close
translate homework#2.log homework#2.pdf, replace
