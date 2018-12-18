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
