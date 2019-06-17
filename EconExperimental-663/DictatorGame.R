---
  title: "Dictator Game Experiment"
author: "Ryan McWay"
output:
  word_document: default
---
  ###**ECON663-Experimental Economics**
library(readxl)
sample <- read_excel("<DictatorUltimatumData.xlsx>")
print(sample)
t.test(sample$DIC_SEND, mu=0)
sort(sample$DIC_SEND)
plot(sample$Subject, sample$DIC_SEND,
     type= "h",
     ylab= "$$ Sent",
     xlab= "Player",
     col= "blue",
     main="Money Sent Per Subject in Dictator Game")
mean_dic  <- mean(sample$DIC_SEND)
abline(h=mean_dic,lty=2, col="red")
text(2.5,1.6,label="Mean = 1.44")
legend(1,4,legend=c("Amonut Sent"), col=c("blue"), lty= c(1), title="Legend", text.font = 9)
