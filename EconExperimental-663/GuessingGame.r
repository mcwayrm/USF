###**Guessing Game**
#ECON663-Experimental Economics
#*By Ryan McWay*

sample <- c(33.33,15,5,10,42,18.7,17,3,15,43,9)
t.test(sample,mu=0)

hist(sample, 
     breaks=5, 
     freq= TRUE, 
     col="blue", 
     main = "Frequency of Guesses", 
     xlab= "Sample Guesses",
     labels = TRUE)
par(new=F)
d <- density(sample)
plot(d,
     type= "l",
     main = "Density of Guesses", 
     xlab= "Sample Guesses")
library(rmarkdown)
render("GuessingGame.Rmd", output_format= "word_document")
