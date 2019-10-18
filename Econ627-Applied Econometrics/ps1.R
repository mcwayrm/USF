
#########################################
        # Applied Econometrics
        # Problem Set 1
        # Ryan McWay
########################################
 
# Set Working Directory
setwd("C:/Users/Ryry/Documents/Ryan/USF/2019-Fall/Econ627_IDEC_Econometrics/ps1")


#################################
#       Declare Dependencies
#################################
#----------------------------------------------------------------------

# Handling Dataframes
library("tidyverse")
library("dplyr")
library('plm')
# Stata tools converted 
library("haven")
library("labelled")
# Plotting tools
library("ggplot2")
library("ggthemes")
# Pretty Regression Outputs
library('jtools')
# Time Series Operations
library('sandwich') #TODO: Unsure if I need sandwich
library('tseries')
library('forecast')
library('dynlm')
# Statistical Tools
library('lmtest')
library('irr')
library('margins')
library("aod")
# Matrix and Indeces Tools
library("scales")
# Compile into a .docx
library("knitr")

#TODO: Categorize the libaries by reason to determine purpose

library("hmisc")
library("stringr")
library('punitroots')
 
#----------------------------------------------------------------------

#################################
#           Question 1 
#################################
# Load Data and Check it
woodstove <- read_dta('./woodstove.dta')
head(woodstove)
View(woodstove)

#       a)
# Drop if hh_id > 30
woodstove_clean <-  subset(woodstove, hh_id < 31)
View(woodstove_clean)

#       b)
# Label hheadoccupation
var_label(woodstove_clean$hheadoccupation) <- "Occupation of head of household"
# Variables and their Descriptions
look_for(woodstove_clean, labels = TRUE)

#       c & d)
# List of values for hheadoccupation
unique(woodstove_clean$hheadoccupation)
# Create string Variable 'work' 
woodstove_clean <-
  woodstove_clean %>%
  mutate(
    work = case_when(
      str_detect(hheadoccupation, "secretary") ~ 1,
      str_detect(hheadoccupation, "government official") ~ 1,
      str_detect(hheadoccupation, "teacher") ~ 2,
      str_detect(hheadoccupation, "teach") ~ 2,
      str_detect(hheadoccupation, "teach school") ~ 2,
      str_detect(hheadoccupation, "schoolteacher") ~ 2,
      str_detect(hheadoccupation, "police") ~ 2,
      str_detect(hheadoccupation, "pastor") ~ 2,
      str_detect(hheadoccupation, "woodsman") ~ 3,
      str_detect(hheadoccupation, "bricklayer") ~ 3,
      str_detect(hheadoccupation, "coffeefarmer") ~ 3,
      str_detect(hheadoccupation, "coffeefarming") ~ 3,
      str_detect(hheadoccupation, "coffeepicker") ~ 3,
      str_detect(hheadoccupation, "coffee picker") ~ 3,
      str_detect(hheadoccupation, "coffeeworker") ~ 3,
      str_detect(hheadoccupation, "carpinter") ~ 3,
      str_detect(hheadoccupation, "carpintr") ~ 3,
      str_detect(hheadoccupation, "construction") ~ 3,
      str_detect(hheadoccupation, "laborer") ~ 3,
      str_detect(hheadoccupation, "mechanic") ~ 3
    ),
    
    work_str_label = case_when(
      work == 1 ~ "whitecollar",
      work == 2 ~ "bluecollar",
      work == 3 ~ "agriculture"
    ),
    
    var_label(woodstove_clean$work_str_label) <- "Worktype"
  )

#       e)
# Dummy Variable for 'whitecollar'
woodstove_clean$wc_dummy = ifelse(woodstove_clean$work == 1, 1, 0)

#       f & g)
  #TODO: Need to work out a regression loop with for given an outcome_list

# OLS Regression for 'stove1'
ols_reg_stove <- lm(stove1 ~ cargasday + coughdays + backpaindays, data = woodstove_clean)
summ(ols_reg_stove)
# OLS Regression for 'whitecollar'
ols_reg_stove <- lm(wc_dummy ~ cargasday + coughdays + backpaindays, data = woodstove_clean)
summ(ols_reg_stove)


#################################
#           Question 2 
#################################
# Load Data and Check it
wdi <- read_dta("./WDI_FDI_data.dta")
View(wdi)

#       a)
# Create Mex df
mex_df <- wdi[which(wdi$countrycode == 'MEX'),]
View(mex_df)
# Regress GDPpc on year
reg_mex <- lm(gdp_pc_gr ~ year, data = mex_df)
summ(reg_mex)
# Durbin Watson test for Serial Correlation
dwtest(reg_mex)
    # At a 10% level, it appears there could be some weak SC in this model

  #TODO: Mimi, what was the purpose of this Wald Test?
coeftest(reg_mex, vcov = vcovHC(reg_mex, "HC1"))

#       b)

ggplot(mex_df, aes(year, gdp_pc_gr)) +
  geom_line() +
  labs(title = "Time Series Plot - Mexico GDPpc and Year",
       subtitle = "Examining stationarity") +
  theme(plot.title =  element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))
  # Visually, seems stationary


# Only GDPpc column
gdp_pc <- mex_df%>%
  select(9)
View(gdp_pc)
# GPDpc made Time Series
gdp_pc <- ts(gdp_pc, start=c(1950,1))
gdp_pc <-na.omit(gdp_pc)
is.numeric(gdp_pc)
plot(gdp_pc)
# Differencing GDPpc if needed
gdp_pc_diff <- diff(gdp_pc, differences=1)
plot(gdp_pc_diff)

# Augmented Dickey-Fuller Test 
mex_df_test <- adf.test(gdp_pc, alternative = "stationary")
print(mex_df_test)
    # We have stationarity

#       c) 
# Fitting different versions of the ARIMA Model
arima_011 <- auto.arima(gdp_pc, seasonal = FALSE)
coeftest(arima_011)

arima_101 <- arima(gdp_pc, order = c(1,0,1))
coeftest(arima_101)

arima_100 <- Arima(gdp_pc, order = c(1,0,0))
coeftest(arima_100)

arima_102 <- arima(gdp_pc, order = c(1,0,2))
coeftest(arima_102)

arima_201 <- arima(gdp_pc, order = c(2,0,1))
coeftest(arima_201)

arima_202 <- arima(gdp_pc, order = c(2,0,2))
coeftest(arima_202)
# Check the Information Criteria for Best Fit
AIC(arima_011, arima_101, arima_100, arima_102, arima_201, arima_202)
BIC(arima_011, arima_101, arima_100, arima_102, arima_201, arima_202)

# ARIMA Forecast for 2016-2020
arima_forecast <- forecast(arima_011, h=5)
plot(arima_forecast)
head(arima_forecast)

#       d)
# Granger Causality Test for GDP and FDI
grangertest(mex_df$gdp_pc_gr ~ mex_df$fdi_pcgdp)
grangertest(mex_df$fdi_pcgdp ~ mex_df$gdp_pc_gr)
    # No evidence of granger causality here

#       e)
#e. No direct way to do interrupted time series. 
# Following steps from the guide https://github.com/gasparrini/2017_lopezbernal_IJE_codedata/blob/master/Rcode.R to try and do this as well as in https://rpubs.com/mhanauer/286630


# Dummy for 1994
mex_df$dummy = ifelse(mex_df$year >= 1994, 1, 0)
View(mex_df$dummy)

# Interrupted Time Series for GDP
gdp_its <- lm(gdp_pc_gr ~ dummy, data = mex_df)
summ(gdp_its)
    # No Effect on GDPpc
# Interrupted Time Series for FDI
fdi_its <- lm(fdi_pcgdp ~ dummy, data = mex_df)
summary(fdi_its)
    # A positive effect on FDI

#################################
#           Question 3 
#################################

#       a)
# Check that GDPpc is stationary

# Full WDI without na
wdi_full <-  wdi%>%
  select(year, countrycode, gdp_pc_gr, fdi_pcgdp)
wdi_full <- na.omit(wdi_full, fdi_pcgdp)
View(wdi_full)
# Balance the Panel Data
panel_gdp <- pdata.frame(wdi_full, index = c("year")) %>%
  make.pbalanced(panel_gdp, balance.type = c("shared.times"), index = c("year", "countrycode"))
View(panel_gdp)
# Test for Panel Unit Root
purtest(panel_gdp$gdp_pc_gr, data = panel_gdp, index = c("year","countrycode"), lags = 1 ,test = "levinlin", exo = "intercept")                      
      # Reject that GDPpc is a unit root

#       b)
# Declare GDPpc and FDI as time series so we can impose lags
gdp_pc_gr_ts <-  ts(panel_gdp$gdp_pc_gr)
fdi_pcgdp_ts <-  ts(panel_gdp$fdi_pcgdp)
year_ts <-  ts(panel_gdp$year)
# Test for granger causality
  #TODO: Unsure about how to add lags to a fixed effects model in R
fdi_on_gdp_reg <-  dynlm(gdp_pc_gr_ts ~ L(gdp_pc_gr_ts, 1) + L(gdp_pc_gr_ts, 2) + L(fdi_pcgdp_ts, 1) + L(fdi_pcgdp_ts, 2) + year_ts)
summ(fdi_on_gdp_reg)
fdi_on_gdp_reg_restricted <-  dynlm(gdp_pc_gr_ts ~ L(gdp_pc_gr_ts, 1) + L(gdp_pc_gr_ts, 2) + year_ts)
summ(fdi_on_gdp_reg_restricted)
var.test(fdi_on_gdp_reg, fdi_on_gdp_reg_restricted, ratio = 1)
    # No significant difference

#       b) PART 2
gdp_on_fdi_reg <-  dynlm(fdi_pcgdp_ts ~ L(fdi_pcgdp_ts, 1) + L(fdi_pcgdp_ts, 2) + L(gdp_pc_gr_ts, 1) + L(gdp_pc_gr_ts, 2) + year_ts)
summ(gdp_on_fdi_reg)
gdp_on_fdi_reg_restricted <-  dynlm(fdi_pcgdp_ts ~ L(fdi_pcgdp_ts, 1) + L(fdi_pcgdp_ts, 2) + year_ts)
summ(gdp_on_fdi_reg_restricted)
var.test(gdp_on_fdi_reg, gdp_on_fdi_reg_restricted)
    # No significant difference

#################################
#           Question 4 
#################################

#       a)
# Creating woodstove with baseline 2008
woodstove_2008 <- subset(woodstove, year == 2008)
View(woodstove_2008)

# Intraclass Correlation
icc(cbind(woodstove_2008$hh_id, woodstove_2008$weaknessdays), model = c('oneway'))
icc(cbind(woodstove_2008$hh_id, woodstove_2008$diarrheadays), model = c('oneway'))
icc(cbind(woodstove_2008$hh_id, woodstove_2008$coughdays), model = c('oneway'))
icc(cbind(woodstove_2008$hh_id, woodstove_2008$mucusdays), model = c('oneway'))
icc(cbind(woodstove_2008$hh_id, woodstove_2008$redeyedays), model = c('oneway'))
icc(cbind(woodstove_2008$hh_id, woodstove_2008$backpaindays), model = c('oneway'))
icc(cbind(woodstove_2008$hh_id, woodstove_2008$faintdays), model = c('oneway'))
icc(cbind(woodstove_2008$hh_id, woodstove_2008$feverdays), model = c('oneway'))
    # Highest ICC = Feverdays
    # Lowest ICC = Backpaindays

#       b)
woodstove_2008_clean <- na.omit(woodstove_2008)
# Pooled OLS Regression
plm_pooled <- plm(repcoughing ~ educ + female + age+ age2, data = woodstove_2008_clean, model = "pooling", index = "hh_id")
summary(plm_pooled)
# Fixed Effects Regression
plm_fixed <- plm(repcoughing ~ educ + female + age+ age2, data = woodstove, model = "within", index = "hh_id")
summary(plm_fixed)
# Random Effects Regression
plm_random <- plm(repcoughing ~ educ + female + age+ age2, data = woodstove, model = "random", index ="hh_id")
summary(plm_random)

#       c)
# Hausman Test
phtest(plm_fixed, plm_random, vcov = vcovHC)
    # We need those Fixed Effects


#################################
#           Question 5 
#################################

#       a)
# LP Regression
cough_LP <- glm(repcoughing ~ openfire + female + child + age, data = woodstove)
summ(cough_LP)
# Logit Regression
cough_logit <- glm(repcoughing ~ openfire + female + child + age, data = woodstove, family = binomial(link = "logit"))
summ(cough_logit)
# Probit Regression
cough_probit <- glm(repcoughing ~ openfire + female + child + age, data = woodstove, family = binomial(link = "probit"))
summ(cough_probit)
    # Coefficents are different because they are maximum likelihood measures. Will need to take the margins to find marginal effect similar to LP model.

#       b)
cough_logit_margins <- margins(cough_logit)
summary(cough_logit_margins)
summ(cough_LP)
    # Kind of close, but the logit marginal effects are smaller

#       c)
wald.test(b = coef(cough_logit), Sigma = vcov(cough_logit), Terms = 3:5)
    # Significant, so important variables in the model.

#       d)
# Limited woodstove and removing na
woodstove_limited <- woodstove %>%
  select(repcoughing, openfire, female, child, age, backpaindays) %>%
  na.omit(repcoughing, openfire, female, child, age, backpaindays)
# Logit with limited regression
cough_logit_limited <- glm(repcoughing ~ openfire, data = woodstove_limited, family = binomial(link = "logit"))
# Logit with restricted woodstove data
cough_logit_restricted <- glm(repcoughing ~ openfire + female + child + age, data = woodstove_limited, family = binomial(link = "logit"))
# Likelihood Ratio Test
lrtest(cough_logit_limited, cough_logit_restricted)
    # The variables in the model are important

#       e)
# Repeat a-d for 'backpain'
woodstove_limited$backpain = ifelse(woodstove_limited$backpaindays > 0, 1, 0)
# Logit with limited regression
backpain_logit_restricted <- glm(backpain ~ openfire, data = woodstove_limited, family = binomial(link = "logit"))
# Logit with restricted woodstove data
backpain_logit <- glm(backpain ~ openfire + female + child + age^2, data = woodstove_limited, family = binomial(link = "logit"))
# Likelihood Ratio Test
lrtest(backpain_logit_restricted, backpain_logit)
    # Similar Finding

#################################
#           Question 6
#################################

#       a)
    #TODO: Improve Anderson Index. Not sure this is correct...

# Create Anderson Index
myvars <- c("coughdays", "diarrheadays", "mucusdays", "feverdays")
index_woodstove <- woodstove[myvars] 
matrix <- data.matrix(index_woodstove)
for(i in 1:4){
  matrix[is.na(matrix[,i]), i] <- mean(matrix[,i], na.rm = TRUE)
}
scaled.mat <- scale(matrix)

View(scaled.mat)

#       b)
# Summary Index
anderson_index

#       c)
# OLS Anderson Index Regression
index_reg <- lm(anderson_index ~ stove1 + age + age2 + female, data = woodstove)

