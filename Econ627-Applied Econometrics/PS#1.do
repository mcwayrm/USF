clear
set more off
clear matrix
clear mata
log close _all
cap log using ps1.smcl, smcl replace 

/*****************
Description:
	Applied Econometrics for IDEC Problem Set #1
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home <local>"
**************************************************************************
display "Analysis run by $USER for Problem Set #1 at `date' and `time'"
cd "`home'"

//****	Part 1: Cleaning

//****		a)
use woodstove.dta, clear
drop if _n > 287

//****		b)
label var hheadoccupation "occupation of head of household"

//****		c)	
gen work = .
replace work = 1 if (hheadoccupation == "government official" | hheadoccupation == "pastor" |  hheadoccupation == "schoolteacher" | hheadoccupation == "secretary" | hheadoccupation == "teach" | hheadoccupation == "teach school" | hheadoccupation == "teacher")
replace work = 2 if (hheadoccupation == "bricklayer" | hheadoccupation == "police" |hheadoccupation == "carpinter" | hheadoccupation == "carpintr" | hheadoccupation == "construction" | hheadoccupation == "laborer" | hheadoccupation == "mechanic" | hheadoccupation == "woodsman")
replace work = 3 if (hheadoccupation == "coffee picker" | hheadoccupation == "coffeefarmer" | hheadoccupation == "coffeefarming" | hheadoccupation == "coffeeworker")
label var work "type of job"


//****		d)
label define worktype 1 "whitecollar" 2 "blue collar" 3 "agriculture"
label values work worktype

//****		e)
gen whitecollar = 0
replace whitecollar = 1 if work == 1

//****		f)
foreach var of varlist cargasday coughdays backpaindays{
	reg `var' stove1 whitecollar
	outreg2 using `home'\part1.xls, dec(3) append
}

//****		g)
/*

*/

//****	Part 2: Time Series

//****		a)
use `home'\WDI_FDI_data.dta, clear
drop if countrycode != "MEX"
sort year
tsset year
reg gdp_pc_gr year
estat dwatson
durbina
/*

*/

//****		b)
reg gdp_pc_gr l.gdp_pc_gr // Random Walk
reg gdp_pc_gr l.gdp_pc_gr year // Random Walk with time trend
tsline gdp_pc_gr if year >= 1960, name(tsline_gdp_pc_gr, replace) saving(tsline_gdp_pc_gr.pdf, replace) 
	graph export tsline_gdp_pc_gr.pdf, replace
dfuller gdp_pc_gr, lags(1)

/*

*/


//****		c) 

corrgram gdp_pc_gr
ac gdp_pc_gr, name(ac_gdp_pc_gr, replace)
pac gdp_pc_gr, name(pac_gdp_pc_gr, replace)
arima gdp_pc_gr, arima(1,0,1)
estat ic
arima gdp_pc_gr, arima(1,0,0)
estat ic
arima gdp_pc_gr, arima(0,0,0)
estat ic

arima gdp_pc_gr, arima(1,0,0)
count
local plus5 = r(N) + 5
set obs `plus5'
replace year = year[_n-1]+1 in 67/71 
sort year
tsset year
capture drop mexfrcst
predict mexfrcst if tin(1960,2020)
twoway (tsline gdp_pc_gr if year >= 1960) (tsline mexfrcst) if year >= 1960, title(Mexico Per Capita GDP + Forecast) subtitle(1960-2015) name(mexfrcst, replace) xline(2015) saving(mexfrcst.pdf, replace)
	graph export mexfrcst.pdf, replace 

/*

*/

//****		d)
var gdp_pc_gr fdi_pcgdp
vargranger

/*
	
*/

//****		e)
itsa gdp_pc_gr fdi_pcgdp, single trperiod(1994) lag(1)
drop _t _x1994 _x_t1994 _s_gdp_pc_gr_pred 
itsa gdp_pc_gr, single trperiod(1994) lag(1)
drop _t _x1994 _x_t1994 _s_gdp_pc_gr_pred 
itsa fdi_pcgdp, single trperiod(1994) lag(1)
/*

*/

//****	Part 3: Granger Causality

//****		a)
use WDI_FDI_data.dta, clear
sort imfcode year
tsset imfcode year
xtunitroot fisher gdp_pc_gr, dfuller lags(1)
/*

*/

//****		b)
xtreg gdp_pc_gr l.gdp_pc_gr l2.gdp_pc_gr l.fdi_pcgdp l2.fdi_pcgdp i.year if year >= 1970, fe i(imfcode) cluster(imfcode)
test l.fdi_pcgdp=l2.fdi_pcgdp=0
/*

*/ 

//****		b(the second)
xtreg fdi_pcgdp l.gdp_pc_gr l2.gdp_pc_gr l.fdi_pcgdp l2.fdi_pcgdp i.year if year >= 1970, fe i(imfcode) cluster(imfcode)
test l.gdp_pc_gr=l2.gdp_pc_gr=0
/*

*/

//****	Part 4: Panel Data

//****		a)
use woodstove.dta, clear
foreach v of varlist educ weaknessdays diarrheadays coughdays mucusdays redeyedays backpaindays faintdays feverdays{
	loneway (`v' hh_id) if year == 2008
}
/*

*/
//****		b)
xtreg repcoughing educ female age age2, i(hh_id)
xtreg repcoughing educ female age age2, fe i(hh_id)
estimates store fe
xtreg repcoughing educ female age age2, re i(hh_id)
estimates store re 
/*

*/

//****		c)
hausman fe re 
/*

*/

//****	Part 5: Binary Dependent Variables

//****		a)
use woodstove.dta, clear

reg repcoughing openfire female child age
logit repcoughing openfire female child age
probit repcoughing openfire female child age


//****		b)
logit repcoughing openfire female child age
margins, dydx(*)
/*

*/

//****		c)
test age=female=child=0
/*

*/

//****		d)
logit repcoughing openfire female child age 
estimates store m1
logit repcoughing openfire if female != . & child != . & age != .
estimates store m2
lrtest m1 m2 
/*

*/

//****		e)
gen backpain = .
replace backpain = 1 if backpaindays > 0 & backpaindays != .
use woodstove.dta, clear
logit backpain openfire female age age2
estimates store m1
logit backpain openfire if female != . & age2 != . & age != .
estimates store m2
lrtest m1 m2
/*

*/

//****	Part 6: Indicies

//****		a)
use woodstove.dta, clear
foreach i in coughdays diarrheadays mucusdays feverdays{
	gen `i'_nm = `i' if (`i' != .)
		sum `i'_nm
		replace `i'_nm = r(mean) if (`i'== .)
		gen normalized_`i'= .
		replace normalized_`i' = (`i'_nm - r(mean))/r(sd)
		sum normalized_`i'
}
	// This is a Kling Index. Aren't you proud!
gen nonstd_index = -normalized_coughdays - normalized_diarrheadays - normalized_mucusdays - normalized_feverdays
sum nonstd_index
egen std_index = std(nonstd_index)

corr coughdays_nm diarrheadays_nm mucusdays_nm feverdays_nm

//****		b)
		// This is an Anderson Index
mkmat coughdays_nm diarrheadays_nm mucusdays_nm feverdays_nm, matrix (Ytilda)
matrix sigma = Ytilda' * Ytilda
matrix ones = J(4,1,1)
matrix S = invsym(ones' * invsym(sigma) * ones)*(ones' * invsym(sigma) * Ytilda')
matrix Stranspose = S'
svmat Stranspose, name(surveySI)
egen health_index = std(surveySI)

//****		c)
reg health_index stove1 age age2 female 
/*
	
*/

*************************************************************
cap log close
cd `home'
translate ps1.smcl ps1.pdf, replace
