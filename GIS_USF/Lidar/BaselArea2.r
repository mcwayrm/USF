setwd ("local")
lidarData = read.csv("BA_lidarData.csv")
# Subset data to remove "Plot" variable- first column
lidarData = lidarData[,-1]
install.packages('leaps')
library(leaps)
?regsubsets
BAregsubsets = regsubsets(BAtotal~.,data = lidarData, nbest = 4, nvmax = 3, method = 'seqrep')
summary(BAregsubsets)
plot(BAregsubsets, scale = "r2")
Lm0 = lm(BAtotal~P70+all_1st_cover_mean, data = lidarData)
Lm1 = lm(BAtotal~P70*all_1st_cover_mean, data = lidarData)
summary(Lm0)
summary(Lm1)
Lm2 = lm(BAtotal~P70:all_1st_cover_mean, data = lidarData)
summary(Lm2)
Lm3 = lm(BAtotal~P50+all_cover_mean, data = lidarData)
summary(Lm3)
plot(Lm1)
install.packages("MASS")
library(MASS)
?boxcox
boxcox(Lm1)
bcLm1 = boxcox(Lm1)
lambda <- bcLm1$x[which.max(bcLm1$y)]
# But no need to transform after all
BAtransformed = lidarData$BAtotal^lambda
names(lidarData)
Lm4 = lm(BAtotal~P40*X1st_cover_mean*all_1st_cover_mean, data = lidarData)
summary(Lm4)
plot(Lm4)
?anova
anova(Lm0,Lm1)
Lm1_BAtotal_pred = Lm1$fitted
plot(Lm1_BAtotal_pred, lidarData$BAtotal, ylab = "BAtotal observed", xlab = "BAtotal predicted")
?abline
abline(0,1,col="purple")
