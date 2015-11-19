#
# plots.R - Arnie Larson
#
# for Coursera Machine Learning class
# https://class.coursera.org/predmachlearn-034
# 

#
# exploratory analysis functions
# (Assumes global existance of pml data)
#
plot_scatter <- function(png_name, var_name, width=1000, height=800) {
    # plots a 5 x n array of the varnames:
    png(paste0("plots/",png_name), width=width, height=height)
    par(mfrow=c(length(var_name),5))
    for ( i in var_name) {
        plot(pmla$raw_timestamp_part_2, pmla[,i], main=paste0("A: ",i))
        plot(pmlb$raw_timestamp_part_2, pmlb[,i], main=paste0("B: ",i))
        plot(pmlc$raw_timestamp_part_2, pmlc[,i], main=paste0("C: ",i))
        plot(pmld$raw_timestamp_part_2, pmld[,i], main=paste0("D: ",i))
        plot(pmle$raw_timestamp_part_2, pmle[,i], main=paste0("E: ",i))
    }
    dev.off()
}

# do a featurePlot on some columns (uses ggplot)
plot_pair <- function(data, png_name, var_names, width=800, height=600) {
    if (length(var_names)>8) {
        print("more than 8 variables..  exiting")
        return (NULL) 
    }
    print(paste("plotting vars:",var_names))
    fname<-paste("plots/",png_name,"_pairs.png",sep="")
    png(fname, width=width, height=height)
    p<-featurePlot(x=data[,var_names],y=data$classe, 
            plot="pairs", auto.key=list(columns = 5)) 
    print(p)
    dev.off()
    print(paste("created plot: ",fname))
}

plot_density <- function(data, png_name, var_names, width=800, height=600)  {

    print(paste("plotting vars:",var_names))
    fname<-paste("plots/",png_name,"_density.png",sep="")
    png(fname, width=width, height=height)
    p<-featurePlot(x=data[,var_names],
            y=data$classe, 
            plot="density", 
            scales=list(x=list(relation="free"),
                        y=list(relation="free")),
            adjust=1.5, pch="|",
            layout = c(length(var_names),1),
            auto.key=list(columns = 5)) 
    print(p)
    dev.off()
    print(paste("created plot: ",fname))

}


