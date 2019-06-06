clear
set more off
log close _all
cap log using raffle.log, text replace

/*****************
Description:
	 Raffle to pick the winner.
	 The PDF documents when we ran it, to ensure transparency that we did in fact randomly choose a person from the group.
*****************/

global USER "The Love Experts"
local date `c(current_date)'
local time `c(current_time)'
local home "local"
//***** All paths should be relative so that all you need to change is `home' in order to run the dofile.
cd "`home'"
local edit "`home'\edit"
local output "`home'\output"
**************************************************************************
display "Analysis run by $USER running the raffle at `date' and `time'"

use `edit'\\master.dta, clear
count if Qualify == 1
keep if Qualify == 1
// Create Tickets
gen Tickets = Risk_Pay_1 if Round_Choosen == 1
foreach x in 2 3 4 5 6 7 8 9{
	replace Tickets = Risk_Pay_`x'  if Round_Choosen == `x'
}
expand = Tickets
// Setting the seed means that we can reproduce the every time the same random choice, without it we will get a different person each time.
set seed 25
sample 1 , count 
count

// Winner is the second person, whose Qualify = 1, and their email should be right next to it. 
list

cd "`output'"
cap log close
translate raffle.log raffle.pdf, replace
