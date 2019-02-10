---
  title: "Public Goods Experiment"
author: "Ryan McWay"
output:
  word_document: default
---
  ###**ECON663-Experimental Economics**
library("readxl")
sample4 <- read_excel("C:/Users/Ryry/Documents/Ryan/Documents/USF/2019-Spring/Econ663-Experimental/Experiment_Journals/PublicGoodGame.xlsx", sheet = "Data")
print(sample4)
t.test(sample4$MinGrowth, mu=1)

plot(sample4$Game, sample4$MinGrowth,
     type= "b",
     ylab= "Minimum Growth",
     xlab= "Game",
     col= "blue",
     main="Minimum Growth for each Round by Game")
abline(h=1,lty=2, col="red")
abline(h=7,lty=2, col="green")
legend(1,5,legend=c("Max Growth: 7","Minimum Growth: 1","Minimum Choosen Growth"), col=c("dark green","red","blue"), lty= c(2,2,1), title="Legend", text.font = 4)
