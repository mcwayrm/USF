clear
set more off
clear matrix
clear mata
log close _all

/*****************
Description:
	Financial Econometrics Problem Set #2
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home "<local>"
**************************************************************************
display "Analysis run by $USER for Problem Set #1 at `date' and `time'"
cd "`home'"

//****	Part 1: Autocorrelation

//****		a)
freduse UNRATE FEDFUNDS, clear
gen t=_n
gen time = ym(1948,1)+t-1
tsset time
format time %tm

reg UNRATE FEDFUNDS
predict resid_model1, residuals
preserve
tsline resid_model1, name(eyeball_test, replace) // Eyeball Test
reg resid_model1 l.resid_model1 // Large Sample Test
restore
estat bgodfrey, lags(1/10)
reg UNRATE FEDFUNDS
durbina // Dubrin Watson Test
/*

*/

//****		b)
reg d.UNRATE d.FEDFUNDS
predict resid_model2, residuals
preserve
tsline resid_model2, name(eyeball_test2, replace) // Eyeball Test
reg resid_model2 l.resid_model2 // Large Sample Test
restore
estat bgodfrey, lags(1/10)
reg d.UNRATE d.FEDFUNDS
durbina // Dubrin Watson Test
/*
	
*/

//****		c)
prais UNRATE FEDFUNDS, corc
/*
	
*/

//****		d)
newey UNRATE FEDFUNDS, lag(2)
/*
	
*/

//****	Part 2: ARMA

//****		a)
use ps2arma_2019.dta, clear
graph close _all
foreach i in x1 x2 x3 x4{
	corrgram `i'
	ac `i', name(ac_`i', replace)
	pac `i', name(pac_`i', replace)
}

//****		b)
corrgram x1
/*
	
*/

//****		c)
/*
	
*/

//****		d)
/*
	
*/

//****		e)
tsset time
foreach i in x1 x2 x3 x4{
	arima `i', arima(1,0,0)
	predict resid_OG_`i', residuals
	estat ic
	outreg2 using `home'\part2.xls, dec(3) ctitle(OG `i'), replace
}
//****		f)
foreach i in x1 x2 x3 x4{
	arima `i', arima(1,0,0) // make three more variations loops
	predict resid_A1_`i', residuals
	estat ic
	outreg2 using `home'\part2.xls, dec(3) ctitle(Alt 1 `i'), append
}
foreach i in x1 x2 x3 x4{
	arima `i', arima(1,0,0)
	predict resid_A2_`i', residuals
	estat ic
	outreg2 using `home'\part2.xls, dec(3) ctitle(Alt 2 `i'), append
}
foreach i in x1 x2 x3 x4{
	arima `i', arima(1,0,0)
	predict resid_A3_`i', residuals
	estat ic
	outreg2 using `home'\part2.xls, dec(3) ctitle(Alt 3 `i'), append	
}
stop
/*

*/

//****		g)
foreach i in resid_OG_x1 resid_OG_x2 resid_OG_x3 resid_OG_x4{
	corrgram `i'
}
foreach i in resid_A1_x1 resid_A1_x2 resid_A1_x3 resid_A1_x4{
	corrgram `i'
}
foreach i in resid_A2_x1 resid_A2_x2 resid_A2_x3 resid_A2_x4{
	corrgram `i'
}
/*
	Final Models:
	X1:
	X2:
	X3:
*/

//****	Part 3: White Noise Asset Returns

//****		a)
use "C:\Users\Ryry\Documents\Ryan\USF\2019-Fall\Econ625_Fin_Econometrics\ps1\firm.dta", clear
tsset date_n
foreach i in A_ret AT_ret Z_ret{
	wntstmvq `i'
	wntestq `i'
}

//****		b)
foreach i in A_ret AT_ret Z_ret{
	arima `i', arima(1,1,0)
}
