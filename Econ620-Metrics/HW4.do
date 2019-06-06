clear
set more off
clear matrix
clear mata
log close _all
cap log using homework#4.log, text replace 

/*****************
Description:
	 Computer Assignments for Graduate Econometrics Homework #4: C1, C2, C5, C8
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home "home"
local input	"home\raw"
local output "home\output"
**************************************************************************
display "Analysis run by $USER for Homework #4 at `date' and `time'"
cd "`home'"

//******** Computer Exercise C1
//(i)
use `input'\BWGHT.dta, clear
describe

//(ii)
pwcorr cigs faminc

//(iii)
reg bwght cigs faminc
reg bwght cigs

//******** Computer Exercise C2
//(i)
use `input'\hprice1.dta, clear
de
reg price sqrft bdrms

//(ii)

//(iii)
di 0.1284362*140+15.19819*1

//(iv)

//(v)
di -19.315+0.1284362*2438+15.19819*4

//(vi)
di 300+19.315-0.1284362*2438-15.19819*4


//******** Computer Exercise C5
//(i)
use `input'\WAGE1.dta, clear
de
reg educ exper tenure
predict r1, xb
reg lwage r1
reg lwage educ exper tenure


//******** Computer Exercise C8
//(i)
use `input'\discrim.dta, clear
de
sum prpblck income

//(ii)
reg psoda prpblck income

//(iii)
reg psoda prpblck income
reg psoda prpblck

//(iv)
reg lpsoda prpblck lincome
di 2*.1215803

//(v)
reg lpsoda prpblck lincome prppov

//(vi)
pwcorr lincome prppov

//(vii)


cd "`output'"
cap log close
translate homework#4.log homework#4.pdf, replace
