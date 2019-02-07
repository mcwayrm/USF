---
  title: "Bubbles and Crashes Experiment"
author: "Ryan McWay"
output:
  word_document: default
---
  ###**ECON663-Experimental Economics**
library("readxl")
sample3 <- read_excel("C:/Users/Ryry/Documents/Ryan/Documents/USF/2019-Spring/Econ663-Experimental/Experiment_Journals/BubbleCrushes.xlsx", sheet = "Data")
print(sample3)
t.test(sample3$Price, mu=6) # Can be rejected
t.test(sample3$HighBid, mu=6) # These two are just for kicks
t.test(sample3$LowAsk, mu=6)

plot(sample3$Period, sample3$LowAsk,
     type= "p",
     main= "Auction Price by Period",
     xlab= "Period",
     pch= 9,
     col= "Red",
     ylab= "Price ($)",
     xlim=c(0,9), ylim=c(0,16))
points(sample3$HighBid, pch= 2, col= "dark green")
abline(lm(sample3$Period~sample3$Price), col="blue")
abline(h=6,col="black", lty=2, lwd=1)
text(1,6.5,"Rational Price: $6.00")
legend(0,5,legend=c("Highest Bid","Lowest Ask","Smoothed Price"), col=c("dark green","red","blue"), lty= 1, title="Legend", text.font = 4)
