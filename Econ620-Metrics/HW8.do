clear
set more off
clear matrix
clear mata
log close _all
cap log using homework#8.log, text replace 

/*****************
Description:
	 Computer Assignments for Graduate Econometrics Homework #8: C4, C6, C7, C9, C15
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home "<project folder>"
local input "`home'\input"
local output "`home'\output"
**************************************************************************
display "Analysis run by $USER for Homework #8 at `date' and `time'"
cd "`home'"

//******** Computer Exercise C4
//(i)
use `input'\\gpa2.dta, clear

//(ii)
reg colgpa hsize hsizesq hsperc sat female athlete

//(iii)
reg colgpa hsize hsizesq hsperc female athlete

//(iv)
gen f_athlete = female*athlete
reg colgpa hsize hsizesq hsperc sat female athlete f_athlete

//(v)
gen f_sat = female*sat
reg colgpa hsize hsizesq hsperc female sat f_sat athlete


//******** Computer Exercise C6
//(i)
use `input'\\SLEEP75.dta, clear
bysort male: reg sleep totwrk educ age agesq yngkid

//(ii)
reg sleep i.male##c.totwrk i.male##c.educ i.male##c.age i.male##c.agesq i.male##c.yngkid
contrast male i.male#c.totwrk i.male#c.educ i.male#c.age i.male#c.agesq i.male#c.yngkid, overall level(95) 

//(iii)
contrast i.male#c.totwrk i.male#c.educ i.male#c.age i.male#c.agesq i.male#c.yngkid, overall level(95)

//(iv)


//******** Computer Exercise C7
//(i)
use `input'\\WAGE1.dta, clear
gen f_educ = female*educ
reg lwage female educ f_educ exper expersq tenure tenursq
di -.227-.0056*12.5

//(ii)
replace f_educ= f_educ-12.5
reg lwage female educ f_educ exper expersq tenure tenursq

//(iii)


//******** Computer Exercise C9
//(i)
use `input'\\401ksubs.dta, clear
sum e401k

//(ii)
reg e401k inc incsq age agesq male
//(iii)

//(iv)
predict pred_e401k
sum pred_e401k

//(v)
gen fit_e401k = 1
replace fit_e401k = 0 if pred_e401k < .5
sum fit_e401k

//(vi)
tab fit_e401k if e401k == 0
tab fit_e401k if e401k == 1

//(vii)

//(viii)
reg e401k inc incsq age agesq male pira


//******** Computer Exercise C15
//(i)
use `input'\\FERTIL2.dta, clear
sum children
list if children == 2.267828

//(ii)
sum electric

//(iii)
bysort electric: sum children
reg children electric

//(iv)

//(v)
reg children electric age agesq educ urban spirit protest catholic

//(vi)
gen electric_educ = electric*educ
reg children electric educ electric_educ age agesq  urban spirit protest catholic

//(vii)
replace electric_educ = electric*(educ-7)
reg children electric educ electric_educ age agesq  urban spirit protest catholic


cd "`output'"
cap log close
translate homework#8.log homework#8.pdf, replace
