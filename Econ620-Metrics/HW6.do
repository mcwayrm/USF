clear
set more off
clear matrix
clear mata
log close _all
cap log using homework#6.log, text replace 

/*****************
Description:
	 Computer Assignments for Graduate Econometrics Homework #6: C2, C3, C6, C9, C10, C13
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home "<project folder>"
local input "`home'\input"
local output "`home'\output"
**************************************************************************
display "Analysis run by $USER for Homework #6 at `date' and `time'"
cd "`home'"

//******** Computer Exercise C2
//(i)
use `input'\\WAGE1.dta, clear
de
reg lwage educ exper expersq
//(ii)

//(iii)
di 100*(.0410089 - 2*4*.0007136)
di 100*(.0410089 - 2*19*.0007136)

//(iv)
di .041/[2*(.0007136)]
count if exper >= 29

//******** Computer Exercise C3
//(i)

//(ii)

//(iii)
use `input'\\WAGE2.dta, clear
gen educ_exper = educ*exper
reg lwage educ exper educ_exper

//(iv)
gen educ_exper_10 = educ*(exper-10)
reg lwage educ exper educ_exper_10


//******** Computer Exercise C6
//(i)

//(ii)
use `input'\\VOTE1.dta, clear
gen expendAB = expendA*expendB
reg voteA prtystrA expendA expendB expendAB

//(iii)
sum expendA
di (-.0317-.0000066*.3)

//(iv)

//(v)
reg voteA prtystrA expendA expendB shareA

//(vi)


//******** Computer Exercise C9
//(i)
use `input'\\nbasal.dta, clear
de
reg points exper expersq age coll
//(ii)
di 2.364/[2*.0770]
count if exper >= 15
count if exper >= 16

//(iii)

//(iv)
reg points exper expersq age agesq coll

//(v)
reg lwage points exper expersq age coll
//(vi)
test age coll, accumulate


//******** Computer Exercise C10
//(i)
use `input'\\bwght2.dta, clear
de
reg lbwght npvis npvissq

//(ii)
di .0189/[2*.00043]
count if npvis >= 22

//(iii)

//(iv)
reg lbwght npvis npvissq mage magesq
count
count if mage > 31
di 605/1832

//(v)

//(vi)
reg lbwght npvis npvissq mage magesq
reg bwght npvis npvissq mage magesq


//******** Computer Exercise C13
//(i)
use `input'\\meap00_01.dta, clear
de
reg math4 lexppp lenroll lunch

//(ii)
predict math4_resid, residuals
sum math4 math4_resid

//(iii)
list if (math4_resid > 50)

//(iv)
gen lunchsq = lunch^2
reg math4 lexppp lenroll lunch lunchsq


cd "`output'"
cap log close
translate homework#6.log homework#6.pdf, replace
