clear
set more off
clear matrix
clear mata
log close _all
cap log using homework#10.smcl, smcl replace 

/*****************
Description:
	 Computer Assignments for Graduate Econometrics Homework #10: C10, C11
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home "local"
local input	"`home'\input"
local output "`home'\output"
**************************************************************************
display "Analysis run by $USER for Homework #10 at `date' and `time'"
cd "`home'"

//******** Computer Exercise C10
//(i)
use `input'\\JTRAIN2.dta, clear
sum train

use `input'\\JTRAIN3.dta, clear
sum train

//(ii)
use `input'\\JTRAIN2.dta, clear
reg re78 train

//(iii)
reg re78 train re74 re75 educ age black hisp

//(iv)
use `input'\\JTRAIN3.dta, clear
reg re78 train
reg re78 train re74 re75 educ age black hisp

//(v)
use `input'\\JTRAIN2.dta, clear
gen avgre = (re74 + re75)/2
sum avgre

use `input'\\JTRAIN3.dta, clear
sum avgre

//(vi)
use `input'\\JTRAIN2.dta, clear
gen avgre = (re74 + re75)/2
reg re78 train re74 re75 educ age black hisp if avgre <= 10

use `input'\\JTRAIN3.dta, clear
reg re78 train re74 re75 educ age black hisp if avgre <= 10

//(vii)
use `input'\\JTRAIN2.dta, clear
reg re78 train if (unem74 == 1 & unem75 == 1)
use `input'\\JTRAIN3.dta, clear
reg re78 train if (unem74 == 1 & unem75 == 1)

//(viii)


//******** Computer Exercise C11
//(i)
use `input'\\MURDER.dta, clear
gen mrdrte_lag = mrdrte[_n-1]
reg mrdrte exec unem

//(ii)
tab exec if state == "TX"
tab exec if state != "TX"
gen TX = 0
replace TX = 1 if state == "TX"
reg mrdrte exec unem TX

//(iii)
reg mrdrte exec unem mrdrte_lag TX

//(iv)
reg mrdrte exec unem mrdrte_lag TX
reg mrdrte exec unem mrdrte_lag


cd "`output'"
cap log close
translate homework#10.smcl homework#10.pdf, replace
