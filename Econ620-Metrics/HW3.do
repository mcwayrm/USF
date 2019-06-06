clear
set more off
log close _all
cap log using homework#3.log, text replace 

/*****************
Description:
	 Computer Assignments for Graduate Econometrics Homework #3: C1 and C3
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home "home"
local input	"home\raw"
local output "home\output"
**************************************************************************
display "Analysis run by $USER for Homework #3 at `date' and `time'"
cd "`home'"

//******** Computer Exercise C1
//(i)
use `input'\401K.dta, clear
describe
mean(prate)
mean(mrate)

//(ii)
reg prate mrate

//(iii)

//(iv)
di 83.07546+5.861079*3.5

//(v)
pwcorr prate mrate


//******** Computer Exercise C3
//(i)
use `input'\SLEEP75.dta, clear
describe
reg sleep totwrk

//(ii)
di 3586.377-.1507458*120
di (-.1507458)*120
di 18*52
di 936/60


cd "`output'"
cap log close
translate homework#3.log homework#3.pdf, replace
