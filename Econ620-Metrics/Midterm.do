clear
set more off
clear matrix
clear mata
log close _all
cap log using mcway_midterm.log, text replace 

/*****************
Description:
	 Economics 620: Graduate Econometrics Midterm Exam Empirical Work #6
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home "local"
local input	"home\input"
local output "home\output"
local edit "home\edit"
**************************************************************************
display "Analysis run by $USER for Midterm Exam at `date' and `time'"
cd "`home'"

//****** Question #6
// a)
// Import data, clean and merge
global gdp "`input'\GDP.xlsx"
global pop "`input'\population.xlsx"
import excel $gdp, firstrow clear
de
rename GrossDomesticProductGDP GDP
destring GDP, force replace
sort GDP
de
rename CountryArea country
rename Year year
drop Unit
save `edit'\\gdp.dta, replace
 
import excel $pop, firstrow clear
de
rename Population pop
destring pop, force replace
de
rename CountryArea country
rename Year year
drop Unit
save `edit'\\pop.dta, replace

merge m:m country year using `edit'\\gdp.dta
drop _merge
de
duplicates report
save `edit'\\master.dta, replace

// Check for missing variables
count if pop == .
count if GDP == .
di 922 + 1671
count if pop == . & GDP == .

// GDP Per Capita
gen GDPpc =  GDP/pop
gen lower = 1 if (GDPpc <= 3000 & GDPpc !=.)
gen middle = 1 if (GDPpc > 3000 & GDPpc <= 10000 & GDPpc !=.)
gen upper = 1 if (GDPpc > 10000 & GDPpc !=.)
sum GDP pop GDPpc
bysort lower middle upper: sum GDP pop GDPpc 
// b)
// Graph GDPpc for a lower and upper income country
sum if country == "Bangladesh" 
sum if country == "Iceland"
sort year
twoway (connected GDPpc year) if country == "Bangladesh", title("GDP per Capita for Bangladesh") ytitle("GDPpc in USD") xtitle("Year")
	graph save `output'\\Bangladesh.gph, replace	
twoway (connected GDPpc year) if country == "Iceland", title("GDP per Capita for Iceland") ytitle("GDPpc in USD") xtitle("Year")
	graph save `output'\\Iceland.gph, replace
graph combine "`output'\Bangladesh.gph" "`output'\Iceland.gph", title("GDP Per Capita for 1970-Present") 
	graph export `output'\\PartB.png, replace

// c)
// Regress for lnGDP lnpop
gen lnGDP = ln(GDP)
gen lnpop = ln(pop)
order country year pop lnpop GDP lnGDP GDPpc lower middle upper
reg lnGDP lnpop if year == 2000
	outreg2 using `output'\\Results.xls, excel ctitle("lnGDP Year 2000") replace

// d)
// Same regression with year control variable
reg lnGDP lnpop year
	outreg2 using `output'\\Results.xls, append ctitle("lnGDP Overall")

// e)
// same regression but for subset lower and upper income countries
reg lnGDP lnpop year if lower == 1
	outreg2 using `output'\\Results.xls, append ctitle("lnGDP Lower")
reg lnGDP lnpop year if upper == 1
	outreg2 using `output'\\Results.xls, append ctitle("lnGDP Upper")

// f)
// Partial Out
reg lnGDP year
predict resid_gdp, residuals
reg lnGDP resid_gdp
	outreg2 using `output'\\Results.xls, append ctitle("lnGDP")	

reg lnpop year
predict resid_pop, residuals
reg lnpop resid_pop
	outreg2 using `output'\\Results.xls, append ctitle("lnpop")

reg resid_gdp resid_pop
	outreg2 using `output'\\Results.xls, append ctitle("Partial Out resid_gdp")

// g)
// Make panel data, create lag variable
egen ccode = group(country)
xtset ccode year, yearly
gen lag = GDPpc[_n-1]
gen lag_2 = l1.GDPpc
// I don't understand why these two variables drop different amounts...
// Regress GDPpc Growth for lower and upper income countries
gen GDPpc_growth = (GDPpc - lag_2)/lag_2
reg GDPpc_growth pop year
	outreg2 using `output'\\Results.xls, append ctitle("GDPpc Growth")
reg GDPpc_growth pop year if lower == 1
	outreg2 using `output'\\Results.xls, append ctitle("GDPpc Growth Lower")
reg GDPpc_growth pop year if upper == 1
	outreg2 using `output'\\Results.xls, append ctitle("GDPpc Growth Upper")

// h)
// Regress lnGDPpc lnpop for 1980 and 2010
gen lnGDPpc = ln(GDPpc)
reg lnGDPpc lnpop
	outreg2 using `output'\\Results.xls, append ctitle("lnGDPpc")
reg lnGDPpc lnpop if year == 1980
	outreg2 using `output'\\Results.xls, append ctitle("lnGDPpc 1980")
reg lnGDPpc lnpop if year == 2010
	outreg2 using `output'\\Results.xls, append ctitle("lnGDPpc 2010")
// Graph lnGDPpc lnpop for 1980 and 2010
twoway (scatter lnGDPpc lnpop) (lfit lnGDPpc lnpop) if year == 1980, title("Year 1980") ytitle("% Change GDP Per Capita") xtitle("% Change in Population")
	graph save `output'\\1980.gph, replace	
twoway (scatter lnGDPpc lnpop) (lfit lnGDPpc lnpop) if year == 2010, title("Year 2010") ytitle("% Change GDP Per Capita") xtitle("% Change in Population")
	graph save `output'\\2010.gph, replace
graph combine "`output'\1980.gph" "`output'\2010.gph", title("% Change in GDPpc and % Change in Population")
	graph export `output'\\PartH.png, replace


cd "`output'"
cap log close
translate mcway_midterm.log mcway_midterm.pdf, replace
