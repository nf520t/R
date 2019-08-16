### 補充：隨機森林(Random Forest)
```{R}
#install.packages('randomForest')
#install.packages('caret')
#install.packages('e1071')
#install.packages(ROCR)
library(randomForest)
library('caret')
library('e1071')
library(ROCR)
rf_model = randomForest(formula=churn ~ .,data=churnTrain)
#find best ntree
plot(rf_model)
legend("topright",colnames(rf_model$err.rate),col=1:3,cex=0.8,fill=1:3)
#find nest mtry
tuneRF(churnTrain[,-17],churnTrain[,17])
rf_model <- randomForest(churn ~., data = churnTrain, ntree=50,mtry=4)
# rf_model = train(churn~.,data=churnTrain,method='rf')
confusionMatrix(table(predict(rf_model,churnTest),churnTest$churn))
rf.predict.prob <- predict(rf_model, churnTest, type="prob")
rf.prediction <- prediction(rf.predict.prob[,"yes"], as.factor(churnTest$churn))
rf.auc <- performance(rf.prediction, measure = "auc", x.measure = "cutoff")
rf.performance <- performance(rf.prediction, measure="tpr",x.measure="fpr")
plot(rf.performance)
#比較CART和RandomForest
tune_funs = expand.grid(cp=seq(0,0.1,0.01))
rpart_model =train(churn~., data=churnTrain, method="rpart",tuneGrid=tune_funs)
rpart_prob_yes = predict(rpart_model,churnTest,type='prob')[,1]
rpart_pred.rocr = prediction(rpart_prob_yes,churnTest$churn)
rpart_perf.rocr = performance(rpart_pred.rocr,measure = 'tpr',x.measure = 'fpr')
plot(rpart_perf.rocr,col='red')
plot(rf.performance,col='black',add=T)
legend(x=0.7, y=0.2, legend =c('randomforest','rpart'), fill= c("black","red"))
```