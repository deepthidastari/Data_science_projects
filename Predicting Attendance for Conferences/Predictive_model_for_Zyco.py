
# To provide a solution to the business problem that Zyco Co. has, let us use the Cross Industry Process for Data Mining(CRISP - DM) methodology that breaks down the process of data mining into six major phases : 
# 1) Business Understanding
# 2) Data Understanding
# 3) Data Preparation
# 4) Modeling
# 5) Evalution
# 6) Deployment

## Business Understanding

# Business Problem:
# 
# Your company, Zyco Co., organizes free conferences in various locations in India. Recently, the company has found that a lot of candidates are not turning up to the conferences after enrolling themselves. Based on the data collected from the candidates during the registeration process, the company Zyco Co. wants you to identify candidates who are at a risk of not attending the conference 

# Task 1
# a. Create a model predicting if a candidate will attend the conference. This will be indicated by the "Observed Attendance" column in the data set. Create the model only using the records where this column is not null
# b. Provide a probability and a prediction for the candidates where the "Observed Attendance" column is null.
# 
# From the above problem statement, we understand that "Observed Attendance" is the target variable/dependent variable.

## Data Understanding

# In order to get a sense of the data set at hand, we will start with plotting distributions of the independent variables and calculate some basic statistics

#Importing the libraries

import numpy as np
import pandas as pd

#Importing the dataset

dataset = pd.read_csv('Conference_Attendance_Data.csv')

#Inspecting the dataset

rows, columns = dataset.shape

print (rows, columns)

#View few rows of the dataset. 

dataset.head()

#Using describe() to calculate basic statistics for the dataset

dataset.describe()

#The describe function shows that there are some unnamed columns in the dataset. Lets get rid of those

dataset.describe()


## Data Preparation

# The dataset has a total of 22 columns. In order to reduce the number of features that will be given as inputs to the model, lets use some basic intuition about the columns of the data:
# 
# 1)From the 'Column Description' document provided to us, we can already see that the columns 'Location' and 'Candidate Current Location' are the same. So we can eliminate one of them. 
# 
# 2)The 'Date of conference' column alone doesn't seem to have any bearing on whether the candidate will/will not attend the conference(unless there is more information about what else might be happening on that date), so we will not include the 'Date of conference' column in our feature set.

#Checking the distribution of different input variables from the dataset

dataset['Client name'].value_counts().plot(kind='barh')

#The 'Client Name' shouldn't necessarily influence a candidate's willingness to attend the conference,
#so we will not include this column in our feature set.

dataset['Industry'].value_counts().plot(kind='barh')

#The 'Industry' column doesn't play a significant role in predicting whether a candidate will
#attend the conference or not, specially when we are told that the candidate can attend any session offered by the conference.
#So we will not consider this variable in our analysis.

dataset['Location'].value_counts().plot(kind='barh')

dataset['Session offered by the conference'].value_counts().plot(kind='barh')

dataset['Nature of Skillset'].value_counts().plot(kind='barh')

dataset['conference Type'].value_counts().plot(kind='barh')


#From the distribution of the 'conference Type' column, we can see that there is possibility
#to group some buckets together. For example 'Schedule walkin' , 'Scheduled Walk In' and 'Scheduled Walkin'
#all mean the same and hence are just one group. Similarly 'Walkin' and 'Walkin ' can be grouped together.


dataset['conference Type'] = dataset['conference Type'].replace({'Sceduled walkin':'Scheduled Walkin', 'Scheduled Walk In':'Scheduled Walkin', 'Walkin ':'Walkin'})
dataset['conference Type'].value_counts().plot(kind='barh')

dataset['Candidate Current Location'].value_counts().plot(kind='barh')

dataset['Candidate Job Location'].value_counts().plot(kind='barh')

dataset['conference Venue'].value_counts().plot(kind='barh')


#Candidate's current location, job location and conference venue by themselves doesn't provide any relationship
#to whether a candidate will attend the conference or not. Having said that, we could derive a new variable such as
#"Is conference location same as Current Job location", that could be more valuable. For now, lets exclude all the
#location variable from the feature set.

dataset['Permission to attend from employer'].value_counts().plot(kind='barh')

#Intuitively, 'Not yet', 'Yet to confirm' also mean 'No'. Lets club these categories.

dataset['Permission to attend from employer'] = dataset['Permission to attend from employer'].replace({'Not yet':'No', 'NO':'No', 'Yet to confirm':'No', 'yes':'Yes', 'Na':'NA'})
dataset['Permission to attend from employer'].value_counts().plot(kind='barh')
dataset['No unscheduled meetings'].value_counts().plot(kind='barh')

#Combining similar values

dataset['No unscheduled meetings'] = dataset['No unscheduled meetings'].replace({'cant Say':'No', 'Not Sure':'No', 'Not sure':'No', 'yes':'Yes', 'Na':'NA'})
dataset['No unscheduled meetings'].value_counts().plot(kind='barh')

dataset['Confirmation before conference'].value_counts().plot(kind='barh')

dataset['Confirmation before conference'] = dataset['Confirmation before conference'].replace({'No Dont':'No', 'yes':'Yes', 'Na':'NA'})
dataset['Confirmation before conference'].value_counts().plot(kind='barh')
dataset['Have alternate number'].value_counts().plot(kind='barh')
dataset['Have alternate number'] = dataset['Have alternate number'].replace({'No I have only thi number':'No', 'yes':'Yes', 'na':'NA', 'Na':'NA'})
dataset['Have alternate number'].value_counts().plot(kind='barh')
dataset['Read Agenda'].value_counts().plot(kind='barh')
dataset['Read Agenda'] = dataset['Read Agenda'].replace({'Not yet':'No','Not Yet':'No','No- will take it soon':'No', 'yes':'Yes', 'na':'NA', 'Na':'NA'})
dataset['Read Agenda'].value_counts().plot(kind='barh')

dataset['Venue clear'].value_counts().plot(kind='barh')

dataset['Venue clear'] = dataset['Venue clear'].replace({'no':'No','No- I need to check':'No', 'yes':'Yes', 'na':'NA', 'Na':'NA'})
dataset['Venue clear'].value_counts().plot(kind='barh')
dataset['Agenda shared'].value_counts().plot(kind='barh')
dataset['Agenda shared'] = dataset['Agenda shared'].replace({'no':'No','Yet to Check':'No','Havent Checked':'No',
                                                         'Not sure':'No','Not yet':'No','Need To Check':'No',
                                                         'Not Sure':'No','yes':'Yes', 'na':'NA', 'Na':'NA'})
dataset['Agenda shared'].value_counts().plot(kind='barh')

dataset['Gender'].value_counts().plot(kind='barh')

dataset['Marital Status'].value_counts().plot(kind='barh')
dataset['Observed Attendance'].value_counts().plot(kind='barh')
dataset['Observed Attendance'] = dataset['Observed Attendance'].replace({'no':'No','no ':'No','NO':'No',
                                                         'No ':'No','yes':'Yes','yes ':'Yes'})
dataset['Observed Attendance'].value_counts().plot(kind='barh')

dataset.describe()

#Based on the observations about the data, lets drop columns that are not likely to influence the target variable.

reduced_dataset = dataset[['ID','Session offered by the conference', 'conference Type',
                           'Gender','Permission to attend from employer','No unscheduled meetings',
                           'Confirmation before conference','Have alternate number',
                           'Read Agenda','Venue clear','Agenda shared',
                           'Marital Status','Observed Attendance']].copy()

#Handling missing values in the dataset

reduced_dataset = reduced_dataset.fillna({"Permission to attend from employer": "NA","No unscheduled meetings":"NA",
                        "Confirmation before conference": "NA","Have alternate number": "NA",
                       "Read Agenda":"NA","Venue clear":"NA","Agenda shared":"NA",
                                                "Marital Status":"NA", "ID":"NA","Session offered by the conference" : "NA",
                                                "conference Type": "NA" , "Gender":"NA"
                                         })
print(reduced_dataset)


#Since we are asked to build the model on the only using the records where the 'Observed Attendance' column is not Null
#, let us split the data set so that we can build the model on the feature set and then use it to predict the values
#on the validation set

feature_set = reduced_dataset[(reduced_dataset['Observed Attendance'] == 'Yes')|(reduced_dataset['Observed Attendance'] == 'No')]

print(feature_set)

validation_dataset = reduced_dataset[(reduced_dataset['Observed Attendance'] != 'Yes') & (reduced_dataset['Observed Attendance'] != 'No')]

print(validation_dataset)

#Creating our matrix of features

X = feature_set.iloc[:,0:11].values
Y = feature_set.iloc[:,12].values

print(X,Y)

#Since machine learning models are based on mathematical equations, we can intuitively understand 
#that the text in the variable can cause problems in the equations. We need to encode these categorical 
#data into numbers. To do this, we use the LabelEncoder, OneHotEncoder classes from the sklearn library

from sklearn.preprocessing import LabelEncoder, OneHotEncoder
labelencoder_X = LabelEncoder()

X[:,1] = labelencoder_X.fit_transform(X[:,1])
X[:,2] = labelencoder_X.fit_transform(X[:,2])
X[:,3] = labelencoder_X.fit_transform(X[:,3])
X[:,4] = labelencoder_X.fit_transform(X[:,4])
X[:,5] = labelencoder_X.fit_transform(X[:,5])
X[:,6] = labelencoder_X.fit_transform(X[:,6])
X[:,7] = labelencoder_X.fit_transform(X[:,7])
X[:,8] = labelencoder_X.fit_transform(X[:,8])
X[:,9] = labelencoder_X.fit_transform(X[:,9])
X[:,10] = labelencoder_X.fit_transform(X[:,10])

labelencoder_Y = LabelEncoder()
Y = labelencoder_Y.fit_transform(Y)
print(Y)

#Splitting the dataset into training set and test set

from sklearn.model_selection import train_test_split
X_train, X_test, Y_train, Y_test = train_test_split(X[:,0:11],Y, test_size = 0.2, random_state = 0)

#random_state is set to 0, so we can get the same result everytime we sample the dataset

print(X_test)

print(X_train)

#Fitting Logistic Regression to the Training set

#Why did we choose Logistic Regression as opposed to many other machine learning algorithms?

#Since the problem asks us to both predict the 'Observed Attendance' variable and also come up with a probability,
#and since Logistic Regression gives proabilities, intuitively its the first method to try.

from sklearn.linear_model import LogisticRegression
classifier = LogisticRegression(random_state = 0)
classifier.fit(X_train[:,1:11], Y_train)

#Predicting the Test set results

Y_pred = classifier.predict(X_test[:,1:11])


test_results_df = pd.DataFrame(
    {'ID' : X_test[:,0],
     'Y_test': Y_test,
     'Y_pred': Y_pred     
    })

print (test_results_df)


# We could use techniques like PCA to reduce the dimensionality of the feature set. The following code shows how to apply PCA that gives us vectors which explain the maximum varaibility of the data:
# 
# #from sklearn.decomposition import PCA pca = PCA(n_components = 2)
# #X_train = pca.fit_transform(X_train)
# #X_test = pca.transform(X_test) 
# #explained_variance = pca.explained_variance_ratio_

## Evaluating the model

#Making the confusion matrix. Confusion matrix shows us how accurately the predictions are compared to the original values
#We can derive metrics like Accuracy, Precision, False Positive rate etc from the confusion matrix, that gives a sense of
#how correctly our model was able to classify our target variable.

from sklearn.metrics import confusion_matrix
cm = confusion_matrix(Y_test,Y_pred)

print(cm)

#Predicting the actual probabilities for the 'Observed Attendance' variable in the Test set

Y_pred_prob = classifier.predict_proba(X_test[:,1:11])
print (Y_pred_prob)


# Now lets apply our logistic regression model that we built on the test set to the cases where 'Observed Attendance' is Null

X_Validation = validation_dataset.iloc[:,0:11].values
Y_Validation = validation_dataset.iloc[:,12].values

X_Validation[:,1] = labelencoder_X.fit_transform(X_Validation[:,1])
X_Validation[:,2] = labelencoder_X.fit_transform(X_Validation[:,2])
X_Validation[:,3] = labelencoder_X.fit_transform(X_Validation[:,3])
X_Validation[:,4] = labelencoder_X.fit_transform(X_Validation[:,4])
X_Validation[:,5] = labelencoder_X.fit_transform(X_Validation[:,5])
X_Validation[:,6] = labelencoder_X.fit_transform(X_Validation[:,6])
X_Validation[:,7] = labelencoder_X.fit_transform(X_Validation[:,7])
X_Validation[:,8] = labelencoder_X.fit_transform(X_Validation[:,8])
X_Validation[:,9] = labelencoder_X.fit_transform(X_Validation[:,9])
X_Validation[:,10] = labelencoder_X.fit_transform(X_Validation[:,10])

print(X_Validation)


# Predicting the Validation set results

Y_pred_validation = classifier.predict(X_Validation[:,1:11])
print(Y_pred_validation)


## Model Results

# a. Predictions for the column 'Observed Attendance' where 'Observed Attendance' is Null 

validation_results_df = pd.DataFrame(
    {'ID' : X_Validation[:,0],
     'Y_Validation': Y_Validation,
     'Y_pred_validation': Y_pred_validation     
    })

print (validation_results_df)

#Writing the dataframe to a csv

validation_results_df.to_csv('Predictions', sep='\t')


# b. Probabilities for candidates whose 'Observed Attendance' is Null. The first element in the array shows the probability that the 'Observed Attenance' is 'No'
# and the second column in the array shows the probability that the value for the 'Observed Attendance' is 'Yes'

Y_pred_prob = classifier.predict_proba(X_Validation[:,1:11])
print (Y_pred_prob)

