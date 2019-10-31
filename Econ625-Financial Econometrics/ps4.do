clear all
set more off

/*****************
Description:
	 Problem Set #4 for Financial Econometrics
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home "C:\Users\Ryry\Documents\Ryan\USF\2019-Fall\Econ625_Fin_Econometrics\ps4\"
**************************************************************************
display "Analysis run by $USER for Problem Set #4 at `date' and `time'"

cd `home'
/************************
		Part 1:
************************/
use "`home'\firm.dta", clear
tsset trend

//		a)
//	CAPM Model
gen market_ret = A_ret + AT_ret + Z_ret + SP_ret
reg SP_ret market_ret

//		b)
// Rolling Regression
preserve
rolling, window(50) clear: reg SP_ret market_ret
tsset start
tsline _b_market_ret, name(rolling, replace)
/*
	There seems to be a state change around t = 60 and t = 120
*/
tsline _b_cons, name(rolling_constant, replace)
restore

//		c)
// Chow Test
tsline SP_ret, name(SP_ret, replace)
reg SP_ret market_ret
reg SP_ret market_ret if trend < 60
reg SP_ret market_ret if trend > 60

gen break_1 = (trend >= 60)
gen x_1 = break_1*market_ret

reg SP_ret market_ret break_1 x_1
test break_1 x_1
/*
	Close to a structural break, but no cigar
*/	

//		d)
// Structural Break Test
reg SP_ret market_ret
estat sbsingle, generate(wald)
tsline wald, name(structural_break, replace)
/*
	Structural break around t = 104
*/
//		e)
// TAR
gen state_1 = (l.market_ret >= 0)
gen state_2 = 1 - state_1
sum state_*
gen x_state_1 = state_1*l.SP_ret
gen x_state_2 = state_2*l.SP_ret

reg SP_ret state_1 x_state_1 state_2 x_state_2, noconstant
test state_1 = state_2
/*
	No significant difference in states
*/

//		f)
// Self Exciting TAR
gen self_exciting_1 = (l.SP_ret >= 0)
gen self_exciting_2 = 1 - self_exciting_1
gen x_self_exciting_1 = self_exciting_1*l.SP_ret
gen x_self_exciting_2 = self_exciting_2*l.SP_ret

reg SP_ret self_exciting_1 x_self_exciting_1 self_exciting_2 x_self_exciting_2
/*
	Appears there is some structrual difference for the second state self exciting interaction term.
*/

//		g)
// Simple AR(1)
nl (SP_ret = {a0} + {a1}*l.SP_ret) if trend > 2
// L-STAR
nl (SP_ret = {a0} + {a1}*l.SP_ret + {b1}*l.SP_ret/(1 + exp({gamma}*(l.market_ret)))) if trend > 2, initial(gamma 0.1 b1 .1)

/************************
		Part 2:
************************/
graph close

//		a)
dfuller SP_adjclose
dfuller SP_ret
/*
	Cointergration at Order 1
*/
reg SP_ret market_ret
predict SP_resid, resid

dfuller SP_resid
/*
	Passes the Engle Granger Test
	Co-integration exists
*/

//		b)
reg SP_ret market_ret l.SP_resid
