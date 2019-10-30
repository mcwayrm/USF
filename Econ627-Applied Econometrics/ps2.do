clear
set more off
clear matrix
clear mata
log close _all
cap log using ps2.smcl, smcl replace 

/*****************
Description:
	Applied Econometrics for IDEC Problem Set #2
*****************/

global USER "Ryan McWay"
local date `c(current_date)'
local time `c(current_time)'
local home "C:\Users\Ryry\Documents\Ryan\USF\2019-Fall\Econ627_IDEC_Econometrics\ps2"
**************************************************************************
display "Analysis run by $USER for Problem Set #2 at `date' and `time'"
cd `home'

/******************************************	
		Part 1: Compare MLE with Excel
******************************************/
// Create Dataset provided
input x y
1 0
2 1
3 0 
4 1
5 1
end
list
//****		a)
logit y x, noconstant
/*
	The beta for my logit in excel matches this beta
*/

//****		b)
margins, dydx(*) atmeans
/*
	The marginal effect in excel matches this dy/dx
*/

/******************************************	
		Part 2: Truncated Regression
******************************************/
use "`home'\woodstove.dta", clear
//****		a)
reg redeyedays educ year age age2 female if redeyedays > 0

//****		b)
truncreg redeyedays educ year age age2 female, ll(0)

/*
	Both have consistent t-statistics, although the magnitudes for the truncated regression are slightly larger.
*/

//****		c)
/*
	Typically truncated data are biased downward. This is consistent with my results since the truncated regression has larger magnitudes than the OLS.
*/

/******************************************	
		Part 3: Tobit Estimation
******************************************/
use "`home'\woodstove.dta", clear
//****		a)
hist coughdays, normal name(hist_coughs, replace)
	graph export hist_coughs.pdf, replace 
/*
	There is clear evidence that the data is censored at zero. There is a bit of kurtosis at 21 so perhaps there is some censorship beyond 21 but it is unclear.
*/

//****		b)
// Censoring from below
tobit coughdays age age2 female year2009, ll(0)
// Censoring from above and below
tobit coughdays age age2 female year2009, ll(0) ul(21)

/*
	The significance between the two regressions are almost nearly identitical. The coefficents for both are also very similar. The only major difference between the two estimations are the constant and var(e.coughdays) which is much larger for two sided censored tobit regression. Also the log likelihood converged at a far more positive point for the second regression than for the second. 
*/

//****		c)
// Histogram for redeyedays
hist redeyedays, normal name(hist_eyes, replace)
	graph export hist_eyes.pdf, replace 
// Censoring from below
tobit redeyedays age age2 female year2009, ll(0)
// Censoring from above and below
tobit redeyedays age age2 female year2009, ll(0) ul(21)

/*
	Histogram clearly shows there is censorship at zero and 21 for redeyedays.
	Much like the previous two tobit estimations for coughdays, redeyedays has the same pattern in terms of significance, magnitudes, constant, var(e.redeyedays) and log likelihood. 
*/

/******************************************	
		Part 4: Heckman Estimation
******************************************/
use "`home'\woodstove.dta", clear
//****		a)
/*
	We would use a Tobit estimation if we believed that censoring occured for the same reason of selection as for behavior. 
	In this dataset, I believe that Heckman is better because the survey design of asking about the last 21 days is the limiting selection. Specifically, they were randomly assigned based on a household lottery to be asked. So the selection equation should not be equal to the behavioral equation.
*/

//****		b)
heckman coughdays age age2 female year2009, select(lotteryhh = age age2 female year2009) twostep
/*
	The Heckman estimation changed the control variables so that only those accounted for by lotteryhh were significant. It appears that lotteryhh accounts for a large portion of the effect. 
*/

//****		c)
/*
	Lambda is statistically significant. This is the Inverse Mills Ratio and tells if accounting for non-seleciton hazard is necessary. Being signifcant, it means that a heckman estimation is appropriate for accounting for non-selection hazard.
*/

//****		d)
/*
	The two step heckman estimation estimates a selection equation and a behavioral equation seperately. In this way, the heckman estimation seperates the correlation of selection into treatment from the effect of treatment on behavior.
	Heckman twostep is not like a Heckman MLE because it uses a selection equation to estimate the correlative effective before the behavorial equation. Therefore it is closer to 2SLS model than it is to a maximum likelihood estimator.
*/

/******************************************	
		Part 5: Instrumental Varibales Estimation
******************************************/

//****		a)
reg stove1 age age2 female year2009 lotteryhh
predict stove1_resid, res
reg coughdays stove1 age age2 female year2009 stove1_resid
/*
	No, allocation is not likely to have been an exogenous variable.
	Yes, lotteryhh is a strong first-stage instrument because we randomly assigned it upon implementation of the program.
	But because stove1_resid was not significant the second regression, I do not believe that lotteryhh is exogenous and is not a good instrument.
	stove1 is exogenous because the residuals of stove1 were insignificant.
*/

//****		b)
reg coughdays stove1 age age2 female year2009
estimates store ols
ivregress 2sls coughdays age age2 female year2009 (stove1 = lotteryhh)
estimates store iv
hausman ols iv
/*
	The Hausman test says that OLS is efficent. So my results agree with the regression test.
*/

//****		c)
/*
	For this dataset, given the equations I have run I would choose a Heckman twostep estiamtion. This is because it is censored and the selection and behavioral equation are differnt.
*/

/******************************************	
		Part 6: Compare MLE with Excel
******************************************/
clear all 
input y constant x village
80	1	70	2
100	1	65	2
120	1	90	1
140	1	95	1
160	1	110	2
180	1	115	2
200	1	80	1
220	1	200	2
240	1	190	1
260	1	100	1
end
//****		e) 

// 		Standard Errors
reg y x
predict es, res
gen es_sq = es^2
mkmat constant x, matrix (x_mtrx)
matrix list x_mtrx
mkmat y, matrix (y_mtrx)
mkmat es, matrix (es_mtrx)
matrix list es_mtrx
matrix betas = invsym(x_mtrx' * x_mtrx) * (x_mtrx' * y_mtrx)
matrix list betas

// 		Robust Standard Errors
* Create matrix [(X'X)-1][Sum_e^2*X'X][(X'X)-1]
* Bread
matrix bread = invsym(x_mtrx' * x_mtrx)
matrix list bread

* Butter
mkmat es_sq, matrix (es_sq_mtrx)
matrix list es_sq_mtrx
matrix diag_es_sq_mtrx = diag(es_sq_mtrx)
matrix list diag_es_sq_mtrx
matrix butter = x_mtrx' * diag_es_sq_mtrx * x_mtrx
matrix list butter

* Robust SE
matrix robust_se_mtrx = bread * butter * bread
matrix list robust_se_mtrx

* Multiply by n/(n-k)
matrix adj_robust_se_mtrx = (rowsof(x_mtrx)/(rowsof(x_mtrx) - colsof(x_mtrx))) * robust_se_mtrx
matrix list adj_robust_se_mtrx

* Beta 0 and Beta 1
scalar robust_se_beta0 = sqrt(adj_robust_se_mtrx[1,1])
scalar robust_se_beta1 = sqrt(adj_robust_se_mtrx[2,2])
di robust_se_beta0
di robust_se_beta1

// 		Clustered Standard Errors
* First do Village 1
preserve
keep if village == 1
mkmat constant x, matrix (x_v1_mtrx)
matrix list x_v1_mtrx
mkmat es, matrix (es_v1_mtrx)
matrix list es_v1_mtrx
matrix butter1 = x_v1_mtrx' * es_v1_mtrx * es_v1_mtrx' * x_v1_mtrx
matrix list butter1
global butter_1 butter1
restore

* Village 2 Butter
preserve
keep if village == 2
mkmat constant x, matrix (x_v2_mtrx)
matrix list x_v2_mtrx
mkmat es, matrix (es_v2_mtrx)
matrix list es_v2_mtrx
matrix butter2 = x_v2_mtrx' * es_v2_mtrx * es_v2_mtrx' * x_v2_mtrx
matrix list butter2
global butter_2 butter2
restore 

* Add clustered matricies together
matrix cluster_butter = $butter_1 + $butter_2
matrix list cluster_butter 

* Create clustred matrix [(X'X)-1][Sum_e^2*X'X][(X'X)-1]
matrix clustered_se_mtrx = bread * cluster_butter * bread
matrix list clustered_se_mtrx 

* Multiply by a = (M/M-1)(n-1/n-k)
matrix adj_clustered_se_mtrx = (2*rowsof(x_mtrx)-1)/(rowsof(x_mtrx) - colsof(x_mtrx)) * clustered_se_mtrx
// matrix adj_clustered_se_mtrx = (18/8) * clustered_se_mtrx // I don't understand why we do adjusted clustered SE twice here

matrix list adj_clustered_se_mtrx
* Clustered Beta 0 and Beta 1
scalar cluster_beta_0 = sqrt(adj_clustered_se_mtrx[1,1])
scalar cluster_beta_1 = sqrt(adj_clustered_se_mtrx[2,2]) // What is going on here
di cluster_beta_0
di cluster_beta_1

*************************************************************
cap log close
cd `home'
translate ps2.smcl ps2.pdf, replace