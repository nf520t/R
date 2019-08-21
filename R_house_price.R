getwd()
setwd('e:/r/riii/final')
load('./lvr_prices_big5.RData')
str(lvr_prices)
head(lvr_prices,10)
#請篩選出city_land_type為住宅用
#total_price > 0,building_sqmeter > 0,finish_ymd 非空值的房屋資料,並存入house變數中。
house = lvr_prices[lvr_prices$city_land_type == '住' & lvr_prices$total_price > 0 
                   & lvr_prices$building_sqmeter > 0 & lvr_prices$finish_ymd != '',]
house  
#請使用house資料，利用房屋價格(total_price)及房屋平方米數(building_sqmeter)兩欄位，
#產生一新欄位為每平方米價格(price_per_sqmeter)，並將其四捨五入到整數位。
house$price_per_sqmeter = round(house$total_price / house$building_sqmeter)
house$price_per_sqmeter
#請使用house資料，利用scale() 將每平方米價格(price_per_sqmeter)欄位資料標準化
#，並剔除掉outlier資料(z-score > 3)。
house = house[abs(scale(house$price_per_sqmeter)) <= 3,]
house
#請問在house資料中各行政區(area)的資料筆數為何? 可否畫出其長條圖?
table(house$area)
barplot(table(house$area))
barplot(table(house$area),family="Songti SC")
#請使用house資料，計算各行政區每平方米價格(price_per_sqmeter)
#欄位資料的平均數，中位數及標準差
avg = mean(house$price_per_sqmeter)
avg
Median = median(house$price_per_sqmeter)
Median
var(house$price_per_sqmeter) #總變異數
sqrt(var(house$price_per_sqmeter)) #總標準差
#各區
tapply(house$price_per_sqmeter,house$area,function(e){c(mean(e),median(e),sd(e))})
#請使用house資料,利用ggplot2的facet_wrap函數繪製各行政區房屋每平方米價格
#(price_per_sqmeter)的直方圖
library('ggplot2')
g = ggplot(house,aes(x = price_per_sqmeter))
g + geom_histogram()
g + geom_histogram() + facet_wrap(~area)
g + geom_histogram() + facet_wrap(~area) + theme(text=element_text(size=16,  family="Songti SC"))

#試利用房屋完工日期(finish_ymd)產生一新變數為屋齡(building_age)加入house資料中。
#hint1: 取得當前日期的函數為 Sys.Date()
#hint2: 一年請以365天計算，四捨五入至整數位
#hint3: 將運算完的資料轉為整數型態(integer)
house$finish_ymd = as.Date(house$finish_ymd)
house$building_age = as.integer(round((Sys.Date() - house$finish_ymd) / 365))

#請讀取final資料夾下的house_danger檔案，
#並將house資料集和house_danger資料集以left outer join方式join起來，
#存回house變數中
load('./house_danger.RData')
house = merge(house,house_danger,by = 'ID',all.x = T)

#請將house資料以8:2的比例分為訓練集和測試集，
#將訓練集資料存在trainset變數中，將測試集資料存在testset變數中。
house
set.seed(1230)
n = nrow(house)
n
train_idx <- sample(seq_len(n), size = round(0.8 * n))
#產出訓練資料與測試資料
trainset <- house[train_idx,]
testset <- house[ - train_idx,]

#利用rpart套件建立一預測房屋是否為危樓(danger)的決策樹模型，
#請利用行政區(area), 屋齡(building_age), 房屋總平方米數(building_sqmeter),
#房屋類型(building_type)及每平方米價格(price_per_sqmeter)
#5個變數作為解釋變數放入模型當中建模，並將模型存在house.rp變數中。

library('rpart')
house.rp = rpart(danger ~ area+building_age+building_type+building_sqmeter+price_per_sqmeter,data = trainset)

#請利用plot()和text()畫出house.rp模型的決策樹
plot(house.rp)
text(house.rp,cex = 0.8)

plot(house.rp, uniform=TRUE,branch = 0.6, margin=0.1)
text(house.rp, all=TRUE, use.n=TRUE, cex=0.7)

house.rp$variable.importance

#請問此決策數是否需要進行剪枝(prune)？
house.rp$cptable
#如需剪枝請將修剪後的模型存回house.rp中。
min_row = which.min(house.rp$cptable[,"xerror"])
house.cp = house.rp$cptable[min_row, "CP"]

house.cp = house.rp$cptable[which.min(house.rp$cptable[,"xerror"]), "CP"]
house.rp=prune(house.rp, cp=house.cp)

#trainset測試模型
predictions =predict(house.rp, trainset,type = 'class')
library('caret')
library('e1071')
confusionMatrix(table(predictions, trainset$danger))


#請將測試集資料(testset)放入模型中進行驗證，
#請問此模型的accuracy, precision, recall等績效分別為何？

predictions = predict(house.rp, testset,type = 'class')
library('caret')
library('e1071')
confusionMatrix(table(predictions, testset$danger))

#請繪製出此模型的ROC曲線，並計算其AUC
library(ROCR)
predictions <-predict(house.rp, testset, type="prob")
pred.to.roc<-predictions[, 'YES']
pred.rocr<-prediction(pred.to.roc, testset$danger)
perf.tpr.rocr<-performance(pred.rocr, "tpr","fpr")
plot(perf.tpr.rocr)

perf.rocr<-performance(pred.rocr, measure ="auc", x.measure="cutoff")
print(perf.rocr@y.values)


#取正例預測機率
y_prob = predict(house.rp,newdata=testset,type="prob")[,1]
pred <- prediction(y_prob, labels = testset$danger)
# tpr: True Positive Ratio 正確預測正例;
# fpr: False Positive Ration誤判為正例
perf <- performance(pred, "tpr", "fpr")
plot(perf)
points(c(0,1),c(0,1),type="l",lty=2) #畫虛線

perf <- performance(pred, "auc")
( AUC = perf@y.values[[1]] )

#y_prob = predict(house.rp,newdata=testset,type="prob")[,1]
pred <- prediction(pred.to.roc,labels = testset$danger)
pred.rocr<-prediction(pred.to.roc, testset$danger)
# tpr: True Positive Ratio 正確預測正例;
# fpr: False Positive Ration誤判為正例
perf <- performance(pred, "tpr", "fpr")
plot(perf)
points(c(0,1),c(0,1),type="l",lty=2) #畫虛線

perf <- performance(pred, "auc")
( AUC = perf@y.values[[1]] )

