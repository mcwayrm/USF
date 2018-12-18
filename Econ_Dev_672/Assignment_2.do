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
