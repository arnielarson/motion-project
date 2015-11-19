
Motion Project 
==============

#### Author - Arnie Larson

Project is part of a [Coursera](www.coursera.org) [Machine Learning](https://class.coursera.org/predmachlearn-034) class

Taught By: Jeff Leek, Johns Hopkins University

#### Project Overview

The goal of this project was to create a predictive model for classification of human motion data.  The data set comes from a Human Activity Recognition [dataset](http://groupware.les.inf.puc-rio.br/har).  The data used is from sensor captures of subjects doing a simple dumbell curl weightlifting exercise.  Each capture is classified into 5 different ways one can *incorrectly* perform the exericse.  For each capture sensors are used to record measurements of the dumbell/arm/waist etc.  The authors used the time series nature of the data in their analysis to classify the motions.  Our evaluation data is for *instants* in time.  Since we do not have the entire timeseries in our evaluation data, the aim is to create a predictive model to classify the data from a single *instant*.


#### What's in the Data?  
The data for the project includes a larger training set and a smaller evaluation data set.

- Training Data: 19622 rows, 160 columns, with 5 classifications
- Evaluation Data: 20 rows, 160 columns, not classified
  
#### Dataset Columns
- X, ordinal data, just the row number
- a user_name { 6 different people }
- new_window: yes/no - (yes is the **last** row for a given time window)
- num_window: ordinal, tracking the windows, also groups dataset
- raw_timestamp_part_1: unix time
- raw_timestamp_part_2: window time, presumed starting from 0 within a window
- cvtd_timestamp: a human readable time
- lots of data columns (accelerations, etc of arm/waist/dumbell etc..)
- data columns also include (sparse) summary statistics (min/max,mean,stdev)
- summary statistic data colums also contain !div/0
- classe { A -E } - the classification of each motion

#### Project Strategy
The objective is to classify instants in time.  The underlying structure of the time series is in the raw data and will be removed.  I didn't notice a lot of variation of the data vs. the window time, and so I removed the window time variable.  I removed the columns that contain NA's, e.g. all the summary statistics.  I tested several different modeling procedures with the [caret](http://topepo.github.io/caret/index.html) package.  I separated my code out into functions in a few different files to ease reproduction.  I did some explorartory analysis, plotting: data vs. window time, pair plots of data, and desnity plots.  I didn't really discern obvious patterns and correlations.  The data seemed pretty noisy.  So I used all the data columns in my initial modeling.  As I began training models, I also saved models so that I could avoid retraining them later.  


#### Basic Modeling Procedure:

To prepare the data, I removed columns that I didn't want to train on and bifurcated the training data into a training and test set.
I initially trained many models on only about 20% of the data.  
```
source('process.R');
load_data()              # Loads data, creates pml global var
process(pml)        # Cuts the data, creates pmldata var
bifurcate(pmldata, p=0.2)  # partitions training and testing sets
````

Setting up data for modelng, preprocessing.  The default caret preprocess behavior is centering and scaling.  I also tried using PCA compression.  I ultimately set up my preprocessing on the entired data set, in order to get the best scaling and centering parameters.
```
pp<-preProcess(pmltraining)    # default behaivor is to apply centering and scaling
pp<-preProcess(pmldata)         # should really do this on the entire dataset.. imo 
# also try using pca decomposition
pp2<-preProcess(pmldata, method=c("center","scale","pca"),thresh=.90)
pmltraint<-predict(pp,pmltraining)  # actually applies the transformation
```

The basic model training routing is as follows.  Using the method of "cv" allows caret to do a 5 fold cross validation on the input data to estimate the out of sample error.
```
ctrl=trainControl(method, number, repeats, ..)
# e.g. trainControl(method="cv",number=5)
mx <- train(classe ~ ., data=pmltraint, method="x",trControl=ctrl)
```
Once a model has been trained, it can be tested on the remaining data.  The confusion matrix command is useful to get out of sample accuracy and Type I and II errors from a basic truth table.  In order to apply the model to the remaining testing data, it also needs to be processed identically to the training data.

```
ppt<-preProcess(pmltesting)     # default behaivor is to apply centering and scaling
pmltestingt<-predict(ppt,pmltesting)  # actually applies the transformation
confusionMatrix(pmltestingt$classe, predict(mx, pmltesting[-53]))
```

#### Results

For my initial round of model training I used 20% of the training data on all 5 classes.  I was only able to get Random Forest and Support Vector Machine models to work as expected and have reasonable accuracy.  I found that a Support Vector Machine model w/ a Polynomial kernel with degree 3 had an accuracy on the testing data of ~ 93.4%.  I found that Random Forest models had an accuracy of ~ 82%.  

Next I trained models with 40% of the input data.  I found that Random Forest models had ~ 98.9% accuracy and an SVM with polynomial kernel of degree 3 had 98.3% accuracy.  The SVM polynomial model also took about 42 minutes to train, in part, I believe, because it was trying out a variety of parameters and kernel degrees.  I also trained a Random Forest model on the entire data set - this took about 38 minutes and estimated a training accuracy of 99.8%.  

Estimates of out of sample error is important in any predictive analysis, and for this sale a simple k-fold cross validation is excellent.  In caret this step can easily be incorporated in the model training process.  I used a 5 fold cross validation during training.

##### Out of sample error rates:
- Random Forest trained on 40% of data:   1.3%
- Random Forest trained on 100% of data:  0.4%

The "good" models were applied to the 20 test cases in the evaluation set.  The "good" models (those with accuracy of at least 98%) were in agreement on the classification.

The classifications I found on the evaluation set:
- B A B A A E D B A A B C B A E E A B B B

I ultimately was able to get decent accuracy wihout using the window time or the person as a dummy variable.  And ultimately was able to create models with an accuracy of around 99%.