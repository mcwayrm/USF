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

//********** Part 3

//********* g + d = 0.05
gen gdn = (0.05 + n)
label variable gdn "g+d+n"

//********** Part 4

gen working_age = v10_age2000 + v11_age2000 + v12_age2000 + v13_age2000 + v14_age2000 + v15_age2000 + v16_age2000 + v17_age2000 + v18_age2000 + v19_age2000
label variable working_age "Working Age Population: 15-64"

gen primary_age = v8_age2000 + v9_age2000*(3/5)
label variable primary_age "Primary school children: 5-12"

gen secondary_age = v9_age2000*(2/5) + v10_age2000
label variable secondary_age "Secondary school children: 13-19"

gen work_primary = primary_age/working_age
gen SCHOOL_Prim = net_primary_edu_2000*work_primary
label variable SCHOOL_Prim "Rate of Human-capital accumulation (Sh)- Primary School"

gen work_secondary = secondary_age/working_age
gen SCHOOL_Sec = net_secondary_edu_2000*work_secondary
label variable SCHOOL_Sec "Rate of Human-capital accumulation (Sh)- Secondary School"

//********** Part 5

gen GDP = ln(rgdpna_2000/working_age)
reg GDP sk2000 gdn

//********** Part 6

reg GDP sk2000 gdn SCHOOL_Sec

//********** Part 7

//********** Part 8

reg GDP sk2000 gdn SCHOOL_Prim
reg GDP sk2000 gdn SCHOOL_Sec
reg GDP sk2000 gdn SCHOOL_Prim SCHOOL_Sec

save "`edit'\Assignment_2.dta" , replace
cd "`output'"
cap log close
translate Assignment_2.log Assignment_2.pdf, replace

//******* Finish.
