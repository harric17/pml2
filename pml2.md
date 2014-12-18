




Practical Machine Learning Class Project 2014
========================================================

## Introduction

A significant challenge to today's data scientists is extracting meaningful insights from the large volumes of data that are continuously being collected from a variety of sources.   The goal of this analysis was to develop an accurate algorithm for predicting the manner of exercise being performed by 6 participants based on measurements collected from inexpensive personal activity sensors.

---
## Methods

The training dataset contained 19622 observations across 160 variables.  The testing set contained 20 observations without information related to the outcome measure.  The outcome variable of interest, classe, is a categorical variable consisting of 5 different levels.   A random forest model was fit to predict this categorical outcome.

There was substantial data management required for this analysis.  First, five variables were excluded as obvious noise: X, problem_id, raw_timestamp_part_1, raw_timestamp_part_2, and cvtd_timestamp.  Next, variables that had exclusively missing values in the test set were also excluded.  This resulted in a dataset with 55 predictor variables, two of which were factors with the remaining numeric. 

The training dataset was then ultimately subset to improve analysis speed.  Using a random uniform number generator a small subset of exactly 3000 observations was created and used to train the random forest model.  The remaining data was set aside for further validation of the model.  Ultimately the smaller training subset contained levels of the factor variables that were not in the test data set, so the two factor variables were also excluded from the analysis.  A forest of 500 trees was created, and the number of variables randomly chosen at each split was left as the default value of 7.

---
## Results
The out of bag error rate for the resulting random forest model was 2.63%, or 97.37% accuracy.  Class errors for the out of bag data are displayed below in Table 1.

Table 1: Confusion matrix from OOB data

```
##     A   B   C   D   E class.error
## A 851   1   1   0   1    0.003513
## B  18 535   9   0   1    0.049734
## C   0  12 514   2   0    0.026515
## D   1   0  22 469   2    0.050607
## E   0   1   2   6 552    0.016043
```
The random forest model performed similarly well on the validation dataset, predicting the outcome with 97.38% accuracy.  The top 10 variables in terms of importance for this forest are presented in Table 2 on the next slide.  On the test data set, 19 of 20 observations were correctly predicted.

---
## Results

Table 2: Top 10 variables by importance

```
##                   importance
## roll_belt             161.67
## num_window            152.65
## pitch_forearm         114.70
## yaw_belt              106.52
## magnet_dumbbell_y     103.02
## magnet_dumbbell_z     101.39
## pitch_belt             93.01
## roll_forearm           73.85
## accel_dumbbell_y       71.35
## magnet_dumbbell_x      68.88
```

---
## Conclusions

Many potential predictors were excluded from this analysis and additionally the final model was trained on only about 15% of the available data.  Nonetheless a highly accurate model was constructed using random forests.  The out of sample error from both the out-of-bag data and validation set are both less than 3%.

Going forward several more investigative analyses could be performed.  For example this data could be further explored using a complete case analysis, which would yeild information about the predictive importance of the variables that were excluded in this analysis due to a large number of missing values.  Another additional future analysis might be creating a random forest using only the most important variables to see if model accuracy was similarly high.  If so this would minimize the amount of data needed to be collected.  A third future analysis might investigate building models that are better at distinguish certain levels of the outcome that are of particula interest.  For the current model had the most trouble distinguising class D from class C (see Table 1), so if you are particularly interested in distinguishing between those outcomes tuning parameters could be tweaked to more finely tune your model.


