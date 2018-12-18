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
local input	"C:\Users\Ryry\Dropbox\Econ-672-Econ-Dev\Assignment_3\raw"
local output "C:\Users\Ryry\Dropbox\Econ-672-Econ-Dev\Assignment_3\text"
local edit "C:\Users\Ryry\Dropbox\Econ-672-Econ-Dev\Assignment_3\edit"
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
/************ 
	 Rank ranks the colonized countries by the their mortality 
	 rate. The higher the rank, the lower the mortality rate. E.g.
	 britian is ranked #1.
************/
egen rank = rank(extmort4), track
label var rank "Ranking of Mortality Rates"
/*********** 
	 Count gives us the total # of countries who have mortality rates.
***********/
egen count = count(extmort4)
label var count "Total countries in Mort. Ranking"
//********** This ptile creates a percentile ranking for mortality.
gen ptile = rank/count 
label var ptile "Percentile Ranking for Mort."
//************ Create a genric variable q to represent quartiles.
gen q = .
label var q "Quartile for Percentile Mort Ranking"
/************ 
	 We are placing the quartiles so show the percentile ranking 
	 range.
*************/
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

/*****************
	 Point of Table:
	 The point of showing this table was to give descriptive statistics on
	 the variables used. The key variable is average protection against 
	 expropriation risk. The point being that the whole world and base sample
	 are similar enough that the base sample can accurately represent the 
	 whole world.
	 Conclusions from Table:
	 Based the quartiles, it's easy to see that the places with high morality
	 had lower protection against expropriation risk, and have less constraint
	 on their executives for 1 year of independence and 1900. Democracy is much
	 lower for higher mortality states as well.
*****************/

//********** Part 2

scatter logpgp95 logem4, title("Reduced-Form Relationship Between Income and Settler Mortality") subtitle("Figure 1") ytitle("Log GDP per capita, PPP, 1995") xtitle("Log of Settler Mortality") mlabel(shortnam) ||  lfit logpgp95 logem4
graph save "`output'\Q2P2.gph", replace
graph export "`output'\Q2P2_graph.pdf", replace

/***********
	 Graph Explanation:
	 There is a strong negative correlation between settler mortality and
	 current GDP per capita PPP today. This agrees with their hypothesis.
	 The limitations are that it is correlation, not causation. Since this
	 is measuring the IV against of dependent variable, we still have 
	 reasonable doubt that the exclusion restriction holds, as there could
	 be causation between settler mortality and current GDP.
***********/

//********** Part 3

use "`input'\colonialorigins2.dta", clear
br
describe

reg logpgp95 avexpr
reg logpgp95 avexpr if baseco == 1
reg loghjypl avexpr
reg loghjypl avexpr if baseco == 1

/************
	 Summarize Patterns:
	 The whole world statistics and the base sample statistics are very 
	 similar. If the average protection index # goes up by one, then the
	 GDP per capita today goes up by 5% and output per worker by 4.5%
	 Suprises:
	 We are not suprised by these results.
	 Suspicions:
	 But we are suspicious that the whole world and base statistics are so 
	 similar. It seems highly unlikely that the variation would differ so 
	 little. There are probably some very significant omitted variables
	 unaccounted for. Additionally, we find it weird that expropriation is
	 defined by looking soley at foriegn investors and not accounting for
	 domestic investors.
************/

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

/************
	 Comparison of linear regressions:
	 When we the use the IV, latitude becomes insignificant which support
	 the argument that instiutions are the driving force of future GDP per
	 capita. 
	 Bias Coefficents:
	 Settler mortality data is limited to who wrote about it, so there is a 
	 response bias by who tells the story. The dummy variables/ latitude does
	 not control for differing terrians (water/mountians).
	 The IV effecting Dependent Variable/Exclusion Restrictions:
	 Perhaps the diease burden of the past persists today. They are simply
	 looking at mortality, not productive, cognition, underdevelopment of 
	 human capital, or any other aspect that relates to the cycle of poverty.
	 Furthermore, perhaps it was not the introduction of extrative institutions
	 but rather simply the extraction of resources that leads to future 
	 underdevelopment.
	 Albouy Critique:
	 We agree with Albouy a lot more than Acemoglu et al. First, because 
	 we are finding and making similar arguments against their narrative
	 of the way that development occurred as Albouy did. Additionally, 
	 we believe that Albouy makes a persurave enough response that it 
	 puts their data into suspicion. Even though they acknowledge that they
	 use new data, their paper was still flawed none the less.
************/

save "`edit'\Assignment_2.dta" , replace
cd "`output'"
cap log close
translate Assignment_3.log Assignment_3.pdf, replace

//******* Finish.
