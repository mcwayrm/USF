##########################################################################################################
#  
#  Exercise 2 - Fit and Evaluate Models in R tutorial
#  Author: Ryan McWay
#  Appendix 1 - Leave-one-out cross validation                                                          
#
##########################################################################################################

## SECTION 1:  Input Data - Edit these 

setwd("local")
lidarData <- read.csv("BA_lidarData.csv")
respVar = 'BAtotal'
modelFormula = lm(BAtotal~P70*all_1st_cover_mean, data = lidarData)
##########################################################################################################

## SECTION 2: Leave-one-out cross-validation

## specify the data for the cross validation
dataFrame = lidarData
## pull the observed values for the specified response variable
observedRV = dataFrame[,which(colnames(dataFrame)==respVar)]

#Create empty vectors to hold the calculated residuals and another to for the predictions
respVar.cv.resid=numeric(length=nrow(dataFrame))     
respVar.cv.fitted=numeric(length=nrow(dataFrame))       


#Attach the dataset names - Simplifies the lm formula
attach(dataFrame)

#Loop through each row in the dataset, drop one observation, refit the model, predict, calculate error, save
for (i in 1:nrow(dataFrame)) {
  #Refit the linear model with all the observations except one (left out for validation) 
  crossMod=lm(modelFormula, data = dataFrame[-i,])  
  #crossMod=randomForest(modelFormula, data = dataFrame[-i,])  
  #crossMod=glm(modelFormula, data = dataFrame[-i,], family=Gamma())  
  
  #Predict the left out value
  #respVar.pred=predict(crossMod, dataFrame[i,])  
  respVar.pred=predict(crossMod, dataFrame[i,],type="response") 
  
  #Save the prediction to the new vector
  respVar.cv.fitted[i]=respVar.pred 
  #Calculate the difference between the predicted and actual (error)
  observed = observedRV[i]
  respVar.cv.resid[i]=observed-respVar.pred
}

detach(dataFrame)

##########################################################################################################

## SECTION 3: Get the cross-validated error estimate - R-squared and RMSE

##################### Optional - Define a function to calculate Root Mean Square Error (RMSE) ###########
rmse = function(sim, obs){
  sqrt( mean( (sim - obs)^2, na.rm = TRUE) )
}
#########################################################################################################

## Get the cross-validate r-square
cv_rsq <- cor(observedRV,respVar.cv.fitted)**2

##Optional - remove comments below to get the r-square from the model for comparison
#raw_rsq <-cor(observedRV,Lm1$fitted)**2

## Optional- Calculate the rmse between the observed and cv predicted
rmseCV = rmse(respVar.cv.fitted, observedRV)

## SECTION 4: Plot the cross-validation results
## Round R-square value for better display
cv_rsq=round(cv_rsq, digits=3)
rmseCV=round(rmseCV, digits=2)

## Make a plot with the cv results
plot(dataFrame[,which(colnames(dataFrame)==respVar)] ~ respVar.cv.fitted,
     ylim=c(0,max(observedRV)), 
     xlim=c(0,max(observedRV)),main="Cross Validation Results" ,
     xlab="Predicted by leave-one-out cross validation", ylab="Total BA observed (Kg/ha)")
## Add a 1:1 line for reference
abline(0,1,col="darkred",lwd=2)

## Optional - Add the R-Squared value to the plot
text(max(observedRV)-30, 20, substitute(paste(italic(R-Squared), " = ", x, sep=""), list(x=cv_rsq)))
## Optional - Add the rmse value to the plot
text(max(observedRV)-30, 10, substitute(paste(italic(RMSE), " = ", x, sep=""), list(x=rmseCV)))
