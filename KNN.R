#install.packages("class")
library(class)
data(iris)
#(1)設定亂數種子
set.seed(123)
#(2)取得資料筆數
n <- nrow(iris)
#(3)取得訓練樣本數的index，70%建模，30%驗證
train_idx <- sample(seq_len(n), size = round(0.7 * n))
#(4)產出訓練資料與測試資料
traindata <- iris[train_idx,]
testdata <- iris[ - train_idx,]
train_y <- traindata[,5]
test_y <- testdata[,5]
#(5)設定K，K通常可以設定為資料筆數的平方根
k_set <- as.integer(sqrt(n))
#(6)建立模型
pred <- knn(train = traindata[-5], test = testdata[-5], cl = train_y, k = k_set)
#(7) 混淆矩陣計算準確度
message("準確度：",sum(diag(table(test_y,pred))) / sum(table(test_y,pred)) *100,"%")
