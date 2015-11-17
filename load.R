#
# load.R - Arnie Larson
#
# for Coursera Machine Learning class
# https://class.coursera.org/predmachlearn-034
#
# Basic loading of the data
# 

# Load databases if objects not found
load <- function(test=FALSE) {
    root<-"~/Documents/Coursera/jhsph/ml/motion-project/data"
    training_filename <- paste0(root,"/pml-training.csv")
    testing_filename <- paste0(root,"/pml-testing.csv")

    if ( file.exists(training_filename) ) {
        assign("pml",read.csv(training_filename ), envir=.GlobalEnv)
    } else {
        print(paste('not loading pml data - file', training_filename, 'not found'))
    }

    if ( test & file.exists(testing_filename) ) {
        assign("pmltest",read.csv(testing_filename ), envir=.GlobalEnv)
    }
}





