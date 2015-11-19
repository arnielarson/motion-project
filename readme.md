# 
# Author - Arnie Larson
#
# Project as part of coursera Machine Learning class:
# https://class.coursera.org/predmachlearn-034
# Taught By: Jeff Leek
#

Project is to create a predictive model for classified motion data:
Human Activity Recognition - HAR
http://groupware.les.inf.puc-rio.br/har

Datasets:
- Training Data   - 19622 rows, 160 columns:
- Testing Data    - 20 rows, 160 columns

# Column Data:
- X - oridinal - just the row number
- user_name { 6 people }
- new_window - yes/no - (yes is the *last* row for a given time window)
- num_window - ordinal, tracks the window
- raw_timestamp_part_1    - probably unix time
- raw_timestamp_part_2    - window time, presumed starting from 0 within a window
 cvtd_timestamp          - human readable time
- lots of data columns
- classe { A -E }


Really cool data set - our objective is to classify instants in time.  
The underlying structure of the time series is in the raw data
(I think, since the windows are "motions" done, perhaps, "constantly", 
 not a lot of variation vs. timestamp_2

Lots of motion data - a bunch has NAs that Im gonna want to remove, as its NA in the testing set
data w/ NAs is summary data - shows summary statistics when new_window is "yes"

Basic Modeling Procedure:
source('load.R'); 
source('process.R');
load()              # Loads data, creates pml global var
process(pml)        # Cuts the data, creates pmldata var
bifurcate(pmldata, p=0.2)  # partitions training and testing sets
# setup for modelng:
#pp<-preProcess(pmltraining)    # default behaivor is to apply centering and scaling
pp<-preProcess(pmldata)         # should really do this on the entire dataset.. imo 
# can also add in pca decomposition
pp2<-preProcess(pmldata, method=c("center","scale","pca"),thresh=.90)
pmltraint<-predict(pp,pmltraining)  # actually applies the transformation

ctrl=trainControl(method, number, repeats, ..)
# e.g. trainControl(method="cv",number=5)
mx <- train(classe ~ ., data=pmltraint, method="x",trControl=ctrl)

ppt<-preProcess(pmltesting)     # default behaivor is to apply centering and scaling
pmltestingt<-predict(ppt,pmltesting)  # actually applies the transformation
confusionMatrix(pmltestingt$classe, predict(mx, pmltesting[-53]))


