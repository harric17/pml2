library(caret)
library(e1071)
getwd()
setwd("C:/Users/harric17/Desktop/R Stuff/coursera/machine_learning2")

testing = as.data.frame(read.csv(file = "pml-testing.csv", header = TRUE))
training = as.data.frame(read.csv(file = "pml-training.csv", header = TRUE))

#unnecessay variables
myvars= names(training) %in% c("X","problem_id","raw_timestamp_part_1","raw_timestamp_part_2","cvtd_timestamp")
training = training[!myvars]
myvars= names(testing) %in% c("X","problem_id","raw_timestamp_part_1","raw_timestamp_part_2","cvtd_timestamp")
testing = testing[!myvars]

dim(testing)
dim(training)


#find high NA
var=rep(NA,dim(testing)[2])
perc=rep(NA,dim(testing)[2])
x =data.frame(var,perc)

for (i in 1:dim(testing)[2] ) {
  print(paste("% NA for ",colnames(testing)[i],": ",sum(is.na(testing[,i]))/length(testing[,i]),sep=""))
  
  
  x$var[i]= colnames(testing)[i]
  x$perc[i] = sum(is.na(testing[,i]))/length(testing[,i])
  
}


length(x[x$perc==0,1])

table(x$perc)


#keep 55 vars
keepvars=x[x$perc==0,1]
keepvars2 = c(keepvars,"classe")
training = training[,keepvars2]
testing = testing[,keepvars]

dim(training)
dim(testing)

head(testing)
head(training)




#change class

training$user_name=as.factor(training$user_name)
training$new_window=as.factor(training$new_window)
training$classe=as.factor(training$classe)

testing$user_name=as.factor(testing$user_name)
testing$new_window=as.factor(testing$new_window)

dim(training)
dim(testing)

for(i in 3:dim(testing)[2]){
  training[i]=as.numeric(training[,i])
}

for(i in 3:dim(testing)[2]){
  testing[i]=as.numeric(testing[,i])
}



sapply(training,class)
sapply(testing,class)
dim(testing)
dim(training)

sum(sapply(training,is.factor))
sum(sapply(testing,is.factor))

sum(sapply(training,is.numeric))
sum(sapply(training,is.numeric))




#PCA

# 
# z=sapply(training,is.factor)
# trainpca=(training[,!z])
# testpca=(testing[,!z])
# dim(trainpca)
# dim(testpca)


# trainpr = preProcess(trainpca,method="pca",threshhold=.8)
# testpr = preProcess(testpca,method="pca",threshhold=.8)
# 
# summary(trainpr)
# 
# dim(trainpr$numComp[,])
# trainpr$data
# names()
# 
# dim(trainpr$x[,])



#subset to smaller training set

set.seed(2)
training$randnum = runif(length(training$classe))
training2 = training[training$randnum <.15,]
training2$randnum=NULL
dim(training2)

#convert problematic factors to numeric
# z=sapply(training2,is.factor)
# train3=(training2[,z])
# 
# var=rep(NA,dim(train3)[2])
# lvls=rep(NA,dim(train3)[2])
# x =data.frame(var,lvls)
# 
# for (i in 1:dim(train3)[2]){
#   print(paste(colnames(train3)[i],": ",length(unique(train3[,i])),sep=""))
#   
#   x$var[i]= colnames(train3)[i]
#   x$lvls[i] = length(unique(train3[,i]))
#   
# }
# 
# x = x[x$lvls>20,]
# dim(x)[1]
# 
# for (i in 1:dim(training2)[2]){
#   if(colnames(training2)[i] %in% x$var){
#     training2[i]=as.numeric(training2[,i])
#   }
#   if(colnames(testing)[i] %in% x$var){
#     testing[i]= as.numeric(testing[,i])
#   }
#   
#   
#   print(colnames(training2)[i])
#   print(colnames(training2)[i] %in% x$var)
# }
# 
# 
# 
# 
# sum(z)
# sum(sapply(training2,is.factor))
# dim(testing)
# 


#ugh make 2 datasets match variable classes
# 
# z=sapply(training2,is.factor)
# train3=(training2[,z])
# train4=(training2[,-z])
# colnames(train4)
# 
# for (i in 1:dim(training2)[2]){
#   if(colnames(training2)[i] %in% colnames(train3)){
#     training2[i]=as.factor(training2[,i])
#   }
#   if(colnames(testing)[i] %in% colnames(train3)){
#     testing[i]= as.factor(testing[,i])
#   }
#   if(colnames(training2)[i] %in% colnames(train4)){
#     training2[i]=as.numeric(training2[,i])
#   }
#   if(colnames(testing)[i] %in% colnames(train4)){
#     testing[i]= as.numeric(testing[,i])
#   }
# }
# 
# sum(z)
# sum(sapply(testing,is.factor))
# dim(testing)
# 
# 
# 




training2 = training2[3:dim(training2)[2]]
testing = testing[3:dim(testing)[2]]
testing2 = training[training$randnum >=.15,]


set.seed(33833)
# modFit = train(classe~.,method="rf",data=training,preProcess="pca",trControl = trainControl(method = "cv", number=2),preProcOptions=list(thresh=0.95))
# modFit = train(classe~.,method="rf",data=training2,trControl = trainControl(method = "cv", number=5))
library(randomForest)
modFit = randomForest(classe~.,data=training2, ntree=500)
modFit
names(modFit)
modFit$confusion
answers=predict(modFit,testing)
confusionMatrix(predict(modFit,testing2),testing2$classe)
modFit$mtry
names(training2)



sapply(training2,class)
class(modFit)
dim(training)
sum(names(testing)==names(training2[1:55]))/length(names(testing))


# predict(modFit,testing)
# warnings()
# sum(sapply(testing,is.factor))


z=modFit$importance[order(-modFit$importance),]
importance=z[1:10]


pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

getwd()
pml_write_files(answers)


library(knitr)
