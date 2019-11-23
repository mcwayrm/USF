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
local home "C:\Users\Ryry\Documents\Ryan\USF\2019-Fall\Econ627_IDEC_Econometrics\ps3"
**************************************************************************
display "Analysis run by $USER for Problem Set #3 at `date' and `time'"
cd `home'

/******************************************	
		Part 1: Evaluation Assuming Random Program Placement
******************************************/
use hh_98.dta, clear

gen vill = thanaid * 10 + villid
/*
	lexptot, lnland, progvillm and progvillf were already defined when I imported the dataset
*/

ttest lexptot, by(progvillm)
/*
	No Statistical Difference between the two groups
*/
reg lexptot progvillm
/*
	Consistent Result
*/
reg lexptot progvillm sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg [pw = weight]
/*
	Still nothing
*/

ttest lexptot, by(dmmfd)
/*
	No Effect on participation
*/
reg lexptot dmmfd
/*
	Consistent Result
*/
reg lexptot dmmfd sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg [pw = weight]
/*
	An extra amount of nothing
*/

reg lexptot dmmfd progvillm sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg [pw = weight]
/*
	Unfortunately still nothing
*/

reg lexptot dmmfd if progvillm == 1 [pw = weight]
/*
	No effect for participation villages either
*/
reg lexptot dmmfd sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg if progvillm == 1 [pw = weight]
/*
	Controling for everything under the moon we still get a whole lot of nothing
*/

reg lexptot progvillm if dmmfd == 0 [pw = weight]
/*
	No spillovers from the null results 
*/
reg lexptot progvillm sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg if dmmfd == 0 [pw = weight]
/*
	Somehow, by a miricale, there is slight signal that there was some spillover to control yet no evidence of any effect on the treated. Very strange.
*/

/*
	Both had no real clear effect on placement, participation or spillovers. This microcredit program was pretty clearly non-effective
*/

/******************************************	
		Part 2: Treatment Effects
******************************************/

teffects ipw (lexptot) (dfmfd sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg), atet
/*
	Significant
	ipw is adjusting for the inverse probability weight.  This is correcting for missing data for potential outcomes.
*/
teffects ra (lexptot sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg) (dfmfd), atet
/*
	Significant
	ra is a regression adjustment which contrasts averages of treatment predicted outomes to estimate treatment effects. 
*/
/*
	Once adjusted, the results appear to be very significant. 
	ATE is over treatment and control while TOT is the difference on the treated. 
	So in these two regressions we find that within those who are treated, there is a difference in outcomes.
*/


/******************************************	
		Part 3: Propsensity Score and Covariate Matching
******************************************/

//****		a)
pscore dfmfd sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg [pw = weight], pscore(ps98) blockid(blockf1) comsup level(0.001)
/*
	Common Support: [.02576077, .71555996]
	Blocks: 4
	Balancing Property: Satisfied
*/
attnd lexptot dfmfd [pweight = weight], pscore(ps98) comsup
/*
	Significant. Effecet of 13.6%
*/
atts lexptot dfmfd, pscore(ps98) blockid(blockf1) comsup
/*
	Consistent
*/
attr lexptot dfmfd, pscore(ps98) radius(0.001) comsup
/*
	Consistent
*/
attk lexptot dfmfd, pscore(ps98) comsup bootstrap reps(50)
/*
	Consistent
*/

//****		b)
teffects nnmatch (lexptot sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg) (dfmfd), ate nneighbor(1)

teffects nnmatch (lexptot sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg) (dmmfd), ate nneighbor(1)
/*
	Seems to be significant and positive for women, but negative and insignificant for men. This makes sense if they were only targeting women. 
*/

//****		c)


foreach number in 1 2 3 4 5{
	teffects nnmatch (lexptot sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg) (dfmfd), ate nneighbor(`num')
}
/*
	More neighbors is closer to nearest neighbors with replacement. Fewer neighbors are more precise but if there is a large distance many neighbors may be needed to get a more accurate counterfactual.
*/

//****		d)
teffects nnmatch (lexptot sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg) (dfmfd), ate nneighbor(1) metric(euclidean)
teffects nnmatch (lexptot sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg) (dfmfd), ate nneighbor(1) metric(mahalanobis)
/*
	Mahalanobis vs Euclidean distance
	Euclidean distance is a linear z-score of the attributes which match to another observation which is closest in ranking. 
	Mahalanobis is very similar to Euclidean but it accounts for the correlation as well as the covariance between two observations
	Not much of a difference when adding in metric. The magnitude and the significance remain the same.
*/

/******************************************	
		Part 4: DAGs
******************************************/

//****		a)
/*
	regress Y on X + A
*/

//****		b)
/*
	regress Y on X + A + B + C
*/

//****		c)
/*
	regress Y on X + A + B
*/

//****		d)
/*
	regress Y on X
*/


*************************************************************
cap log close
cd `home'
translate ps3.smcl ps3.pdf, replace