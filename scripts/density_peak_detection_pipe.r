library(IDPmisc)
# setwd("~/Schreibtisch/data_processing/test_Lirens_visit/R_peak_analysis/")
# 
# test.data <-read.delim("Batch1_Fun-BGS-12.length")
# test.data <-read.delim("Batch1_Fun-Brit-4.length")
# test.data <-read.delim("Batch1_shm-BGS-12.length")
# test.data <-read.delim("Batch3_B2-G.length")
#test.data <-read.delim("/vol/spool/HiPoAF/longUMI/LengthInvestigation/Batch3_B2-G.length")
input_file <- commandArgs(TRUE)[1]
output_file <- commandArgs(TRUE)[2]
test.data <-read.delim(input_file)
colnames(test.data) <- c("len", "freq")
test.data <- test.data[which(test.data$freq != 0),]
#pdf(file=output_file)
#plot(test.data, type="b", xlab="length", ylab="frequency")
den<-density(test.data$len)
#plot(den)
pts<-peaks(den)
pts  #output with the x,y,w; w is the one-sided peak width (0.5 preak width); x is the peak maximum position; y is not important
#plot(pts)

#points(x=pts[1,1], y=pts[1,2], col ="steelblue3", pch = 16)
#points(x=pts[2,1], y=pts[2,2], col ="steelblue3", pch = 16)
#points(x=pts[3,1], y=pts[3,2])
