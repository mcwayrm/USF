clear
set more off
log close _all

/*****************
Description:
	 Merging raw data for love experiment.
	 Creates the master dataset.
*****************/

global USER "The Love Experts"
local date `c(current_date)'
local time `c(current_time)'
local home "<project folder>"
//***** All paths should be relative so that all you need to change is `home' in order to run the dofile.
cd "`home'"
local input "`home'\input"
local edit "`home'\edit"
local output "`home'\output"
**************************************************************************
display "Analysis run by $USER merging love experiment raw data into master at `date' and `time'"

// Import
import excel `input'\Session1_Yaniv_Apr-2-2019.xlsx, first clear
save `edit'\Session1_Yaniv_Apr-2-2019.dta, replace
import excel `input'\Session2_Muzzi_Apr-2-2019.xlsx, first clear
save `edit'\Session2_Muzzi_Apr-2-2019.dta, replace
import excel `input'\Session3-Ana-9-4-2019.xlsx, first clear
save `edit'\Session3-Ana-9-4-2019.dta, replace
import excel `input'\Session4_MCC_Apr-14-2019.xlsx, first clear
save `edit'\Session4_MCC_Apr-14-2019.dta, replace
import excel `input'\Session5_Jesse_4-15-2019.xlsx, first clear
save `edit'\Session5_Jesse_4-15-2019.dta, replace
import excel `input'\Session6_Camille_Apr-20-2019.xlsx, first clear
save `edit'\Session6_Camille_Apr-20-2019.dta, replace

// Append
append using `edit'\Session1_Yaniv_Apr-2-2019.dta
append using `edit'\Session2_Muzzi_Apr-2-2019.dta
append using `edit'\Session3-Ana-9-4-2019.dta
append using `edit'\Session4_MCC_Apr-14-2019.dta
append using `edit'\Session5_Jesse_4-15-2019.dta

// Unique Subject ID
replace Subject_ID = _n
sort Subject_ID
duplicates report Subject_ID

// Clean
label var Dict_Sent "Amount Sent in Dictator Game"
label var Dict_Got "Amount Recieved in Dictator Game"
label var Dict_Keep "Amount Keep in Dictator Game"
label var Age "Age"

gen lgbtq = 0
replace lgbtq = 1 if (Sex == 2 |Sex == 3 | Sex == 4 | Sex == 5 | Gender == 3 | Gender == 4 | Gender == 5)
label var lgbtq "LGBTQ"
gen Female_lgbtq = Female*lgbtq
label var Female_lgbtq "LGBTQ and Female"
gen trans = 0
label var trans "Transgender"
replace trans = 1 if (Gender == 3 | Gender == 4)
gen gay = 0
label var gay "Gay"
replace gay = 1 if (Sex == 2)
gen lesbian = 0
label var lesbian "Lesbian"
replace lesbian = 1 if (Sex == 3)
gen bisexual = 0
label var bisexual "Bisexual"
replace bisexual = 1 if (Sex == 4)
gen queer = 0
label var queer "Queer"
replace queer =1 if (Gender == 5)

foreach x in 1 2 3 4 5 6 7 8 9{
	rename Risk`x'_Head Risk_Head_`x'
	rename Risk`x'_Lot Risk_Lot_`x'
	rename Risk`x'_pay Risk_Pay_`x'
	label var Risk_Lot_`x' "Average for Round `x'"
}

gen forever_single = 0
label var forever_single "No Previous Relationship"
replace forever_single = 1 if Past_Relat == 5
gen dating = 0
label var dating "Currently Dating"
replace dating = 1 if Curr_Relat != 1
gen Long_Term_Relat = 0
label var Long_Term_Relat "Long-Term Relationship > 6 Months"
replace Long_Term_Relat = 1 if (Curr_Relat == 4 | Curr_Relat == 5)
gen Recent_Breakup = 0
label var Recent_Breakup "Recently Brokeup < 6 Months Ago"
replace Recent_Breakup = 1 if (Months_Sep == 2 | Months_Sep == 4)
gen LGBTQ_Church = 0
label var LGBTQ_Church "If in LGBTQ Church Session"
tostring Date, replace
replace LGBTQ_Church = 1 if (Date == "21653")

egen risk_per_1 = rowmean(Risk_Lot_1 Risk_Lot_2 Risk_Lot_3)
label var risk_per_1 "Average for Rounds 1-3"
egen risk_per_2 = rowmean(Risk_Lot_4 Risk_Lot_5 Risk_Lot_6)
label var risk_per_2 "Average for Rounds 4-6"
egen risk_per_3 = rowmean(Risk_Lot_7 Risk_Lot_8 Risk_Lot_9)
label var risk_per_3 "Average for Rounds 7-9"
egen risk_avg = rowmean(Risk_Lot_1 Risk_Lot_2 Risk_Lot_3 Risk_Lot_4 Risk_Lot_5 Risk_Lot_6 Risk_Lot_7 Risk_Lot_8 Risk_Lot_9)
label var risk_avg "Average for Rounds 1-9"

order Subject_ID Date risk_avg risk_per_1 risk_per_2  risk_per_3
order lgbtq Female_lgbtq trans gay lesbian bisexual queer, after(Sex)
order forever_single dating Long_Term_Relat Recent_Breakup, after(Months_Sep)

label define a 1 "Male" 2 "Female" 3 "Trans Male" 4 "Trans Female" 5 "Queer" 6 "Not Listed" 
label values Gender a
label define b 1 "Hetero" 2 "Gay" 3 "Lesbian" 4 "Bisexual" 5 "Not Listed"
label values Sex b
label define c 1 "Not Currently in Relationship" 2 "1-3 Months" 3 "4-6 Months" 4 "7-12 Months" 5 "12+ Months"
label values Curr_Relat c
label define d 1 "I ended it" 2 "They ended it" 3 "Amicable Seperation" 4 "Seperated by Death" 5 "No Previous relationship"
label values Past_Relat d
label define e 1 "Doesn't Apply" 2 "1-3 Months" 3 "4-6 Months" 4 "7-12 Months" 5 "12+ Months"
label values Months_Sep e
label define f 1 "Everyday" 2 "2-3 times a week" 3 "Once a week" 4 "Once a Month" 5 "Never"
label values Work_Out f
label define g 1 "This Week" 2 "In Past 2 Weeks" 3 "This Past Month" 4 "In Past 6 Months" 5 "Not Within Past Year"
label values Clothes g
label define h 0 "Male" 1 "Female" 
label values Female h
label define i 0 "Non-Lover" 1 "Lover" 
label values Love i
label define j 0 "Tails" 1 "Heads"
label values Risk_Head_1 Risk_Head_2 Risk_Head_3 Risk_Head_4 Risk_Head_5 Risk_Head_6 Risk_Head_7 Risk_Head_8 Risk_Head_9 j
label define k 0 "Non-LGBTQ" 1 "LGBTQ"
label values lgbtq k
label define l 0 "Non-Trans" 1 "Trans"
label values trans l
label define m 0 "Previous Relationship" 1 "No Previous Relationship"
label values forever_single m
label define n 0 "Not Dating" 1 "Dating"
label values dating n
label define o 0 "Not in Long-Term Relationship" 1 "Long-Term Relationship"
label values Long_Term_Relat o
label define p 0 "No Recent Breakup" 1 "Recent Breakup"
label values Recent_Breakup p
label define q 0 "Not Gay" 1 "Gay"
label values gay q
label define r 0 "Not Lesbian" 1 "Lesbian"
label values lesbian r
label define s 0 "Not Bisexual" 1 "Bisexual"
label values bisexual s
label define t 0 "Not Queer" 1 "Queer"
label values queer t
label define u 0 "Not Interaction" 1 "Interaction Female/LGBTQ"
label values Female_lgbtq u
label define v 0 "Not in LGBTQ Church" 1 "In LGBTQ Church"
label values LGBTQ_Church v

// Summary Statistics
outreg2 using `output'\\sum_stats.xls, excel sum(log) replace

//Balance Tables
table1, vars(Age contn \ Female bin \ forever_single bin \ Love bin \ dating bin \ Long_Term_Relat bin \ Recent_Breakup bin \ Dict_Sent contn \ risk_avg contn \ risk_per_1 contn \ risk_per_2 contn \ risk_per_3 contn \ Risk_Lot_1 contn \ Risk_Lot_2 contn \ Risk_Lot_3 contn \ Risk_Lot_4 contn \ Risk_Lot_5 contn \ Risk_Lot_6 contn \ Risk_Lot_7 contn \ Risk_Lot_8 contn \ Risk_Lot_9 contn \) onecol by(lgbtq) format(%10.2f) test saving(`output'\\bal_tab.xls, replace)

//Correlation Matrix
pwcorr risk_avg risk_per_1 risk_per_2 risk_per_3 Dict_Sent lgbtq Female Female_lgbtq trans gay lesbian bisexual queer Love forever_single dating Long_Term_Relat Recent_Breakup Age, star(.05)

// Export
de
save `edit'\master.dta, replace

