clear all
set more off
log close _all
cap log using ps#1.smcl, smcl replace 

/*****************
Description:
	 Problem Set #1 for Financial Econometrics
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home "<local>"
**************************************************************************
display "Analysis run by $USER for Problem Set #1 at `date' and `time'"

cd `home'
//*****	Part 1:

//*****		a)
foreach firm in A AT Z SP{
	import delimited `firm'.csv, varn(1) clear
	drop open high low close
	rename (adjclose volume) (`firm'_adjclose `firm'_vol)
	save `firm'.dta, replace
}
use A.dta, clear
foreach firm in AT Z SP{
	merge 1:1 date using `firm'.dta
	drop _merge
}
gen date_n = date(date, "YMD"), after(date)
format date_n %td
tsset date_n
gen trend = _n
tsset trend
	* Estimating returns
foreach firm in A AT Z SP{
	gen `firm'_ret = d.`firm'_adjclose/l.`firm'_adjclose, before(`firm'_adjclose)
}
sum *_ret
save firm.dta, replace

//*****		b)
freduse DTB3, clear
rename daten date_n
save tbill.dta, replace
use firm.dta, clear
merge 1:1 date_n using tbill.dta
drop _merge
drop if A_adjclose == .
	
//******	c)
foreach v in A AT Z SP DTB3{
	sum `v'*
}
foreach v in A AT Z SP{
	label var `v'_ret "`v' Return"
	label var `v'_adjclose "`v' Price"
}
tsline DTB3
	graph export DTB3.png, replace
tsline *_ret
	graph export returns.png, replace
tsline *_adjclose
	graph export prices.png, replace

//*****		d)
foreach firm in A AT Z{
	reg `firm'_ret SP_ret
	di "----------------------------------------------------------------------"
}
/**

**/

//****** Part 2:

//******	a)
freduse UNRATE FEDFUNDS, clear
gen t=_n
gen time = ym(1948,1)+t-1
tsset time
format time %tm

//******	b)
reg UNRATE time // Linear
gen log_UNRATE = log(UNRATE) 
reg log_UNRATE time // Exponential 
reg UNRATE time c.time#c.time // Quadratic
/**

**/

//******	c)
reg UNRATE time l.UNRATE c.time#c.time
/**

**/

//******	d)
egen month = seq(), to(12)
tab month, gen(m)
drop month
reg UNRATE time l.UNRATE c.time#c.time m*
/**

**/

//******	e)
reg UNRATE l(0/2).FEDFUNDS
test FEDFUNDS + l.FEDFUNDS + l2.FEDFUNDS = 0
/**

**/

//*****		f)
test l.FEDFUNDS l2.FEDFUNDS
/**

**/

//*****		g)
reg UNRATE l(0/2).FEDFUNDS
estat ic
reg UNRATE l(0/3).FEDFUNDS
estat ic
/**

**/
//*****		h)
reg UNRATE l.UNRATE FEDFUNDS
/**

**/

	
	
cap log close
translate ps#1.smcl ps#1.pdf, replace
