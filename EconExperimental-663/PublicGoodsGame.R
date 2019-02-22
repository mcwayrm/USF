---
  title: "Public Goods Experiment"
author: "Ryan McWay"
output:
  word_document: default
---
  ###**ECON663-Experimental Economics**
library("readxl")
sample <- read_excel("raw", sheet = "Data")
print(sample)
t.test(sample$MinGrowth, mu=1)

plot(sample$Game, sample$MinGrowth,
     type= "b",
     ylab= "Minimum Growth",
     xlab= "Game",
     col= "blue",
     main="Minimum Growth for each Round by Game")
abline(h=1,lty=2, col="red")
abline(h=7,lty=2, col="green")
legend(1,5,legend=c("Max Growth: 7","Minimum Growth: 1","Minimum Choosen Growth"), col=c("dark green","red","blue"), lty= c(2,2,1), title="Legend", text.font = 4)
