*******************************************************************************************

clear
set more off
log close _all
cap log using Assignment_4.log, text replace 

/**************************************
		Assignment 4
		Economics of Development
		Ryan McWay, Lauren Lamson, Anna Subirana, Zhenyao Yuan, Katie Roett
**************************************/

/*****************
Description:
	 This assignment is a replication of The Potato's Contribution to 
	 Population and Urbanization: Evidence From a Historical Experiment
	 by Nathan Nunn and Nancy Qian
*****************/

global USER "Team KRAZL"
local date `c(current_date)'
local time `c(current_time)'
local input	"raw"
local output "text"
local edit "edit"
**************************************************************************
display "Analysis run by $USER for Assignment 4 at `date' and `time'"

/*****************
	 Question 2: Baseline Results
*****************/

//************ Part A

//************ Part B

//************ Part C

//************ Part D
use "`input'\country_level_panel_for_web.dta", clear
describe
br

areg ln_population ln_wpot_post i.year, absorb(country) cluster(country)

//************* Part E

//************* Part F

//************* Part G

/*****************
	 Question 3: Control
*****************/

//************** Part A

//************** Part B

//************** Part C

//************** Part D

foreach x in 1000 1100 1200 1300 1400 1500 1600 1700 1750 1800 1850 1900{
	gen ln_wpot_`x'=ln_wpot*ydum`x'
	gen ln_all_`x'=ln_all*ydum`x'
	gen ln_nworld_`x'=ln_nworld*ydum`x'
	gen ln_oworld_`x'=ln_oworld*ydum`x'
	gen ln_tropical_`x'=ln_tropical*ydum`x'
	gen ln_rugged_`x'=ln_rugged*ydum`x'
	gen ln_elevation_`x'=ln_elevation*ydum`x'
	gen ln_disteq_`x'=ln_disteq*ydum`x'
	gen ln_dist_coast_`x'=ln_dist_coast*ydum`x'
	gen ln_export_`x'=ln_export*ydum`x'
	gen malaria_`x'=malaria*ydum`x'
	gen ln_spot_`x'=ln_spot*ydum`x'
	gen ln_silagemaize_`x'=ln_silagemaize*ydum`x'
	gen ln_maize_`x'=ln_maize*ydum`x'
	gen ln_cassava_`x'=ln_cassava*ydum`x'
	}

//************* Locals for the control variables
local ln_potato_flexible "ln_wpot_1100 ln_wpot_1200 ln_wpot_1300 ln_wpot_1400 ln_wpot_1500 ln_wpot_1600 ln_wpot_1700 ln_wpot_1750 ln_wpot_1800 ln_wpot_1850 ln_wpot_1900"
local ydum_flexible "ydum1100 ydum1200 ydum1300 ydum1400 ydum1500 ydum1600 ydum1700 ydum1750 ydum1800 ydum1850 ydum1900"
local ln_all_flexible "ln_all_1100 ln_all_1200 ln_all_1300 ln_all_1400 ln_all_1500 ln_all_1600 ln_all_1700 ln_all_1750 ln_all_1800 ln_all_1850 ln_all_1900"
local ln_nworld_flexible "ln_nworld_1100 ln_nworld_1200 ln_nworld_1300 ln_nworld_1400 ln_nworld_1500 ln_nworld_1600 ln_nworld_1700 ln_nworld_1750 ln_nworld_1800 ln_nworld_1850 ln_nworld_1900"
local ln_oworld_flexible "ln_oworld_1100 ln_oworld_1200 ln_oworld_1300 ln_oworld_1400 ln_oworld_1500 ln_oworld_1600 ln_oworld_1700 ln_oworld_1750 ln_oworld_1800 ln_oworld_1850 ln_oworld_1900"
local ln_tropical_flexible "ln_tropical_1100 ln_tropical_1200 ln_tropical_1300 ln_tropical_1400 ln_tropical_1500 ln_tropical_1600 ln_tropical_1700 ln_tropical_1750 ln_tropical_1800 ln_tropical_1850 ln_tropical_1900"
local ln_rugged_flexible "ln_rugged_1100 ln_rugged_1200 ln_rugged_1300 ln_rugged_1400 ln_rugged_1500 ln_rugged_1600 ln_rugged_1700 ln_rugged_1750 ln_rugged_1800 ln_rugged_1850 ln_rugged_1900"
local ln_elevation_flexible "ln_elevation_1100 ln_elevation_1200 ln_elevation_1300 ln_elevation_1400 ln_elevation_1500 ln_elevation_1600 ln_elevation_1700 ln_elevation_1750 ln_elevation_1800 ln_elevation_1850 ln_elevation_1900"
local ln_disteq_flexible "ln_disteq_1100 ln_disteq_1200 ln_disteq_1300 ln_disteq_1400 ln_disteq_1500 ln_disteq_1600 ln_disteq_1700 ln_disteq_1750 ln_disteq_1800 ln_disteq_1850 ln_disteq_1900"
local ln_dist_coast_flexible "ln_dist_coast_1100 ln_dist_coast_1200 ln_dist_coast_1300 ln_dist_coast_1400 ln_dist_coast_1500 ln_dist_coast_1600 ln_dist_coast_1700 ln_dist_coast_1750 ln_dist_coast_1800 ln_dist_coast_1850 ln_dist_coast_1900"
local malaria_flexible "malaria_1100 malaria_1200 malaria_1300 malaria_1400 malaria_1500 malaria_1600 malaria_1700 malaria_1750 malaria_1800 malaria_1850 malaria_1900"
//************** 1000-1500 have no information and therefore is perfectly colinear.
local ln_export_flexible "ln_export_1600 ln_export_1700 ln_export_1750 ln_export_1800 ln_export_1850 ln_export_1900"

local ln_spot_flexible "ln_spot_1100 ln_spot_1200 ln_spot_1300 ln_spot_1400 ln_spot_1500 ln_spot_1600 ln_spot_1700 ln_spot_1750 ln_spot_1800 ln_spot_1850 ln_spot_1900"
local ln_silagemaize_flexible "ln_silagemaize_1100 ln_silagemaize_1200 ln_silagemaize_1300 ln_silagemaize_1400 ln_silagemaize_1500 ln_silagemaize_1600 ln_silagemaize_1700 ln_silagemaize_1750 ln_silagemaize_1800 ln_silagemaize_1850 ln_silagemaize_1900"
local ln_maize_flexible "ln_maize_1100 ln_maize_1200 ln_maize_1300 ln_maize_1400 ln_maize_1500 ln_maize_1600 ln_maize_1700 ln_maize_1750 ln_maize_1800 ln_maize_1850 ln_maize_1900"
local ln_cassava_flexible "ln_cassava_1100 ln_cassava_1200 ln_cassava_1300 ln_cassava_1400 ln_cassava_1500 ln_cassava_1600 ln_cassava_1700 ln_cassava_1750 ln_cassava_1800 ln_cassava_1850 ln_cassava_1900"

areg ln_population `ln_potato_flexible' `ydum_flexible' `ln_all_flexible' `ln_nworld_flexible' `ln_oworld_flexible' `ln_tropical_flexible' `ln_rugged_flexible' `ln_elevation_flexible' `ln_disteq_flexible' `ln_dist_coast_flexible' `malaria_flexible' `ln_export_flexible' `ln_spot_flexible' `ln_silagemaize_flexible' `ln_maize_flexible' `ln_cassava_flexible', absorb(country) cluster(country)

gen suit = 0
replace suit = 1 if ln_wpot > 2.5
gen post2 = 0
replace post2 = 1 if year >= 1700
gen suitpost = suit*post2

sum ln_population if (suit == 0 & post2 == 0)
sum ln_population if (suit == 1 & post2 == 0)
sum ln_population if (suit == 0 & post2 == 1)
sum ln_population if (suit == 1 & post2 == 1)
reg ln_population suit post2 suitpost

/*****************
	 Question 4: Robustness Checks
*****************/

//**************** Part A

//***************** Part B

//**************** Part C
foreach x in 1000 1100 1200 1300 1400 1500 1600 1700 1750 1800 1850 1900{
	gen cont_africa_`x'= cont_africa*ydum`x'
	gen cont_asia_`x'= cont_asia*ydum`x'
	gen cont_europe_`x'= cont_europe*ydum`x'
	gen cont_oceania_`x'= cont_oceania*ydum`x'
	}
//************* Locals for the control variables
local cont_africa_flexible "cont_africa_1100 cont_africa_1200 cont_africa_1300 cont_africa_1400 cont_africa_1500 cont_africa_1600 cont_africa_1700 cont_africa_1750 cont_africa_1800 cont_africa_1850 cont_africa_1900"
local cont_asia_flexible "cont_asia_1100 cont_asia_1200 cont_asia_1300 cont_asia_1400 cont_asia_1500 cont_asia_1600 cont_asia_1700 cont_asia_1750 cont_asia_1800 cont_asia_1850 cont_asia_1900"
local cont_europe_flexible "cont_europe_1100 cont_europe_1200 cont_europe_1300 cont_europe_1400 cont_europe_1500 cont_europe_1600 cont_europe_1700 cont_europe_1750 cont_europe_1800 cont_europe_1850 cont_europe_1900"
local cont_oceania_flexible "cont_oceania_1100 cont_oceania_1200 cont_oceania_1300 cont_oceania_1400 cont_oceania_1500 cont_oceania_1600 cont_oceania_1700 cont_oceania_1750 cont_oceania_1800 cont_oceania_1850 cont_oceania_1900"

areg ln_population ln_wpot_post `ln_rugged_flexible' `ln_tropical_flexible' `ln_elevation_flexible' `ln_oworld_flexible' `cont_africa_flexible' `cont_asia_flexible' `cont_europe_flexible' `cont_oceania_flexible', absorb(country) cluster(country)

//**************** Part D

/*****************
	 Question 5: Empirical Demography
*****************/
//*************** This is not a question, these are definitions for Q6.

/*****************
	 Question 6: Survivorship and Age-specific Fertility Rates
*****************/
//*************** Part A

//**************** Part B

//**************** Part C


save "`edit'\Assignment_4.dta" , replace
cd "`output'"
cap log close
translate Assignment_4.log Assignment_4.pdf, replace

//******* Finish.
