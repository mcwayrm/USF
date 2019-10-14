clear all
set more off

/*****************
Description:
	 Project 1 for Financial Econometrics
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home "<local>"
**************************************************************************
display "Analysis run by $USER for Project #1 at `date' and `time'"

cd `home'
/************************
		Part 1: Choose Daily Return
************************/
use "`home'\firm.dta", clear
sort date_n
save "`home'\firm.dta", replace

/************************
		Part 2: Check Stationrity
************************/
dfuller A_ret
// Stationary. We're good!

/************************
		Part 3: ADL Model
************************/
/* Controls: SP Return, T-bill yield, asset volume, trend.
	Optimize AIC
*/
use "`home'\tbill.dta", clear
drop if date_n < 21431
merge date_n using "`home'\firm.dta"
drop _merge
tsset date_n

quietly reg A_ret l.A_ret SP_ret A_vol trend DTB3
estat ic 
quietly reg A_ret l.A_ret l(0/1).SP_ret l(0/1).A_vol l(0/1).trend l(0/1).DTB3
estat ic
quietly reg A_ret l.A_ret l(0/2).SP_ret l(0/2).A_vol l(0/2).trend l(0/2).DTB3
estat ic

// The first model has best IC so that is my model fit for an ADL.


/************************
		Part 4: Include a Day of Week Dummy
************************/
gen week = dow(date_n)
quietly reg A_ret l.A_ret SP_ret A_vol trend DTB3
estat ic
reg A_ret l.A_ret SP_ret A_vol trend DTB3 week
estat ic
// While it isn't significant, it does seem to improve our forecasting ability.

/************************
		Part 5: ARMA Model
************************/
quietly arima A_ret, arima(1,0,0)
estat ic
quietly arima A_ret, arima(0,0,1)
estat ic
quietly arima A_ret, arima(1,0,1)
estat ic
quietly arima A_ret, arima(2,0,1)
estat ic
quietly arima A_ret, arima(1,0,2)
estat ic
quietly arima A_ret, arima(2,0,2)
estat ic
/*
	Either an ARMA(1,0) or ARMA(0,1)
*/


/************************
		Part 6: Ex Post Forecast for 5 steps
************************/
* Ex Post Out of Sample forecast for 5 observations
quietly arima A_ret if date_n <21791, arima(1,0,0)
predict arma10, dynamic(21791)
tsline arma10 A_ret if date_n > 21600, xline(21791)

/************************
		Part 7: Estimate GARCH Heteroscedatisicity in ARMA Model
************************/
arch A_ret, ar(1/1) arch(1/1) garch(1/1)
// Yes, there appears be evidence of heteorskadasitc error terms and justification for both a garch model.
