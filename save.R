#
# save - Arnie Larson
#
# for Coursera Machine Learning class
# https://class.coursera.org/predmachlearn-034
#
# Helper function to save a file for the outcomes
# from each of the 20 evaluation tests
# 

# save a file for each answer in answers
save_solutions <- function(answers) {
    for (i in 1:length(answers)) {
        filename<-paste("answers/problem-",i,sep="")
        print(paste('saving file -',filename))
        write.table(answers[i],file=filename,
                quote=F, row.names=F, col.names=F)
    }
}
