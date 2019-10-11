clear all
set more off

/*****************
Description:
	 Problem Set #3 for Financial Econometrics
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home "C:\Users\Ryry\Documents\Ryan\USF\2019-Fall\Econ625_Fin_Econometrics\ps3\"
**************************************************************************
display "Analysis run by $USER for Problem Set #3 at `date' and `time'"

cd `home'
/************************
		Part 1:
************************/
use "`home'\firm.dta", clear
tsset trend
//*****		a)
* For S&P Price

* With trend
dfuller SP_adjclose, trend

* With Drift
dfuller SP_adjclose, drift

* With Niether
dfuller SP_adjclose

//*****		b)
* For S&P Return

* With trend
dfuller SP_ret, trend

* With Drift
dfuller SP_ret, drift


* With Niether
dfuller SP_ret


//*****		c)
/*

*/

//*****		d)
/*

*/


/************************
		Part 2:
************************/

/*
	On Paper
*/

/************************
		Part 3:
************************/
freduse NASDAQCOM, clear
tsset daten
gen time = _n
drop if time < 12200
//*****		a)
dfuller NASDAQCOM // Uh Oh
dfuller d.NASDAQCOM // B E A UTIFUL...

* Daily Returns
gen NASDAQCOM_ret = d.NASDAQCOM/l.NASDAQCOM
dfuller NASDAQCOM_ret // We good

//*****		b)
ac NASDAQCOM_ret
pac NASDAQCOM_ret
quietly arima NASDAQCOM_ret, arima(1,0,0)
estat ic
quietly arima NASDAQCOM_ret, arima(0,0,1)
estat ic
quietly arima NASDAQCOM_ret, arima(1,0,1)
estat ic
quietly arima NASDAQCOM_ret, arima(1,0,2)
estat ic
quietly arima NASDAQCOM_ret, arima(0,0,2)
estat ic
/*
	Model Specification:
		Torn Between ARIMA(0,0,1) and ARIMA(0,0,2)
		Going to go with ARIMA(0,0,2)
*/

//*****		c)
* Ex Post Out of Sample forecast for 25 observations
quietly arima NASDAQCOM_ret if time <12675, arima(0,0,2)
predict arma02, dynamic(12675)
tsline arma02 NASDAQCOM_ret, xline(12675)