clear
set more off
clear matrix
clear mata
log close _all
cap log using homework#9.log, text replace 

/*****************
Description:
	 Computer Assignments for Graduate Econometrics Homework #9: C6, C12, C13, C14
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home "<project folder>"
local input "`home'\input"
local output "`home'\output"
**************************************************************************
display "Analysis run by $USER for Homework #9 at `date' and `time'"
cd "`home'"

//******** Computer Exercise C6
//(i)
use `input'\CRIME1.dta, clear
gen arr86 = 0 
replace arr86 = 1 if narr86 > 0
reg arr86 pcnv avgsen tottime ptime86
predict fitted
sum fitted

//(ii)
predict resid, residuals	
reg fitted resid
gen absres=abs(resid)
predict fitted2
gen weight= 1/(fitted2^2)
reg arr86 pcnv avgsen tottime ptime qemp [aweight=weight]
//(iii)
test avgsen tottime, accumulate


//******** Computer Exercise C12
//(i)
use `input'\meap00_01.dta, clear
reg math4 lunch lenroll lexppp
reg math4 lunch lenroll lexppp, robust

//(ii)
reg math4 lunch lenroll lexppp
whitetst, fitted

//(iii)
predict fitted
gen fitted2 = fitted^2
predict resid, residuals
gen lresid = log(resid^2)
reg lresid fitted fitted2
predict g
gen h = exp(g)
gen weight = 1/(h)
reg math4 lunch lenroll lexppp [aweight=weight]

//(iv)
reg math4 lunch lenroll lexppp [aweight=weight], robust

//(v)


//******** Computer Exercise C13
//(i)
use `input'\FERTIL2.dta, clear
reg children age agesq educ electric urban
reg children age agesq educ electric urban, robust

//(ii)
reg children age agesq educ electric urban protest catholic spirit
test protest catholic spirit, accumulate
reg children age agesq educ electric urban protest catholic spirit, robust
test protest catholic spirit, accumulate

//(iii)
reg children age agesq educ electric urban protest catholic spirit
predict fitted
gen fitted2 = fitted^2
predict resid, residuals
gen resid2 = resid^2
reg resid2 fitted fitted2
test fitted fitted2, accumulate

//(iv)


//******** Computer Exercise C14
//(i)
use `input'\beauty.dta, clear
reg lwage belavg abvavg female educ exper expersq, robust

//(ii)
gen f_belavg = female*belavg
gen f_abvavg = female*abvavg
gen f_educ = female*educ
gen f_exper = female*exper
gen f_expersq = female*expersq
reg lwage female belavg abvavg educ exper expersq f_belavg f_abvavg f_educ f_exper f_expersq
test f_belavg f_abvavg f_educ f_exper f_expersq, accumulate
reg lwage female belavg abvavg educ exper expersq f_belavg f_abvavg f_educ f_exper f_expersq, robust
test f_belavg f_abvavg f_educ f_exper f_expersq, accumulate

//(iii)
reg lwage female belavg abvavg educ exper expersq f_belavg f_abvavg f_educ f_exper f_expersq, robust
test f_belavg f_abvavg, accumulate


cd "`output'"
cap log close
translate homework#9.log homework#9.pdf, replace
