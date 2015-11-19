#
# process.R - Arnie Larson
#
# for Coursera Machine Learning class
# https://class.coursera.org/predmachlearn-034
# 
library(caret)

# Load databases if objects not found
load_data <- function(test=FALSE) {
    root<-"~/Documents/Coursera/jhsph/ml/motion-project/data"
    training_filename <- paste0(root,"/pml-training.csv")
    testing_filename <- paste0(root,"/pml-testing.csv")
    if ( file.exists(training_filename) ) {
        assign("pml",read.csv(training_filename), envir=.GlobalEnv)
    } else {
        print(paste('not loading pml data - file', training_filename, 'not found'))
    }

    if ( test & file.exists(testing_filename) ) {
        assign("pmltest",read.csv(testing_filename ), envir=.GlobalEnv)
    }
}

# processing of training data
# data is in timeseries windows.  Summary statisitcs (have NA's except whne new_window=T)
# assigns global variables to:
process <- function(data, name="pml") {
    # remove summary statistics
    data <- data[,!apply(data, 2, function(x) any(is.na(x)))]

    # remove sparse/broken summary statistics: (max, kurtosis, skewness yaw 
    # Note - one field ..  has yaw
    n<-names(data)
    data <- data[,!(grepl("kurtosis",n) | 
        grepl("skewness",n) | 
        grepl("_yaw",n))]

    data <- data[,-(1:7)]
    assign(paste0(name,"data"),data, envir=.GlobalEnv)
}

# split the training set
bifurcate <- function(data, name="pml", p=0.8) {
    
    set.seed(100)
    i<-createDataPartition(data$classe,p=p, list=FALSE)
    assign(paste0(name,"training"),data[i,], envir=.GlobalEnv)
    assign(paste0(name,"testing"),data[-i,], envir=.GlobalEnv)
}





# partition data into classes {A-E}
#pmla <- pml[pml$classe=="A",]
#pmlb <- pml[pml$classe=="B",]
#pmlc <- pml[pml$classe=="C",]
#pmld <- pml[pml$classe=="D",]
#pmle <- pml[pml$classe=="E",]




