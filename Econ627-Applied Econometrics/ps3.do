clear
set more off
clear matrix
clear mata
log close _all
cap log using ps3.smcl, smcl replace 

/*****************
Description:
	Applied Econometrics for IDEC Problem Set #3
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home "<local>"
**************************************************************************
display "Analysis run by $USER for Problem Set #3 at `date' and `time'"
cd `home'

/******************************************	
		Part 1: Evaluation Assuming Random Program Placement
******************************************/
use hh_98.dta, clear

gen vill = thanaid * 10 + villid
/*

*/

ttest lexptot, by(progvillm)
/*

*/
reg lexptot progvillm
/*

*/
reg lexptot progvillm sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg [pw = weight]
/*

*/

ttest lexptot, by(dmmfd)
/*

*/
reg lexptot dmmfd
/*

*/
reg lexptot dmmfd sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg [pw = weight]
/*

*/

reg lexptot dmmfd progvillm sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg [pw = weight]
/*

*/

reg lexptot dmmfd if progvillm == 1 [pw = weight]
/*

*/
reg lexptot dmmfd sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg if progvillm == 1 [pw = weight]
/*

*/

reg lexptot progvillm if dmmfd == 0 [pw = weight]
/*

*/
reg lexptot progvillm sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg if dmmfd == 0 [pw = weight]
/*

*/

/*
*/

/******************************************	
		Part 2: Treatment Effects
******************************************/

teffects ipw (lexptot) (dfmfd sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg), atet
/*
*/
teffects ra (lexptot sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg) (dfmfd), atet
/*
*/
/*
*/


/******************************************	
		Part 3: Propsensity Score and Covariate Matching
******************************************/

//****		a)
pscore dfmfd sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg [pw = weight], pscore(ps98) blockid(blockf1) comsup level(0.001)
/*

*/
attnd lexptot dfmfd [pweight = weight], pscore(ps98) comsup
/*

*/
atts lexptot dfmfd, pscore(ps98) blockid(blockf1) comsup
/*

*/
attr lexptot dfmfd, pscore(ps98) radius(0.001) comsup
/*

*/
attk lexptot dfmfd, pscore(ps98) comsup bootstrap reps(50)
/*

*/

//****		b)
teffects nnmatch (lexptot sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg) (dfmfd), ate nneighbor(1)

teffects nnmatch (lexptot sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg) (dmmfd), ate nneighbor(1)
/*
*/

//****		c)


foreach number in 1 2 3 4 5{
	teffects nnmatch (lexptot sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg) (dfmfd), ate nneighbor(`num')
}
/*
*/

//****		d)
teffects nnmatch (lexptot sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg) (dfmfd), ate nneighbor(1) metric(euclidean)
teffects nnmatch (lexptot sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg) (dfmfd), ate nneighbor(1) metric(mahalanobis)
/*
*/

/******************************************	
		Part 4: DAGs
******************************************/

//****		a)
/*

*/

//****		b)
/*

*/

//****		c)
/*

*/

//****		d)
/*

*/


*************************************************************
cap log close
cd `home'
translate ps3.smcl ps3.pdf, replace
