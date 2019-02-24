---
  title: "Ultimatium Game Experiment"
author: "Ryan McWay"
output:
  word_document: default
---
  ###**ECON663-Experimental Economics**
  library(readxl)
sample <- read_excel("Ryan/Documents/USF/2019-Spring/Econ663-Experimental/Experiment_Journals/DictatorUltimatumData.xlsx")
print(sample)
t.test(sample$ULT_SEND, mu=0)

plot(sample$Subject, sample$ULT_SEND,
     type= "h",
     ylab= "$$ Sent",
     xlab= "Player",
     col= "blue",
     main="Money Sent Per Subject in Ultimatum Game")
library(MASS)
library(calibrate)
textxy(sample$Subject, sample$ULT_SEND, sample$DECISION, m= c(0,0), cex= .8, offset=1)
abline(h=mean(sample$ULT_SEND), lty=2, col="red")
text(2.2,2.2,label="Mean = 2")       
legend(1,4,legend=c("Amonut Sent with Response"), col=c("blue"), lty= c(1), title="Legend", text.font = 9)
