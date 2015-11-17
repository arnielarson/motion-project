#
# model.R - Arnie Larson
#
# for Coursera Machine Learning class
# https://class.coursera.org/predmachlearn-034
#
# Contains modeling functions
# 

# functionality to load and process training data
source('load.R')
source('process.R')

# returns a model from the data
run <- function(data, load=FALSE, process=FALSE) {

    # load creates the gloabal pml dataset
    if (load) {
        load()
    }

    # process data
    if (process) {
        data <- process(data)
    }
    # not yet implemented - partitioning    
    # partion data?

    # train model
}




