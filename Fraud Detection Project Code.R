
# Data Import and Libraries

```{r message=FALSE, warning=FALSE, echo=TRUE, results='hide'}
## Data Import
cc <- read.csv ("creditcard.csv", sep = ",", header = T)
library(ROSE)
library(rpart)
library(caret)
library(unbalanced)
```

# Data Cleaning and Splitting

```{r}
head(cc)
sapply(cc,anyNA)
str(cc)
table(cc$Class)
## class distribution
prop.table(table(cc$Class))
# so this is severely inbalnaced


## Under
# It was included for benchmarki
```

## Modeling of unbalanced data
```{r}
## dividing data for training and testing (70% for training):
cc_train<-sample(nrow(cc),floor(nrow(cc)*0.7))
train<-cc[cc_train,]
test<- cc[-cc_train,]


model1<- caret::train(as.factor(Class)~.,data=train,method="naive_bayes")
pred1 <- predict(model1, test)
eval1 <- confusionMatrix(pred1,as.factor(test$Class))
eval1
# accuracy = 99.6%
roc.curve(as.factor(test$Class),pred1,plotit = T)
# AUC = 0.896
```


# Class Imbalance

## Undersampling

```{r}
## random undersampling without replacement (about 50%)
cc_under1 <- ovun.sample(Class~.,data = train,method = "under")
cc_under1 <- cc_under1$data
cc_under1 <- cc_under1[sample(nrow(cc_under1),nrow(cc_under1)),]
cc_under1 <- cc_under1[sample(nrow(cc_under1),nrow(cc_under1)),]
rownames(cc_under1) <- 1:(nrow(cc_under1))
table(cc_under1$Class)
prop.table(table(cc_under1$Class))

## random undersampling without replacement (10% of rare class)
cc_under2 <- ovun.sample(Class~.,data = train,method = "under",p=0.10)$data
cc_under2 <- cc_under2[sample(nrow(cc_under2),nrow(cc_under2)),]
cc_under2 <- cc_under2[sample(nrow(cc_under2),nrow(cc_under2)),]
rownames(cc_under1) <- 1:(nrow(cc_under1))
table(cc_under2$Class)
prop.table(table(cc_under2$Class))

## random undersampling without replacement (20% of rare class)
cc_under3 <- ovun.sample(Class~.,data = train,method = "under",p=0.20)$data
cc_under3 <- cc_under3[sample(nrow(cc_under3),nrow(cc_under3)),]
cc_under3 <- cc_under3[sample(nrow(cc_under3),nrow(cc_under3)),]
rownames(cc_under1) <- 1:(nrow(cc_under1))
table(cc_under3$Class)
prop.table(table(cc_under3$Class))

## random undersampling without replacement (30% of rare class)
cc_under4 <- ovun.sample(Class~.,data = train,method = "under",p=0.30)$data
cc_under4 <- cc_under4[sample(nrow(cc_under4),nrow(cc_under4)),]
cc_under4 <- cc_under4[sample(nrow(cc_under4),nrow(cc_under4)),]
rownames(cc_under1) <- 1:(nrow(cc_under1))
table(cc_under4$Class)
prop.table(table(cc_under4$Class))

## random undersampling without replacement (40% of rare class)
cc_under5 <- ovun.sample(Class~.,data = train,method = "under",p=0.40)$data
cc_under5 <- cc_under5[sample(nrow(cc_under5),nrow(cc_under5)),]
cc_under5 <- cc_under5[sample(nrow(cc_under5),nrow(cc_under5)),]
rownames(cc_under1) <- 1:(nrow(cc_under1))
table(cc_under5$Class)
prop.table(table(cc_under5$Class))

## random undersampling without replacement (1% of rare class)
cc_under6 <- ovun.sample(Class~.,data = train,method = "under",p=0.01)$data
cc_under6 <- cc_under6[sample(nrow(cc_under6),nrow(cc_under6)),]
cc_under6 <- cc_under6[sample(nrow(cc_under6),nrow(cc_under6)),]
rownames(cc_under1) <- 1:(nrow(cc_under1))
table(cc_under6$Class)
prop.table(table(cc_under6$Class))

##condensed nearest neighbor
cc_under7 <- ubBalance(train[,-31],as.factor(train[,31]),type = "ubCNN",k=2)
cc_under7 <- cbind.data.frame(cc_under7$X,cc_under7$Y)
colnames(cc_under7)[31]<-"Class"
cc_under7 <- cc_under7[sample(nrow(cc_under7),nrow(cc_under7)),]
cc_under7 <- cc_under7[sample(nrow(cc_under7),nrow(cc_under7)),]
rownames(cc_under1) <- 1:(nrow(cc_under1))
table(cc_under7$Class)
prop.table(table(cc_under7$Class))

##Edited Nearest Neighbor
cc_under8 <- ubBalance(train[,-31],as.factor(train$Class),type = "ubCNN",k=2)
cc_under8 <- cbind.data.frame(cc_under8$X,cc_under8$Y)
colnames(cc_under8)[31]<-"Class"
cc_under8 <- cc_under8[sample(nrow(cc_under8),nrow(cc_under8)),]
cc_under8 <- cc_under8[sample(nrow(cc_under8),nrow(cc_under8)),]
rownames(cc_under1) <- 1:(nrow(cc_under1))
table(cc_under8$Class)
prop.table(table(cc_under8$Class))

##underbalancing + ubCNN


## informatve undersampling
## EasyEnsemble
## BalanceCascade
```

## modeling undersampled data (naive_bayes)

```{r}
## random undersampling without replacement (about 50%)
model2<- caret::train(as.factor(Class)~.,data=cc_under1,method="naive_bayes")
pred2 <- predict(model2, test)
eval2 <- confusionMatrix(pred2,as.factor(test$Class))
eval2
# accuracy = 96.68%
roc.curve(as.factor(test$Class),pred2,plotit = F)
# AUC = 0.907

## random undersampling without replacement (10% of rare class)
model3<- caret::train(as.factor(Class)~.,data=cc_under2,method="naive_bayes")
pred3 <- predict(model3, test)
eval3 <- confusionMatrix(pred3,as.factor(test$Class))
eval3
# accuracy = 98%
roc.curve(as.factor(test$Class),pred3,plotit = F)
# AUC = 0.911

## random undersampling without replacement (20% of rare class)
model4<- caret::train(as.factor(Class)~.,data=cc_under3,method="naive_bayes")
pred4 <- predict(model4, test)
eval4 <- confusionMatrix(pred4,as.factor(test$Class))
eval4
# accuracy = 97.46%
roc.curve(as.factor(test$Class),pred4,plotit = F)
# AUC = 0.895

## random undersampling without replacement (30% of rare class)
model5<- caret::train(as.factor(Class)~.,data=cc_under4,method="naive_bayes")
pred5 <- predict(model5, test)
eval5 <- confusionMatrix(pred5,as.factor(test$Class))
eval5
# accuracy = 96.47%
roc.curve(as.factor(test$Class),pred5,plotit = F)
# AUC = 0.906

## random undersampling without replacement (40% of rare class)
model6<- caret::train(as.factor(Class)~.,data=cc_under5,method="naive_bayes")
pred6 <- predict(model6, test)
eval6 <- confusionMatrix(pred6,as.factor(test$Class))
eval6
# accuracy = 96.04%
roc.curve(as.factor(test$Class),pred6,plotit = F)
# AUC = 0.894

## random undersampling without replacement (1% of rare class)
model7<- caret::train(as.factor(Class)~.,data=cc_under6,method="naive_bayes")
pred7 <- predict(model7, test)
eval7 <- confusionMatrix(pred7,as.factor(test$Class))
eval7
# accuracy = 99.15%
roc.curve(as.factor(test$Class),pred7,plotit = F)
# AUC = 0.9

##condensed nearest neighbor
model8<- caret::train(as.factor(Class)~.,data=cc_under7,method="naive_bayes")
pred8 <- predict(model8, test)
eval8 <- confusionMatrix(pred8,as.factor(test$Class))
eval8
# accuracy = 99.65%
roc.curve(as.factor(test$Class),pred8,plotit = F)
# AUC = 0.896

##Edited Nearest Neighbor
model9<- caret::train(as.factor(Class)~.,data=cc_under8,method="naive_bayes")
pred9 <- predict(model9, test)
eval9 <- confusionMatrix(pred9,as.factor(test$Class))
eval9
# accuracy = 99.65%
roc.curve(as.factor(test$Class),pred9,plotit = F)
# AUC = 0.896

```

## modeling undersampled data (Random Forest)

```{r}
## CONTINUE UPDATING HERE
## NEED to LOOK AT OVERALL ARCHITECTURE ON WHAT I PLAN TO DO FOR UNDRBALANCED AND WRITE A FUNCTION TO MAKE THINGS QUICKER
## and shouldnt penalty be for false negative or something (also read about kappa in caret) , so highlight that for evaluation method

## random undersampling without replacement (about 50%)
model10<- caret::train(as.factor(Class)~.,data=cc_under1,method="rf")
pred10 <- predict(model10, test)
eval10 <- confusionMatrix(pred10,as.factor(test$Class))
eval10
# accuracy = 98.24%
roc.curve(as.factor(test$Class),pred10,plotit = F)
#  = 0.957

## random undersampling without replacement (10% of rare class)
model11<- caret::train(as.factor(Class)~.,data=cc_under2,method="rf")
pred11 <- predict(model11, test)
eval11 <- confusionMatrix(pred11,as.factor(test$Class))
eval11
# accuracy = 99.89%
roc.curve(as.factor(test$Class),pred11,plotit = F)
# ROC = 0.941

## random undersampling without replacement (20% of rare class)
model12<- caret::train(as.factor(Class)~.,data=cc_under3,method="rf")
pred12 <- predict(model12, test)
eval12 <- confusionMatrix(pred12,as.factor(test$Class))
eval12
# accuracy = 99.77%
roc.curve(as.factor(test$Class),pred12,plotit = F)
# ROC = 0.944

## random undersampling without replacement (30% of rare class)
model13<- caret::train(as.factor(Class)~.,data=cc_under4,method="rf")
pred13 <- predict(model13, test)
eval13 <- confusionMatrix(pred13,as.factor(test$Class))
eval13
# accuracy = 99.46%
roc.curve(as.factor(test$Class),pred13,plotit = F)
# ROC = 0.946

## random undersampling without replacement (40% of rare class)
model14<- caret::train(as.factor(Class)~.,data=cc_under5,method="rf")
pred14 <- predict(model14, test)
eval14 <- confusionMatrix(pred14,as.factor(test$Class))
eval14
# accuracy = 98.5%
roc.curve(as.factor(test$Class),pred14,plotit = F)
# ROC = 0.962

## random undersampling without replacement (1% of rare class)
model15<- caret::train(as.factor(Class)~.,data=cc_under6,method="rf")
pred15 <- predict(model15, test)
eval15 <- confusionMatrix(pred15,as.factor(test$Class))
eval15
# accuracy = 97.98%
roc.curve(as.factor(test$Class),pred15,plotit = F)
# ROC = 0.935

##condensed nearest neighbor
model16<- caret::train(as.factor(Class)~.,data=cc_under7,method="rf")
pred16 <- predict(model16, test)
eval16 <- confusionMatrix(pred16,as.factor(test$Class))
eval16
# accuracy = 97.98%
roc.curve(as.factor(test$Class),pred16,plotit = F)
# AUC = 0.935

##Edited Nearest Neighbor
model17<- caret::train(as.factor(Class)~.,data=cc_under8,method="rf")
pred17 <- predict(model17, test)
eval17 <- confusionMatrix(pred17,as.factor(test$Class))
eval17
# accuracy = 97.98%
roc.curve(as.factor(test$Class),pred17,plotit = F)
# AUC = 0.935

```
## modeling undersampled data (knn)

```{r}
## random undersampling without replacement (about 50%)
model18<- caret::train(as.factor(Class)~.,data=cc_under1,method="knn")
pred18 <- predict(model18, test)
eval18 <- confusionMatrix(pred18,as.factor(test$Class))
eval18
# accuracy = 97.98%
roc.curve(as.factor(test$Class),pred18,plotit = F)
# AUC = 0.935

## random undersampling without replacement (10% of rare class)
model19<- caret::train(as.factor(Class)~.,data=cc_under2,method="knn")
pred19 <- predict(model19, test)
eval19 <- confusionMatrix(pred19,as.factor(test$Class))
eval19
# accuracy = 97.62%
roc.curve(as.factor(test$Class),pred19,plotit = F)
# AUC = 0.937

## random undersampling without replacement (20% of rare class)
model20<- caret::train(as.factor(Class)~.,data=cc_under3,method="knn")
pred20 <- predict(model20, test)
eval20 <- confusionMatrix(pred20,as.factor(test$Class))
eval20
# accuracy = 97.19%
roc.curve(as.factor(test$Class),pred20,plotit = F)
# AUC = 0.921

## random undersampling without replacement (30% of rare class)
model21<- caret::train(as.factor(Class)~.,data=cc_under4,method="knn")
pred21 <- predict(model21, test)
eval21 <- confusionMatrix(pred21,as.factor(test$Class))
eval21
# accuracy = 97.98%
roc.curve(as.factor(test$Class),pred21,plotit = F)
# AUC = 0.935

## random undersampling without replacement (40% of rare class)
model22<- caret::train(as.factor(Class)~.,data=cc_under5,method="knn")
pred22 <- predict(model22, test)
eval22 <- confusionMatrix(pred22,as.factor(test$Class))
eval22
# accuracy = 97.98%
roc.curve(as.factor(test$Class),pred22,plotit = F)
# AUC = 0.935

## random undersampling without replacement (1% of rare class)
model23<- caret::train(as.factor(Class)~.,data=cc_under6,method="knn")
pred23 <- predict(model23, test)
eval23 <- confusionMatrix(pred23,as.factor(test$Class))
eval23
# accuracy = 97.98%
roc.curve(as.factor(test$Class),pred23,plotit = F)
# AUC = 0.935

##condensed nearest neighbor
model24<- caret::train(as.factor(Class)~.,data=cc_under7,method="knn")
pred24 <- predict(model24, test)
eval24 <- confusionMatrix(pred24,as.factor(test$Class))
eval24
# accuracy = 97.98%
roc.curve(as.factor(test$Class),pred24,plotit = F)
# AUC = 0.935

##Edited Nearest Neighbor
model25<- caret::train(as.factor(Class)~.,data=cc_under8,method="knn")
pred25 <- predict(model25, test)
eval25 <- confusionMatrix(pred25,as.factor(test$Class))
eval25
# accuracy = 97.98%
roc.curve(as.factor(test$Class),pred25,plotit = F)
# AUC = 0.935

```

## Check Caret imabalancing funtions

## Builiding function to run through all models being considered
# initial models we have to cover: svm(linear), knn, nn(mlp),rf,naive_bayes,xgboost,logistic reg
# training controls considered: 5,7,10,12 cv, 10 times repeated 5,7,10,12  cv, 20 times repeated 5,7,10,12,  cv, bootstrapping (depending on method: 5, 10,100,1000,2000,5000 and 10000)

# naive_bayes
```{r}
# search for average tuning parameters:
fitControlsearch <- trainControl(method = "cv",number = 5, search = "random")
modelsearch <- caret::train(as.factor(Class)~.,data = cc_under1, method = "naive_bayes",
                       trControl = fitControlsearch, tuneLength =10)
modelsearch

#hyperparameter ranges: laplace(laplace correction): 0; usekernel: T,F; adjust (Bandwidth Adjustment): 1

#trying out before buidling for function
fitControltry <- trainControl(method = "cv",number = 6)
parGridtry <- expand.grid(laplace=0,usekernel=c(T,F), adjust =1)
modeltry <- caret::train(as.factor(Class)~.,data = cc_under1, method = "naive_bayes",
                       trControl = fitControltry, tuneGrid=parGridtry)
modeltry
#final_model_info
modelsearch$finalModel$tuneValue

predtry <- predict(modeltry, test)
evaltry <- confusionMatrix(predtry,as.factor(test$Class))
evaltry
#Accuracy
evaltry$overall[1]
#kappa
evaltry$overall[2]
#specificity
evaltry$byClass[2]



#for function
# training controls
fitControl1 <- trainControl(method = "cv",number = 5)
fitControl2 <- trainControl(method = "cv",number = 7)
fitControl3 <- trainControl(method = "cv",number = 10)
fitControl4 <- trainControl(method = "cv",number = 12)
fitControl5 <- trainControl(method = "repeatedcv",repeats = 10,number = 5)
fitControl6 <- trainControl(method = "repeatedcv",repeats = 10,number = 7)
fitControl7 <- trainControl(method = "repeatedcv",repeats = 10,number = 10)
fitControl8 <- trainControl(method = "repeatedcv",repeats = 10,number = 12)
fitControl9 <- trainControl(method = "repeatedcv",repeats = 20,number = 5)
fitControl10 <- trainControl(method = "repeatedcv",repeats = 20,number = 7)
fitControl11 <- trainControl(method = "repeatedcv",repeats = 20,number = 10)
fitControl12 <- trainControl(method = "repeatedcv",repeats = 20,number = 12)
fitControl13 <- trainControl(method = "boot",number = 5)
fitControl14 <- trainControl(method = "boot",number = 10)
fitControl15 <- trainControl(method = "boot",number = 100) #max for cc_under1
fitControl16 <- trainControl(method = "boot",number = 1000) #max for cc_under2, cc_under3, cc_under4, cc_under5
fitControl17 <- trainControl(method = "boot",number = 2000)
fitControl18 <- trainControl(method = "boot",number = 5000)
fitControl19 <- trainControl(method = "boot",number = 10000)
fitControls <- list(fitControl1,fitControl2,fitControl3,fitControl4,fitControl5,fitControl6,fitControl7
                 ,fitControl8,fitControl9,fitControl10,fitControl11,fitControl12,fitControl13,fitControl14,
                 fitControl15,fitControl16,fitControl17,fitControl18,fitControl19)
fitControls<- list(fitControl1,fitControl2,fitControl3,fitControl4)

#datasets
ccdatasets <- list(cc_under1,cc_under2,cc_under3,cc_under4,cc_under5,cc_under6,cc_under7,cc_under8)

#for function for naive_bayes
for (i in 1) {
  parGrid <- expand.grid(laplace=0,usekernel=c(T,F), adjust =1)
  accuracy <- 0
  kappa <- 0
  specificity <- 0
  hyperparameters <- data.frame(matrix(0,nrow = 1,ncol=ncol(parGrid)))
  modelname <- 0
  for (j in 1:(length(ccdatasets)-6)) {
    for (k in 1:(length(fitControls))) {
      model <- caret::train(as.factor(Class)~.,data = ccdatasets[[j]], method = "naive_bayes",trControl = fitControls[[k]],
                            tuneGrid=parGrid)
      pred <- predict(model, test)
      eval <- confusionMatrix(pred,as.factor(test$Class))
      accuracy <- append(accuracy,eval$overall[1])
      kappa <- append(kappa,eval$overall[2])
      specificity <- append(specificity,eval$byClass[2])
      colnames(hyperparameters)<- colnames(model$finalModel$tuneValue)
      hyperparameters <- rbind.data.frame(hyperparameters,model$finalModel$tuneValue)
      modelname<-append(modelname,paste("ccdatasets",j,"_fitControls",k,sep = ""))
    }
  }
  Results <- data.frame(modelname,hyperparameters,specificity,kappa,accuracy)[-1,]
  Results <- Results[order(-Results$specificity),]
  rownames(Results) <- 1:(length(kappa)-1)
  print(Results)
}

#check  1st 2 datasets and select 4 traincontrols from there

## Initial -  Naive Bayes, All training Controls, First dataset
#Old# - Naive_Bayes_Results <- Results
## CURRENT - All training Controls, Datasets (no 6)
Naive_Bayes_Results <- rbind.data.frame(Naive_Bayes_Results,Results)
Naive_Bayes_Results




```

```{python}


```

