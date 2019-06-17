clear
set more off
log close _all

/*****************
Description:
	 Regressions for Love Experiment
		OLS Dictator Game
		OLS Risk Game
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
display "Analysis run by $USER running OLS for Dictator and Risk Game at `date' and `time'"

use `edit'\\master.dta, clear

// Dictator Game
//**** Generosity is measured by the amount they give away (Sent)
reg Dict_Sent lgbtq
	outreg2 using `output'\\dictator.xls, excel ctitle("Dictator: LGBTQ") addstat(Adjusted R^2, e(r2_a), F-test, e(F)) replace
reg Dict_Sent lgbtq Female Female_lgbtq Age LGBTQ_Church Love forever_single dating Long_Term_Relat Recent_Breakup
	outreg2 using `output'\\dictator.xls, append ctitle("Dictator: Controls") addstat(Adjusted R^2, e(r2_a), F-test, e(F))
reg Dict_Sent risk_avg
	outreg2 using `output'\\dictator.xls, append ctitle("Dictator: Via Risk") addstat(Adjusted R^2, e(r2_a), F-test, e(F))
reg Dict_Sent risk_avg lgbtq Age LGBTQ_Church Female Female_lgbtq Love forever_single dating Long_Term_Relat Recent_Breakup
	outreg2 using `output'\\dictator.xls, append ctitle("Dictator: Via Risk w/ Controls") addstat(Adjusted R^2, e(r2_a), F-test, e(F))
	
// Risk Game OLS
reg risk_avg lgbtq
	outreg2 using `output'\\risk_OLS.xls, excel addstat(Adjusted R^2, e(r2_a), F-test, e(F)) ctitle("Risk: Avg") replace
reg risk_avg lgbtq Age LGBTQ_Church Female Female_lgbtq Love forever_single dating Long_Term_Relat Recent_Breakup
	outreg2 using `output'\\risk_OLS.xls, append ctitle("Risk: Avg w/ Controls") addstat(Adjusted R^2, e(r2_a), F-test, e(F))
reg risk_per_1 lgbtq
	outreg2 using `output'\\risk_OLS.xls, append ctitle("Risk: 1st Period") addstat(Adjusted R^2, e(r2_a), F-test, e(F))
reg risk_per_1 lgbtq Age LGBTQ_Church Female Female_lgbtq Love forever_single dating Long_Term_Relat Recent_Breakup
	outreg2 using `output'\\risk_OLS.xls, append ctitle("Risk: 1st Period w/ Controls") addstat(Adjusted R^2, e(r2_a), F-test, e(F))
reg risk_per_2 lgbtq
	outreg2 using `output'\\risk_OLS.xls, append ctitle("Risk: 2nd Period") addstat(Adjusted R^2, e(r2_a), F-test, e(F))
reg risk_per_2 lgbtq Age LGBTQ_Church Female Female_lgbtq Love forever_single dating Long_Term_Relat Recent_Breakup
	outreg2 using `output'\\risk_OLS.xls, append ctitle("Risk: 2nd Period w/ Controls") addstat(Adjusted R^2, e(r2_a), F-test, e(F))
reg risk_per_3 lgbtq
	outreg2 using `output'\\risk_OLS.xls, append ctitle("Risk: 3rd Period") addstat(Adjusted R^2, e(r2_a), F-test, e(F))
reg risk_per_3 lgbtq Age LGBTQ_Church Female Female_lgbtq Love forever_single dating Long_Term_Relat Recent_Breakup
	outreg2 using `output'\\risk_OLS.xls, append ctitle("Risk: 3rd Period w/ Controls") addstat(Adjusted R^2, e(r2_a), F-test, e(F))

