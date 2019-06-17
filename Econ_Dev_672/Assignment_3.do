*****************************************************************************************************

clear
set more off
log close _all
cap log using Assignment_3.log, text replace 

/**************************************
		Assignment 3
		Economics of Development
		Ryan McWay, Lauren Lamson, Anna Subirana, Zhenyao Yuan, Katie Roett
**************************************/

/*****************
Description:
	 This assignment is a replication of The Colonial Origins of Comprative
	 Development: An Empirical Invesigation, by Acemogulu et al. 
*****************/

global USER "Team CRAKL"
local date `c(current_date)'
local time `c(current_time)'
local input "<input folder>"
local output "<output folder>"
local edit "<edit folder>"
**************************************************************************
display "Analysis run by $USER for Assignment 3 at `date' and `time'"

/*****************
	 Question 1: Overview
*****************/

//**************** This question was done seperately and is an attached PDF.

/*****************
	 Question 2: Emprics
*****************/

//********** Part 1

use "`input'\colonialorigins1.dta", clear
br
describe
egen rank = rank(extmort4), track
label var rank "Ranking of Mortality Rates"
egen count = count(extmort4)
label var count "Total countries in Mort. Ranking"
gen ptile = rank/count 
label var ptile "Percentile Ranking for Mort."
gen q = .
label var q "Quartile for Percentile Mort Ranking"
replace q = 1 if ptile <= .25
replace q = 2 if (ptile > .25 & ptile <= .5)
replace q = 3 if (ptile > .5 & ptile <= .75)
replace q = 4 if (ptile > .75 & ptile != .)
tab q

//*********** Table 1
tabstat logpgp95, stat(mean)
tabstat logpgp95 if baseco == 1, stat(mean)
tabstat logpgp95, stat(mean) by (q)

tabstat loghjypl, stat(mean)
tabstat loghjypl if baseco == 1, stat(mean)
tabstat loghjypl, stat(mean) by (q)

tabstat avexpr, stat(mean)
tabstat avexpr if baseco == 1, stat(mean)
tabstat avexpr, stat(mean) by (q)

//*********** There is no variable for Constraint on Exec. in 1990.

tabstat cons00a, stat(mean)
tabstat cons00a if baseco == 1, stat(mean)
tabstat cons00a, stat(mean) by (q)

tabstat cons1, stat(mean)
tabstat cons1 if baseco == 1, stat(mean)
tabstat cons1, stat(mean) by (q)

tabstat democ00a, stat(mean)
tabstat democ00a if baseco == 1, stat(mean)
tabstat democ00a, stat(mean) by (q)

tabstat euro1900, stat(mean)
tabstat euro1900 if baseco == 1, stat(mean)
tabstat euro1900, stat(mean) by (q)

tabstat logem4, stat(mean)
tabstat logem4 if baseco == 1, stat(mean)
tabstat logem4, stat(mean) by (q)

count
count if baseco == 1
count if q == 1 & baseco == 1
count if q == 2 & baseco == 1
count if q == 3 & baseco == 1
count if q == 4 & baseco == 1

//********** Part 2

scatter logpgp95 logem4, title("Reduced-Form Relationship Between Income and Settler Mortality") subtitle("Figure 1") ytitle("Log GDP per capita, PPP, 1995") xtitle("Log of Settler Mortality") mlabel(shortnam) ||  lfit logpgp95 logem4
graph save "`output'\Q2P2.gph", replace
graph export "`output'\Q2P2_graph.pdf", replace

//********** Part 3

use "`input'\colonialorigins2.dta", clear
br
describe

reg logpgp95 avexpr
reg logpgp95 avexpr if baseco == 1
reg loghjypl avexpr
reg loghjypl avexpr if baseco == 1

//********** Part 4

use "`input'\colonialorigins4.dta", clear
br
describe

ivreg logpgp95 (avexpr = logem4) if baseco == 1 , first
ivreg logpgp95 lat_abst (avexpr = logem4) if baseco == 1, first
ivreg logpgp95 (avexpr = logem4) if (baseco ==1 & rich4 == 0), first
ivreg logpgp95 lat_abst (avexpr = logem4) if (baseco ==1 & rich4 == 0), first
ivreg logpgp95 (avexpr = logem4) if (baseco ==1 & africa == 0), first
ivreg logpgp95 lat_abst (avexpr = logem4) if (baseco ==1 & africa == 0), first

gen other = 0
label variable other "AUS,NZL,MLT"
replace other = 1 if (shortnam == "AUS" | shortnam == "NZL" | shortnam == "MLT")

ivreg logpgp95 asia africa (avexpr = logem4) if baseco ==1, first
ivreg logpgp95 asia africa other (avexpr = logem4) if baseco ==1, first
ivreg logpgp95 lat_abst asia africa other (avexpr = logem4) if baseco ==1, first
ivreg loghjypl (avexpr = logem4) if baseco ==1, first

save "`edit'\Assignment_2.dta" , replace
cd "`output'"
cap log close
translate Assignment_3.log Assignment_3.pdf, replace

//******* Finish.
