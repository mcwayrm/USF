* Stata-Stata-Camp
* Stata Camp Notes
/***************** Basic Properties Check ***************/
ls
pwd
cd
/***************** Automate Import of Datafile ************/
clear
use "'local'\intro.dta"
list
/***************** Browse All Data *****************/
browse
list
/**************** Browse specific category *************/
browse id name
list id name
/*************** List variables and give description ***********/
describe
/************** Describe a specific Variable *************/
describe attendance
**********************************************************************************************************************
/**********************************
This is the do file for the first day
***********************************/
//***** clears past data
clear
//***** Opening a data set
use "'local'\intro.dta"
//***** Listing data points in selection
list school
//***** Total observations in data set
count
//******* Quick summary, and average of Variable
summarize math
//******* Shows the frequency of a variable
tabulate math
clear
use "'local'\saving.dta"
//******** Gives the description of all the variables, should be done before every new assignment/data set import
describe
count
summarize age
tabulate size

/**************
    Quiz 1
***************/
use "'local'\saving.dta"
summarize size
tabulate educ
browse inc sav

********************************************************************************************************************************
/**********************************
This is the do file for the second day
***********************************/
use "'local'\intro.dta", clear
//***** if gives the conditions/constraints
count if female == 0
count if math > 50
browse id if math < 10
list id if math < 10
count if math != 100
//***** & is and, | is or
count if female == 1 & school == 3
count if math > 50 | reading > 50
count if female == 1 | school == 3
list math
list math if female == 1
list math if female == 1 & school == 3
list math if female == 1 | school == 3
/***************************************
Seperate constraints: Use brackets [ ]
****************************************/
list name if female == 1 & [school == 3 | school == 1]
count if school == 1 | school == 2
browse name if school == 1 | school == 2 | school == 3
/********************
Abbreviations:
br = browse
sum = summarize
tab = tabulate
*********************/
br name if school == 1 | school == 2 | school == 3
summarize reading if school ==1 & math > 50
sum reading if school ==1 & math > 50
mean reading if school ==1 & math > 50
tabulate school
tab school
tab school if female == 1
use "'local'\consume.dta", clear
describe
br if hhexp > 50000
br if hhexp > 50000 & expfd < 40000
mean qrice if famsize > 4
mean qrice if famsize == 4 | famsize == 5
mean qrice if famsize > 4 & famsize < 10

/*******************
	Quiz 2
********************/
use "'local'\consume.dta", clear
describe
summarize expnfd2
mean efish if expfd > 10000

*******************************************************************************************************************************
/**********************************
This is the do file for the third day
***********************************/
//***** Log will give a log of the do file commands and the results. End with log close
//***** Will automatically update
//***** replace will update the log file if it already exists
//***** log close_all will close all the other logs. Good reminder before you start a new log
log close_all
log using "'local'\log_day 3.smcl", replace 
clear
use "'local'\intro.dta"
//***** bysort followed by a command, will give you the result of that command sorted by the bysort variable
bysort school: summarize math
bysort female: summarize reading
bysort school: list student id name
tabulate female
bysort school: tabulate female
count if female == 1
count if female == 1 & math > 50
bysort school: count if female == 1 & math > 50
tab school if female == 1 & math > 50
clear
use "'local'\hh.dta"
describe
browse hhcode
list hhcode
bysort region: list hhcode
mean educhead
bysort thana: sum educhead
count if agehead > 20 & agehead < 50
//******* Notice that agehead and age are identical. If you start the beginning of any variable, STATA will infer the variable and finish the commmand
//******* Also, if you begin to type a variable in the commmand bar, and halfway click tab then it will finish the variable
count if age >= 20 & age <= 50
//******* help will show you everything you need to know about a command and how to use it
help use
use "'local'\consume.dta", clear
//******* kdensity will give a density/frequency graph (Bell Curve)
kdensity hhexp
kdensity hhexp if famsize > 10
//******* Scatter will show a scatter plot
scatter hhexp expfd
//******* twoway will overlap the two graphs
//******* lfit is a fitted line for the specified variables
twoway (scatter hhexp expfd) (lfit hhexp expfd) 
//*** Notice the log close. Must always close if you open a log!
log close
//****** translate command will turn the log into a pdf
//****** insheets command will pull an excel and turn it into a stata dta extract


/*******************
	Quiz 3
********************/
use "'local'\hh.dta", clear
describe
kdensity educhead
scatter d_bank hassetg
twoway (scatter d_bank hassetg) (lfit d_bank hassetg)

*********************************************************************************************************************************
/**********************************
This is the do file for the fourth day
***********************************/
log close _all
log using "'local'\log_day 4.smcl", replace
use "'local'\intro.dta", clear
gen variable_a = 100
browse variable_a
//******* Note that variable_b is a string variable
//******* variable_c is a float variable (so can be continous, not neccessarily an interger)
//******* variable_d is an empty variable
gen variable_b = "This is my text value"
gen variable_c = 1.5
gen variable_d = .
browse variable_c variable_d
//******* variable_e is a dummy variable so either 1 or 0
gen variable_e = 1
//******* multivariable shows how you can use pre existing variables to make a new variable
gen multivariable = math * reading
//******* replace will replace the variable with a new definition
replace variable_a = 10
replace variable_b = "This is my new text value"
gen strength = 10
replace strength = 20
replace strength = 25 if school == 1 
tab school
replace strength = 30 if name == "Adam"
replace name = "John" if name == "Adam"
browse if name == "John"
sort school
browse
//******* drop command will delete a variable or an entire set of observations
drop variable_c
drop if student == 17
//******* if you ever modify data, always save in the data_modified folder and keep the raw data pure.
//******* Generally put it at the end before your log close
save "'local'\intro_modified.dta" , replace
clear 
use "'local'\ind.dta" 
describe
drop wnaghr wagrhr
drop if educ > 12
gen saving_2 = indsave^2
replace saving_2 = 0 if age > 50
save "'local'\ind_modified.dta" , replace
log close
//******* Finish.

/*******************
	Quiz 4
********************/
use "'local'\ind.dta", clear
browse sex
gen gender = "M"
replace gender = "F" if sex == 1
gen old = 1
replace old = 2 if age > 50
describe 
count if snaghr == . | wnaghr == .
//******** You can't use . to count missing on a string. So use ""
count if gender == ""
save "'local'\ind_modified2.dta" , replace

***********************************************************************************************************************************
/**********************************
This is a do file for the fifth day
***********************************/
log close _all
log using "'local'\log_day 5.smcl", replace
use "'local'\intro.dta", clear
//****** You can bring multiple datasets into one dataset by using merge or append
help append
//******* Usually for merge, the idcode is the key variable for combining the datasets
help merge
/*******************************
Type of Merge is very important
	1:1		Key has no duplicate values
	1:m		Key has multi duplicates in the second table but not in the 1st (ex. many id 1 or 2 in the 2nd)
	m:1		Key has multi duplicates in the first table but not in the 2nd
	m:m		Key has multi duplicates in both
merge <type> <key variable> using <secondary dataset>
*******************************/
use "'local'\student1.dta", clear
//******** duplicates report will show whether or not the variable is a key variable. Need to make sure it has only 1 copies
duplicates  report student_id 
merge 1:1 student_id using "'local'\student2.dta",
//******** ssc install is the way to download a new command
ssc install distinct
//******** distinct will show # of variables that are distinct
distinct Country
distinct Famincome
distinct name
//******** Need to drop _merge before merging again in the same do file. Or else it will say that the merge is already defined and prevent you from merging
drop _merge
merge 1:m student_id using "'local'\student3.dta",
save "'local'\student.dta", replace
//****** label will give a variable an alias
help label
label variable Country "A Place of birth"
tabulate Country, nolabel
//****** Finish
log close
