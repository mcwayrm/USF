# Stata-Econ-672--Econ-Dev
All the Stata code for the economics of development course

****************************************************************************************
clear
set more off
log close _all
cap log using Assignment_1.log, text replace 

/**************************************
		Assignment 1
		Economics of Development
		Ryan McWay
**************************************/

/*****************
Description:
	This assignment looks at expenditure in Bangladesh. Primary, it focuses on 
	the differences in demographic variables and the inequality amongst these 
	demographics. 
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local input	"C:\Users\Ryry\Dropbox\Econ-672-Econ-Dev\Assignment_1\raw"
local output "C:\Users\Ryry\Dropbox\Econ-672-Econ-Dev\Assignment_1\text"
local edit "C:\Users\Ryry\Dropbox\Econ-672-Econ-Dev\Assignment_1\edit"

display "Analysis run by `USER' for Assignment 1 at `date' and `time'"

/*****************
	Question 1
*****************/

//********* Part 1
 
use "`input'\consume.dta", clear
merge 1:1 hhcode using "`input'\hh.dta"
drop _merge

describe 
gen pcfood = expfd/famsize
label variable pcfood  "expfd/famsize"
gen pcnfood = expnfd/famsize
label variable pcnfood  "Per capita non-food expenditure"
//********* pcexp (Per capita total expenditure) is already defined as a variable in the raw data

gen gender = "Male"
label variable gender "Gender"
replace gender = "Female" if sexhead == 0
gen educ_level = "Head has no education"
label variable educ_level "Education Level"
replace educ_level = "Head has some education" if educhead > 0
gen house_size = "Small Household"
label variable house_size "Household Size"
replace house_size = "Large Household" if famsize > 5
gen land_own = "Small land ownership or landless"
label variable land_own "Land Ownership"
replace land_own = "Large land ownership" if hhlandd/famsize > 0.5

//******** Poor Method
summarize pcfood pcexp
table region, contents (mean pcfood mean pcexp)
table gender, contents (mean pcfood mean pcexp)
table educ_level, contents (mean pcfood mean pcexp)
table house_size, contents (mean pcfood mean pcexp)
table land_own, contents (mean pcfood mean pcexp)

//********* Better Method
ttest pcexp if region == 1 | region == 2, by(region)

//********* Best Method
ssc install orth_out
orth_out pcexp pcfood, by (region) pcompare stars
orth_out pcexp pcfood, by (gender) pcompare stars
orth_out pcexp pcfood, by (educ_level) pcompare stars
orth_out pcexp pcfood, by (house_size) pcompare stars
orth_out pcexp pcfood, by (land_own) pcompare stars

/*************
	In general, it seems that most of the household expenditures are spent on 
	food (80%).
	The region of Chittagon appears to be the wealthist whereas Khulna was the 
	poorest region. Dhaka and Chittagon are very similar but the rest of the 
	country appears to have distinctly different expenditures.
	Women household heads do tend to spend a bit more than their counterparts.
	Those who have an education appear to spend more, which may reflect that 
	they make higher wages.
	A large household seems to not be able to afford to spend as much per person
	on food.
	And there doesn't appear to be any significant difference between large and 
	small land ownerships.
**************/

//********** Part 2

merge 1:m hhcode using "`input'\ind.dta"
drop _merge

gen adult_e = .75
label variable adult_e "Adult Equvilancy"
replace adult_e = 1 if age > 14
bysort hhcode: egen famsize2 = total (adult_e)
label variable famsize2 "adult_e in the same hhcode"

gen pafood = expfd/famsize2
label variable pafood "expfd/famsize2"
gen paexp = hhexp/famsize2
label variable paexp "hhexp/famsize2"

summarize pafood paexp
orth_out paexp pafood, by (region) pcompare stars
orth_out paexp pafood, by (gender) pcompare stars
orth_out paexp pafood, by (educ_level) pcompare stars
orth_out paexp pafood, by (house_size) pcompare stars
orth_out paexp pafood, by (land_own) pcompare stars

/************
	These new results show that when you account for the adult equvilancy, the 
	per capita expediture (food and total) are much higher.
	Now there is a very clear distincition between the expenditures in Dhaka 
	versus the rest of the country. And each region seems to be different from 
	the other as well.
	Men and women spend very differently, but they spend the same amount on 
	food. Makes sense since they both need about the same amount of food 
	regardless the gender.
	And educated families clearly spend more all around, probably because they 
	can command higher wages.
*************/

/****************
	The Adult equivalency scale seems to help measure consumption more accurately
	by effectively adding a weight.
	As children are only consuming 75%, the higher expenditures show that these 
	adults are acutally spending more than would otherwise be acknowledged 
	without the weight.
****************/

//********* Part 3

cumul pcexp, gen (pcexpcdf)
twoway scatter pcexpcdf pcexp if pcexp < 20000, ytitle(“Cumulative Distribution of pcexp”) xtitle(“Per Capita total expenditure”) title(“CDF ofPer Capita Total Expenditure”) subtitle(“Exercise1.3”)
graph save "`output'\graph1.gph", replace
kdensity pcexp if pcexp < 20000, normal
graph save "`output'\graph2.gph", replace
graph combine "`output'\graph1.gph" "`output'\graph2.gph"
graph save "`output'\Q1P3_graphs.gph", replace
graph export "`output'\Q1P3_graphs.pdf", replace

/***********
	Based on these two graphs, I would say that they are normalizing the pcexp 
	into a normal distribution.
	In particular, the first graph shows us that highest density of expenditures
	are between 5000-10,000.
	Whereas the second graph shows us the actual distribution throughout, and 
	the mean/median is near 5000ish.
	They are different in that the first is showing the data as accumulates 
	(in a way it percentiles perhaps), while the second is providing a frequency
	distribution.
************/
 
//********** Part 4

gen weighti = weight*famsize
table region [pweight=weighti], c(mean famsize)
table region, c(mean famsize)
table region [aweight=weighti], c(mean expfd)
table region, c(mean expfd)
table region [aweight=weighti], c(mean pcexp)
table region, c(mean pcexp)

/********
	The weighted table seems to distribute famsize, expfd, and pcexp much more 
	evenly.
	The different regions are much closer together/similar than they are 
	distinctly different when unweighted.
	The weights help to measure with the individual as the unit rather than the 
	household.
*********/

//********** Part 5

svyset [pweight=weighti], strata(region) psu(thana)
svy: mean famsize
svy: mean pcfood 
svy: mean expfd
svy: mean pcexp
mean famsize pcfood expfd pcexp

/*****************
	When stratified, all the averages are higher than the original except for 
	pcexp.
	Also, all of the standard errors are much higher for the stratified than it 
	is for the regular.
	So, stratified statistics seem to have a higher variation; possibly because 
	the segmented data lowers the total observations for each strata when making
	a normal distribution.
	Perhaps by stratifing and weighting on the famsize we are making the 
	statistics more specific for the household (the unit of measure).
*****************/


/****************
	Question 2
*****************/

//********* Part 1

sort pcexp
gen cumy = sum(pcexp*weight)
gen cump = sum(weight)
quietly replace cumy = cumy/cumy[_N]
quietly replace cump = cump/cump[_N]
gen equal = cump
label variable equal "Line of Perfect Equality"
label variable cump "Cumulative proportion of population"
label variable cumy "Lorenz curve"

scatter cumy equal cump, c(l l) m(i i) title("Lorenz Curve for Bangladesh") clwidth(medthick thin) ytitle("Cumulative proportion of income per capita")
graph save "`output'\graph3.gph", replace
scatter cumy equal cump if region==1, c(l l) m(i i) title("Lorenz Curve for Dhaka") clwidth(medthick thin) ytitle("Cumulative proportion of income per capita")
graph save "`output'\graph4.gph", replace
tab region
scatter cumy equal cump if region==2 | region==3 | region==4, c(l l) m(i i) title("Lorenz Curve for Rural Regions") clwidth(medthick thin) ytitle("Cumulative proportion of income per capita")
graph save "`output'\graph5.gph", replace
twoway (scatter cumy equal cump if region==1, c(l l) m(i i) title("Lorenz Curve for Dhaka") clwidth(medthick thin) ytitle("Cumulative proportion of income per capita"))(scatter cumy equal cump if region==2 | region==3 | region==4, c(l l) m(i i) title("Lorenz Curve for Rural Regions") clwidth(medthick thin) ytitle("Cumulative proportion of income per capita"))
graph save "`output'\graph6.gph", replace

graph combine "`output'\graph3.gph" "`output'\graph4.gph" "`output'\graph5.gph" "`output'\graph6.gph"
graph save "`output'\Q2P1_graphs.gph", replace
graph export "`output'\Q2P1_graphs.pdf", replace

/**********
	When I overlap the two lines, they appear to be identical. Perhaps I have 
	messed up.
	But this would indicate that there is no difference between Dhaka and the 
	rural areas of Bangladesh in inequality when weighting for pcexp.
	This implies that there are the same degrees of inequality throughout 
	Bangladesh in respect to their region.
**********/

//******** Part 2

ssc install ineqdeco
help ineqdeco

/***********
	An .ado file is an automatically loaded dofile. 
	Usually it contains commands that are not already included in Stata.
	Its main purpose it to define a command, whereas a .do file is used to run 
	a series of commands/operations
************/

//********* Part 3

ineqdeco pcexp, by(region)

/************
	The wealthist 90% are about 3 times better off than the bottom 10%
	With a Gini of .25, Bangladesh has a relatively low gini coeffiecent. And is
	somewhat equitable.
	Under the Atkinson index at 1, there would be a 10% increase in the 
	redistribution of wealth
	Dhaka has the greatest share of the national income. 
************/

//********** Part 4

xtile group = pcexp, nq(10)
gen poor = pcexp if group == 1
gen rich = pcexp if group == 10
egen poor_avg = mean(poor)
egen rich_avg = mean(rich)
gen ddr = rich_avg/poor_avg

gen poor_dhaka = pcexp if group == 1 & region == 1
gen rich_dhaka = pcexp if group == 10 & region == 1
egen poor_avg_dhaka = mean(poor_dhaka)
egen rich_avg_dhaka = mean(rich_dhaka)
gen ddr_dhaka = rich_avg_dhaka/poor_avg_dhaka

gen poor_rural = pcexp if group == 1 & region != 1
gen rich_rural = pcexp if group == 10 & region != 1
egen poor_avg_rural = mean(poor_rural)
egen rich_avg_rural = mean(rich_rural)
gen ddr_rural = rich_avg_rural/poor_avg_rural

sum ddr
sum ddr_dhaka
sum ddr_rural

/************
	The xtile command appears to divide the sample into deciles. And by doing so
	allows us to compare those deciles across the distribution of the 
	observations. 
	And by using xtile, we can compare different deciles more easily.
	It seems that within dhaka is the largest disparity, with the rishest 5.7 
	times more wealthy than the poorest.
	The country as a whole (4.9) still has major inequality, and so does the 
	rural areas (4.5)
************/

//********* Part 5

ineqdeco pcexp, by(region)

/***********
	As a measure of enthropy, the Theil index shows that the entropic distance 
	from the ideal egalitarian state.
	It shows the differences within and between groups.
	Inequality at A(1) within groups is 0.1 while between groups is 0.002.
	So there is more inequality within regions than there is between regions?
***********/


save "`edit'\assignment_1.dta" , replace
cd "`output'"
cap log close
translate Assignment_1.log Assignment_1.pdf, replace

//******* Finish.


*************************************************************************************

clear
set more off
log close _all
cap log using Assignment_2.log, text replace 

/**************************************
		Assignment 2
		Economics of Development
		Ryan McWay, Lauren Lamson, Anna Subirana, Chenyao Yuan, Katie Roett
**************************************/

/*****************
Description:
	 This assignment is a replication of the MRW augmented solow model 
	 paper: A Contribution to the Emprics of Economics Growth, by Mankiw,
	 et al. 
*****************/

global USER "Team CRAKL"
local date `c(current_date)'
local time `c(current_time)'
local input	"C:\Users\Ryry\Dropbox\Econ-672-Econ-Dev\Assignment_2\raw"
local output "C:\Users\Ryry\Dropbox\Econ-672-Econ-Dev\Assignment_2\text"
local edit "C:\Users\Ryry\Dropbox\Econ-672-Econ-Dev\Assignment_2\edit"
**************************************************************************
display "Analysis run by $USER for Assignment 2 at `date' and `time'"

/*****************
	 Question 1: Growth Theory
*****************/

//********* Part 1

/**********
	 k= (sy)/(d+n)
	 Where sy=i
	 k = i/(d+n)
	 Where A_x = A_y
***********/
use "`input'\MRW_growth.dta", clear

gen s_x = .2
gen n_x = 0
gen s_y = .05
gen n_y = .04

gen d = .05
gen a = (1/3)

gen k_x = s_x/(n_x+d)
gen y_x = k_x^a
gen k_y = s_y/(n_y+d)
gen y_y = k_y^a
gen ratio = y_x/y_y
summarize ratio
br ratio
/*****************
	 The ratio shows that y_x/y_y is nearly 1.930979. We interpert this 
	 ratio as meaning that Country X's steady state levels of income per
	 capita is 1.93 time more than Country Y's steady state levels of 
	 income per capita.
*****************/

//********** Part 2

/****************
	 n1 > n2
	 n1 = k < steady state
	 n2 = k => steady state
	 We graphed this part by hand and is attached.
****************/

/*****************
	 Question 2: Growth Empirics
*****************/

//********** Part 1

use "`input'\MRW_growth.dta", clear
describe

//********** Part 2

gen sk1980 = csh_i_1980
label variable sk1980 "Savings rate as proxy for I/Y year 1980"
gen sk2000 = csh_i_2000
label variable sk2000 "Savings rate as proxy for I/Y year 2000"

gen pop1980 = v10_age1980 + v11_age1980 + v12_age1980 + v13_age1980 + v14_age1980 + v15_age1980 + v16_age1980 + v17_age1980 + v18_age1980 + v19_age1980
label variable pop1980 "population at year 1980"
gen pop2000 = v10_age2000 + v11_age2000 + v12_age2000 + v13_age2000 + v14_age2000 + v15_age2000 + v16_age2000 + v17_age2000 + v18_age2000 + v19_age2000
label variable pop2000 "population at year 2000"

gen n = (pop2000-pop1980)/pop1980
label variable n "population"
tabstat n, stat(mean)
br countrycode pop1980 pop2000 n
/******************
	 The estimated the mean of n that on average all of these countries 
	 in the sample, the populations have grown 54.69%. At this rate, in 
	 20 years the populations on average will have doubled from their
	 1980 population.
******************/

//********** Part 3

//********* g + d = 0.05
gen gdn = (0.05 + n)
label variable gdn "g+d+n"
/***********
	 The purpose of g + d being 0.05 is to minimize the variation of 0.05
	 between countries as growth of technology and depreciation rate should
	 mostly cancel each other out.
	 The reason is that it is population growth, not 
	 depreciation nor technological growth, is driving differences 
	 between countries' growth rates. It is 0.05 because that is the 
	 empirical evidence for what is found in the dataset by Romler.
***********/

//********** Part 4

gen working_age = v10_age2000 + v11_age2000 + v12_age2000 + v13_age2000 + v14_age2000 + v15_age2000 + v16_age2000 + v17_age2000 + v18_age2000 + v19_age2000
label variable working_age "Working Age Population: 15-64"
//********** This working age is that which is defined by the OECD.

gen primary_age = v8_age2000 + v9_age2000*(3/5)
label variable primary_age "Primary school children: 5-12"
/********** 
	 The primary school age is defined by the International Standard
	 Classification of Education is 5-12. The closest variable set was
	 5-9. To approximate 10-12 we took three fifths of the 10-14 range.
**********/

gen secondary_age = v9_age2000*(2/5) + v10_age2000
label variable secondary_age "Secondary school children: 13-19"
/********** 
	 The secondary school age is defined by the International Standard
	 Classification of Education is 13-19. The closest variable set
	 was 10-19. To approximate 13-14 we took two fifths of the 10-14 range.
**********/

gen work_primary = primary_age/working_age
gen SCHOOL_Prim = net_primary_edu_2000*work_primary
label variable SCHOOL_Prim "Rate of Human-capital accumulation (Sh)- Primary School"

gen work_secondary = secondary_age/working_age
gen SCHOOL_Sec = net_secondary_edu_2000*work_secondary
label variable SCHOOL_Sec "Rate of Human-capital accumulation (Sh)- Secondary School"
/**********
	 These two variables account for the variable SCHOOL in the MRW paper.
	 They are useful as a proxy for the rate of human-capital accumulation
	 (Sh). This is useful in the regression to show the correlation between
	 human capital and physical capital/population growth.
**********/

//********** Part 5

gen GDP = ln(rgdpna_2000/working_age)
reg GDP sk2000 gdn
/***********
	 Explanation for the tests:
	 We are running a basic OLS regression for the SOLOW model. We are
	 trying to see the proportional change of in GDP with respect to the
	 proportional change of Investment and overall growth rate.
	 There is an R-squared test which measures how well the model predicts
	 the actual variation of observations.
	 There is also a T-test that measures whether the a given variable is
	 statistically significant; meaning that it can be realiably trusted as
	 a true representation of the population as a whole.
	 Does the Model Hold:
	 All of the variables are statistically significant at 5%, so the model
	 holds. But there is only an R-Squared of 26%, showing that very little
	 of the variation is explained.
	 Differences in Results from MRW Paper:
	 sk2000, our investment rate variable, is much larger (almost twice
	 as big) as the MRW paper.
	 We believe that this is because the coefficent is accounting for more
	 variation than it should, as my constant is much smaller than the one
	 in the MRW paper. Gdn matches the result for Table 1 in the MRW paper.
***********/

//********** Part 6

reg GDP sk2000 gdn SCHOOL_Sec
/***********
	 Explanation for the Tests:
	 We are running a basic OLS regression for the Augmented SOLOW model. 
	 We are trying to see the proportional change of in GDP with respect to
	 the proportional change of Investment and overall growth rate.
	 There is an R-squared test which measures how well the model predicts
	 the actual variation of observations.
	 There is also a T-test that measures whether the a given variable is
	 statistically significant; meaning that it can be realiably trusted as
	 a true representation of the population as a whole.
	 Does the Model Hold:
	 All my variables are statistically significant at 5%, expect for sk2000
	 which is 0.061. So very close. Because sk2000 is so close, I believe
	 that this model holds. The R-squared accounted for more variation at
	 49%, which makes us believe that it does a better job of accounting 
	 for variation.
	 Differences in Results from MRW Paper:
	 Again, sk2000 is about 4 times bigger than the MRW paper. And our school
	 variable, SCHOOL_Sec, is much smaller than the human capital variable
	 in the MRW paper. This implies that the saving/investment rate is 
	 playing a bigger role than human capital accumlation in comparison to
	 the MRW paper. 
***********/

//********** Part 7

/***********
	 Deriving the Model:
	 The MRW model adds to the SOlOW model by accounting for human capital.
	 From the emprical estimations on Table 2, the rate of investment and
	 the rate of human capital accumlation play equally improtant roles for
	 explaing GDP as there coefficents are almost identical. This agrees
	 with their assertion that alpha and beta should be about the same size
	 (1/3). This intutively makes sense, as human capital, labor, and 
	 physical capital should all contribute equally in proportion to GDP.
***********/

//********** Part 8

reg GDP sk2000 gdn SCHOOL_Prim
reg GDP sk2000 gdn SCHOOL_Sec
reg GDP sk2000 gdn SCHOOL_Prim SCHOOL_Sec
/***********
	 Differences between SCHOOL_Prim and SCHOOL_Sec:
	 Our results show that SCHOOL_Prim alone has the smallest r-squared
	 and makes gdn insignificant. So SCHOOL_Prim alone doesn't do a good
	 job of explaining human capital accumulation. When both variables are 
	 in the model, it explains much more (higher R-squared), but still makes
	 gdn insignificant. These two variables are have simliar magnitude
	 and opposite in direction. This makes us beleive, that when an employable
	 child is primary school, there is a negative effect on GDP. But when they
	 acquire secondary education, they begin to GDP. We believe that SCHOOL_Sec
	 is the better variable of the two, because it is a better fit for the
	 model's regression. Also, we don't understand why increasing primary 
	 education would hurt GDP, eg. advocates for child labor.
	 Three Assumptions for Human Capital:
	 1. Assuming that it depreciates at same rate as physical capital.
	 2. Assuming that that the same production function applies for
	 human capital as it does for physical capital and consumption.
	 3. Assuming that there is decreasing returns to human capital.
***********/

save "`edit'\Assignment_2.dta" , replace
cd "`output'"
cap log close
translate Assignment_2.log Assignment_2.pdf, replace

//******* Finish.

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

*******************************************************************************************


