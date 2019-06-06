# This is the Script for 06_Lab Exercise 1
# By Ryan McWay
# Setting the directory
setwd("~/LiDAR-McWay/06_Class/LidarDataAnalysis")
# Importing the database
lidarData <- read.csv("~/LiDAR-McWay/06_Class/LidarDataAnalysis/BA_lidarData.csv")
# View the database
View(lidarData)
# Name the variables from the database
names(lidarData)
# Create the response variable as total Basel Area
ResponseV <- lidarData$BAtotal
# Mean for the response variable
mean(ResponseV)
# Plot Hieght Mean against the response variable
plot(lidarData$HMean, ResponseV, xlab = "Mean Height", ylab = "Response Variable")
# Learn more about plot
?plot
# correlation between mean hieght to basal area
cor(lidarData$HMean, lidarData$BAtotal)
# plot 10th percentile to the response variable
plot(lidarData$P10, ResponseV)
# correlation between 10th percentile to basal area
cor(lidarData$P10, lidarData$BAtotal)
# plot 95th percentile to response variable
plot(lidarData$P95, ResponseV)
# correlation between 95th percentile to basal area
cor(lidarData$P95, lidarData$BAtotal)
# plot 1st cover mean to response variable
plot(lidarData$all_1st_cover_mean, ResponseV)
# correlation between 1st cover mean to basal area
cor(lidarData$all_1st_cover_mean, lidarData$BAtotal)
# plot 1st cover 3 to response variable
plot(lidarData$all_1st_cover_3, ResponseV)
# correlation between 1st cover 3 to basal area
cor(lidarData$all_1st_cover_3, lidarData$BAtotal)
# creates correlation matrix for database expect the first column "Plots", because "That's Silly."
corrMat <- cor(lidarData[,-1])
# Print out the correlation matrix so it can be read
print(corrMat)
# range for Hieght max
range(lidarData$HMax)
# 5 statistic summary for every variable in the database
summary(lidarData)
# create histogram of basal area (frequency graph)
hist(lidarData$BAtotal)
# Learn more about histograms
?hist
# variance for basal area
var(lidarData$BAtotal)
# standard deviation for basal area
sd(lidarData$BAtotal)

