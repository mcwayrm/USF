
#########################################
# Applied Econometrics
# Problem Set 2
# Ryan McWay
########################################

# Set Working Directory
setwd("C:/Users/Ryry/Documents/Ryan/USF/2019-Fall/Econ627_IDEC_Econometrics/ps2")


#################################
#       Declare Dependencies
#################################
#----------------------------------------------------------------------

# Handling Dataframes
library("tidyverse")
# Stata tools converted 
library("haven")
# Pretty Outputs
library('jtools')
library('stargazer')
# Statistical Tools
library('margins')
library('truncreg')
library('AER')
library('sampleSelection')
# Matrix Algebra
library('matlib')
library('matrixcalc')
library('Matrix') 


#----------------------------------------------------------------------

#################################
#           Question 1 
#################################
# Create Dataset
x <- c(1, 2, 3, 4, 5) 
y <- c(0, 1, 0, 1, 1)
Q1_data <-  data.frame(x, y)

#       a)
# Adding -1 in the regression removes the constant
Q1_logit <- glm(y ~ x - 1, data = Q1_data, family = binomial(link = "logit"))
stargazer(Q1_logit, title = "Question 1 Logit", type = 'text')

#       b)
Q1_margin <- margins(Q1_logit, at = list(x = 3))
stargazer(Q1_margin, title = "Logit Marginal Effects", type = 'text')
summary(Q1_margin)

#################################
#           Question 2 
#################################
# Load Data and Check it
woodstove <- read_dta('./woodstove.dta')
View(woodstove)

#       a)
eyes_ols <-  lm(redeyedays ~ educ + year + age + age2 + female, data = woodstove, subset = (redeyedays > 0))
stargazer(eyes_ols, title = "Redeyedays OLS Regression", type = 'text')

#       b)
eyes_trunc_reg <-  truncreg(redeyedays ~ educ + year + age + age2 + female, data = woodstove, point = 0, direction = 'left')
summary(eyes_trunc_reg)

#       c)
# Answered in Stata version

#################################
#           Question 3
#################################

#       a)
woodstove %>% 
  ggplot(aes(x = coughdays)) +
  geom_histogram(binwidth = 1, color = 'black') + 
  stat_function(fun = dnorm, color = 'red',
                args = list(mean = mean(woodstove$coughdays), sd = sd(woodstove$coughdays)))
  # Censors at 0 and 21

#       b)
# Tobit with censor at 0
tobit_lower <- tobit(coughdays ~ age + age2 + female + year2009, data = woodstove, left = 0)
stargazer(tobit_lower, title = "Tobit with Lower Bound Regression", type = 'text')

# Tobit with censor at 0 and 21
tobit_both <- tobit(coughdays ~ age + age2 + female + year2009, data = woodstove, left = 0, right = 21)
stargazer(tobit_both, title = "Tobit Double Bounded Regression", type = 'text')

#       c)
woodstove %>% 
  ggplot(aes(x = redeyedays)) +
  geom_histogram(binwidth = 1, color = 'black')
    # Censors at 0 and 21

# Tobit with censor at 0
tobit_lower_eyes <- tobit(redeyedays ~ age + age2 + female + year2009, data = woodstove, left = 0)
stargazer(tobit_lower_eyes, title = "Redeyes Tobit Lower Bound", type = 'text')

# Tobit with censor at 0 and 21
tobit_both_eyes <- tobit(redeyedays ~ age + age2 + female + year2009, data = woodstove, left = 0, right = 21)
stargazer(tobit_both_eyes, title = "Redeyes Tobit Double Bound", type = 'text')

#################################
#           Question 4
#################################

#       a)
# Answer is Stata

#       b)
heckman_eq <- heckit(lotteryhh ~ age + age2 + female + year2009, coughdays ~ age + age2 + female + year2009, data = woodstove)
summary(heckman_eq)
stargazer(heckman_eq, title = "Heckman Twostep Estimation", type = 'text')
heckman_eq$probit
heckman_eq$sigma
heckman_eq$rho

#       c)
# Answer is Stata

#       d)
# Answer is Stata

#################################
#           Question 5
#################################

#       a)
first_stage <-  lm(stove1 ~ age + age2 + female + year2009 + lotteryhh, data = woodstove)
stove1_resid <- resid(first_stage)
sec_stage <- lm(coughdays ~ stove1 + age + age2 + female + year2009 + stove1_resid, data = woodstove)

#       b)
iv_reg <-  ivreg(coughdays ~ age + age2 + female + year2009 | stove1 + I(lotteryhh), data = woodstove) 
summary(iv_reg, vcov = sandwich, df = Inf, diagnostics = TRUE)

#       c)
# Answer is Stata

#################################
#           Question 6
#################################

#       e)
constant <-  c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1)
x_2 <- c(70, 65, 90, 95, 110, 115, 80, 200, 190, 100)
y_2 <- c(80, 100, 120, 140, 160, 180, 200, 220, 240, 260)
village <- c(2, 2, 1, 1, 2, 2, 1, 2, 1, 1)
Q6_data <-  data.frame(constant, x_2, y_2, village)
View(Q6_data)

#   Standard Errors

ols <- lm(y_2 ~ x_2, data = Q6_data)
summ(ols)
ols_res <- resid(ols)
ols_res_sq <-  ols_res^2

x_mtrx <- data.matrix(Q6_data$x_2)
x_transpose <- t(x_mtrx)
y_mtrx <-  data.matrix(Q6_data$y_2)
e_mtrx <-  data.matrix(ols_res)

betas <-  solve(crossprod(x_mtrx), crossprod(x_mtrx, y_mtrx))
print(betas)


#   Robust Standard Errors
# Make Bread
bread <- solve(crossprod(x_mtrx))
# Make Butter
res_sq_diag <- diag(ols_res_sq)
butter <- x_transpose %*% res_sq_diag %*% x_mtrx
print(butter)
# Robust SE
robust_se_mtrx <- bread %*% butter %*% bread
print(robust_se_mtrx)
# Adjust for Degrees of Freedom
adj_robust_se_mtrx <- (nrow(x_mtrx)/(nrow(x_mtrx) - ncol(x_mtrx))) * robust_se_mtrx
print(adj_robust_se_mtrx)
# Get Beta_0 and Beta_1
beta_0 <- sqrt(adj_robust_se_mtrx)
print(beta_0)
beta_1 <- #TODO: Need to figure this part out
print(beta_1)

#   Clustered Standard Errors
# Village 1 subset
village_1 = subset(Q6_data, village == 1)
ols_v1 <- lm(y_2 ~ x_2, data = village_1)
ols_v1_res <- resid(ols_v1)
ols_v1_res_sq <-  ols_v1_res^2

x_v1_mtrx <- data.matrix(village_1$x_2)
x_v1_transpose <-  t(x_v1_mtrx)
e_v1_mtrx <- data.matrix(ols_v1_res_sq)
e_v1_transpose <- t(e_v1_mtrx)

butter_v1 <- x_v1_transpose %*% e_v1_mtrx %*% e_v1_transpose %*% x_v1_mtrx
print(butter_v1)

# Village 2 subset
village_2 = subset(Q6_data, village == 2)
ols_v2 <- lm(y_2 ~ x_2, data = village_2)
ols_v2_res <- resid(ols_v2)
ols_v2_res_sq <-  ols_v2_res^2

x_v2_mtrx <- data.matrix(village_2$x_2)
x_v2_transpose <-  t(x_v2_mtrx)
e_v2_mtrx <- data.matrix(ols_v2_res_sq)
e_v2_transpose <- t(e_v2_mtrx)

butter_v2 <- x_v2_transpose %*% e_v2_mtrx %*% e_v2_transpose %*% x_v2_mtrx
print(butter_v2)

# Add clustered Matricies
cluster_butter <- butter_v1 + butter_v2
print(cluster_butter)
