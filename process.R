#
# process.R - Arnie Larson
#
# for Coursera Machine Learning class
# https://class.coursera.org/predmachlearn-034
# 

# processing of training data
# data is in timeseries windows.  Summary statisitcs (have NA's except whne new_window=T)

# remove summary statistics
process <- function(data) {
    data <- data[,!apply(data, 2, function(x) any(is.na(x)))]

    # remove all fields that are super sparse:  (max, kurtosis, skewness yaw 
    # Note - one field ..  has yaw
    # These are again summary statistics
    n<-names(data)
    data <- data[,!(grepl("kurtosis",n) | 
        grepl("skewness",n) | 
        grepl("_yaw",n))]
    return(data)
}



# partition data into classes {A-E}
#pmla <- pml[pml$classe=="A",]
#pmlb <- pml[pml$classe=="B",]
#pmlc <- pml[pml$classe=="C",]
#pmld <- pml[pml$classe=="D",]
#pmle <- pml[pml$classe=="E",]




