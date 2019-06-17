clear
set more off
log close _all

/*****************
Description:
	 Regressions for Love Experiment
		Create Panel Data
		Random Effects for Risk Game
*****************/

global USER "The Love Experts"
local date `c(current_date)'
local time `c(current_time)'
local home "<project folder>"
//***** All paths should be relative so that all you need to change is `home' in order to run the dofile.
cd "`home'"
local input "`home'\input"
local edit "`home'\edit"
local output "`home'\output"
**************************************************************************
display "Analysis run by $USER panel data for Risk Game at `date' and `time'"

use `edit'\\master.dta, clear

// Reshape into Panel format
foreach x in 1 2 3 4 5 6 7 8 9{
	generate choice`x'=Risk_Lot_`x' 
}
reshape long choice , i(Subject_ID) j(round)
label define z 1 "Round 1" 2 "Round 2" 3 "Round 3" 4 "Round 4" 5 "Round 5" 6 "Round 6" 7 "Round 7" 8 "Round 8" 9 "Round 9"
label values round z

foreach x in 1 2 3 4 5 6 7 8 9{
	generate round`x'= 0
	replace round`x'= 1 if round==`x'
}

// Set Panel and Save
xtset Subject_ID round

gen lag_shock = .
replace lag_shock = 1 if (round == 2 & Risk_Head_1 == 1)
replace lag_shock = 0 if (round == 2 & Risk_Head_1 == 0)
replace lag_shock = 1 if (round == 3 & Risk_Head_2 == 1)
replace lag_shock = 0 if (round == 3 & Risk_Head_2 == 0)
replace lag_shock = 1 if (round == 4 & Risk_Head_3 == 1)
replace lag_shock = 0 if (round == 4 & Risk_Head_3 == 0)
replace lag_shock = 1 if (round == 5 & Risk_Head_4 == 1)
replace lag_shock = 0 if (round == 5 & Risk_Head_4 == 0)
replace lag_shock = 1 if (round == 6 & Risk_Head_5 == 1)
replace lag_shock = 0 if (round == 6 & Risk_Head_5 == 0)
replace lag_shock = 1 if (round == 7 & Risk_Head_6 == 1)
replace lag_shock = 0 if (round == 7 & Risk_Head_6 == 0)
replace lag_shock = 1 if (round == 8 & Risk_Head_7 == 1)
replace lag_shock = 0 if (round == 8 & Risk_Head_7 == 0)
replace lag_shock = 1 if (round == 9 & Risk_Head_8 == 1)
replace lag_shock = 0 if (round == 9 & Risk_Head_8 == 0)

save `edit'\\panel.dta, replace

// Random Effects Regression
xtreg choice round2 round3 round4 round5 round6 round7 round8 round9 lgbtq
	outreg2 using `output'\\risk_panel.xls, excel ctitle("Risk: Panel") addstat(R^2, e(r2_o), Chi^2, e(chi2)) addtext(Random Effects, YES) replace
xtreg choice round2 round3 round4 round5 round6 round7 round8 round9 lgbtq Age LGBTQ_Church Love Female Female_lgbtq forever_single dating Long_Term_Relat Recent_Breakup
	outreg2 using `output'\\risk_panel.xls, append ctitle("Risk: Panel w/ Controls") addstat(R^2, e(r2_o), Chi^2, e(chi2)) addtext(Random Effects, YES)
xtreg choice round3 round4 round5 round6 round7 round8 round9 lgbtq lag_shock
	outreg2 using `output'\\risk_panel.xls, excel append ctitle("Risk: Panel w/ Lag") addstat(R^2, e(r2_o), Chi^2, e(chi2)) addtext(Random Effects, YES)
xtreg choice round3 round4 round5 round6 round7 round8 round9 lgbtq lag_shock Age LGBTQ_Church Love Female Female_lgbtq forever_single dating Long_Term_Relat Recent_Breakup
	outreg2 using `output'\\risk_panel.xls, excel append ctitle("Risk: Panel w/ Lag and Controls") addstat(R^2, e(r2_o), Chi^2, e(chi2)) addtext(Random Effects, YES)

