#Assignment #1
#Ryan McWay

kyoto <- read.csv("http://www.stat.cmu.edu/~cshalizi/dst/18/data/kyoto.csv")

#Problem 1
fivenum(kyoto$Flowering.DOY)
summary(kyoto)
library(Hmisc)
describe(kyoto)
  # summary is the anwser.

#Problem 2
#(a)
plot(Flowering.DOY ~ Year.AD, data= kyoto, type="l",
     ylab="Day in year of full flowering",
     xlab="Year(AD)",
     main="Cherry blossoms in Kyoto")
#(b)
abline(h= mean(kyoto$Flowering.DOY, na.rm=TRUE), 
       col="gold", lty=1, lwd = 3)
#(c)
abline(h=quantile(kyoto$Flowering.DOY, c(0.25,0.75), na.rm = TRUE),
       col = "red", lty= 3, lwd = 2)

#Problem 3
#(a)
lm(kyoto$Flowering.DOY~kyoto$Year.AD)
abline(lm(Flowering.DOY~Year.AD, data=kyoto),
       col= "blue", lty=2, lwd=2)
#(b)
plot(Flowering.DOY ~ Year.AD, data= subset(kyoto,Year.AD <= 1750), type="l",
     ylab="Day in year of full flowering",
     xlab="Year(AD)",
     main="Cherry blossoms in Kyoto")
lm(Flowering.DOY~Year.AD, data=subset(kyoto, Year.AD <=1750))
abline(lm(Flowering.DOY~Year.AD, data=subset(kyoto, Year.AD <=1750)),
       col= "purple", lty=2, lwd=2)
#(c)
plot(Flowering.DOY ~ Year.AD, data= subset(kyoto,Year.AD > 1750), type="l",
     ylab="Day in year of full flowering",
     xlab="Year(AD)",
     main="Cherry blossoms in Kyoto")
lm(Flowering.DOY~Year.AD, data=subset(kyoto, Year.AD >1750))
abline(lm(Flowering.DOY~Year.AD, data=subset(kyoto, Year.AD >1750)),
       col= "green", lty=2, lwd=2)
#(d)
plot(Flowering.DOY ~ Year.AD, data= kyoto, type="l",
     ylab="Day in year of full flowering",
     xlab="Year(AD)",
     main="Cherry blossoms in Kyoto")
abline(h= mean(kyoto$Flowering.DOY, na.rm=TRUE), 
       col="gold", lty=1, lwd = 3)
abline(h=quantile(kyoto$Flowering.DOY, c(0.25,0.75), na.rm = TRUE),
       col = "red", lty= 3, lwd = 2)
abline(lm(Flowering.DOY~Year.AD, data=kyoto),
       col= "blue", lty=2, lwd=2)
abline(lm(Flowering.DOY~Year.AD, data=subset(kyoto, Year.AD <=1750)),
       col= "purple", lty=2, lwd=2)
abline(lm(Flowering.DOY~Year.AD, data=subset(kyoto, Year.AD >1750)),
       col= "green", lty=2, lwd=2)
legend(760,125,c("Mean","1st/3rd Quartile","Reg","Reg<1750 AD","Reg>1750 AD"), lty=c(1,3,2,2,2), lwd=c(3,2,2,2,2), col=c("gold","red","blue","purple","green"))

#Problem #4
#(a)
library(zoo)
ma <- rollmean(kyoto$Flowering.DOY, 5,
               fill = NA,
               align= "right",
               na.rm=TRUE)
mean(ma)
#(c)
ma2 <- rollmean(kyoto$Flowering.DOY, 11,
               fill = NA,
               align= "right",
               na.rm=TRUE)
mean(ma)

#(d)
plot(Flowering.DOY ~ Year.AD, data= kyoto, type="l",
     ylab="Day in year of full flowering",
     xlab="Year(AD)",
     main="Cherry blossoms in Kyoto")
abline(h= mean(kyoto$Flowering.DOY, na.rm=TRUE), 
       col="gold", lty=1, lwd = 3)
abline(h=quantile(kyoto$Flowering.DOY, c(0.25,0.75), na.rm = TRUE),
       col = "red", lty= 3, lwd = 2)
abline(h= rollmean(kyoto$Flowering.DOY, 5,
                   fill = NA,
                   align= "right",
                   na.rm= TRUE),
          col = "purple", lty = 2, lwd = 2)
abline(h= rollmean(kyoto$Flowering.DOY, 11,
                   fill = NA,
                   align= "right",
                   na.rm= TRUE),
          col = "green", lty = 2, lwd = 2)
legend(760,125,c("Mean","1st/3rd Quartile","MA-5 Years","MA-11 Years"), lty=c(1,3,2,2), lwd=c(3,2,2,2), col=c("gold","red","purple","green"))


