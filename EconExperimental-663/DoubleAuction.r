---
  title: "Double Auction Experiment"
author: "Ryan McWay"
output:
  word_document: default
---
  ###**ECON663-Experimental Economics**
setwd("")
library("readxl")
sample <- read_excel("<raw>", sheet = "Data")
View(sample2)

#Supply and Demand
demand <- c(25:1)
supply1 <- sort(c(1:25,5,10,15,20,25))
supply2 <- sort(c(7:31,11,16,21,26,31))

#Regular Equilibrium
plot(supply1, type = "l",
     lwd = 2,
     main = "Anticipated Equilibrium for Periods 1 and 2",
     xlab = "Quantity",
     ylab = "Price")
par(new=T)
plot(demand, type = "l",
    lwd = 2,
    axes = F,
    ann = F)
mtext("(12,15)", at = 12)

#Equilibrium with Tax
plot(supply2, type = "l",
     lwd = 2,
     main = "Antcipated Equilibrium for Period 3 with Tax",
     xlab = "Quantity",
     ylab = "Price")
par(new=T)
plot(demand, type = "l",
     lwd = 2,
     axes = F,
     ann = F)
mtext("(15.5,10.5)", at = 12.5)

#T-Test for each period in order
t.test(sample$PriceP1, mu=12)
t.test(sample$PriceP2, mu=12)
t.test(sample$PriceP3, mu=15.5)

#Market Price over Period
plot(Transactions~Price1, Data = sample, 
     type = "l",
     lty = 2,
     col = "Dark Green",
     main = "Price and Quantity for Period 1 and 2", 
     ylab = "Bid/Ask Equilibrium Price (P)",
     xlab = "Transactions (Q)")
par(new=T)
plot(sort(sample$PriceP2),
     type = "l",
     lty = 2,
     col = "Red"
     )
par(new=T)
plot(sort(sample$PriceP3), 
     type = "l",
     col = "Maroon",
     lty = 2,
     axes = F,
     ann = F
     )
mtext("Period1 = $9.75 | Period2 = $10.46 | Period3 = $13.25")
