getwd()
setwd('e:/r/riii/final')
load('./lvr_prices_big5.RData')
str(lvr_prices)
head(lvr_prices,10)
#�пz��Xcity_land_type�����v��
#total_price > 0,building_sqmeter > 0,finish_ymd �D�ŭȪ��Ыθ��,�æs�Jhouse�ܼƤ��C
house = lvr_prices[lvr_prices$city_land_type == '��' & lvr_prices$total_price > 0 
                   & lvr_prices$building_sqmeter > 0 & lvr_prices$finish_ymd != '',]
house  
#�Шϥ�house��ơA�Q�ΩЫλ���(total_price)�ΩЫΥ���̼�(building_sqmeter)�����A
#���ͤ@�s��쬰�C����̻���(price_per_sqmeter)�A�ñN��|�ˤ��J���Ʀ�C
house$price_per_sqmeter = round(house$total_price / house$building_sqmeter)
house$price_per_sqmeter
#�Шϥ�house��ơA�Q��scale() �N�C����̻���(price_per_sqmeter)����ƼзǤ�
#�A�í簣��outlier���(z-score > 3)�C
house = house[abs(scale(house$price_per_sqmeter)) <= 3,]
house
#�аݦbhouse��Ƥ��U��F��(area)����Ƶ��Ƭ���? �i�_�e�X�������?
table(house$area)
barplot(table(house$area))
barplot(table(house$area),family="Songti SC")
#�Шϥ�house��ơA�p��U��F�ϨC����̻���(price_per_sqmeter)
#����ƪ������ơA����ƤμзǮt
avg = mean(house$price_per_sqmeter)
avg
Median = median(house$price_per_sqmeter)
Median
var(house$price_per_sqmeter) #�`�ܲ���
sqrt(var(house$price_per_sqmeter)) #�`�зǮt
#�U��
tapply(house$price_per_sqmeter,house$area,function(e){c(mean(e),median(e),sd(e))})
#�Шϥ�house���,�Q��ggplot2��facet_wrap���ø�s�U��F�ϩЫΨC����̻���
#(price_per_sqmeter)�������
library('ggplot2')
g = ggplot(house,aes(x = price_per_sqmeter))
g + geom_histogram()
g + geom_histogram() + facet_wrap(~area)
g + geom_histogram() + facet_wrap(~area) + theme(text=element_text(size=16,  family="Songti SC"))

#�էQ�ΩЫΧ��u���(finish_ymd)���ͤ@�s�ܼƬ�����(building_age)�[�Jhouse��Ƥ��C
#hint1: ���o���e�������Ƭ� Sys.Date()
#hint2: �@�~�ХH365�ѭp��A�|�ˤ��J�ܾ�Ʀ�
#hint3: �N�B�⧹������ର��ƫ��A(integer)
house$finish_ymd = as.Date(house$finish_ymd)
house$building_age = as.integer(round((Sys.Date() - house$finish_ymd) / 365))

#��Ū��final��Ƨ��U��house_danger�ɮסA
#�ñNhouse��ƶ��Mhouse_danger��ƶ��Hleft outer join�覡join�_�ӡA
#�s�^house�ܼƤ�
load('./house_danger.RData')
house = merge(house,house_danger,by = 'ID',all.x = T)

#�бNhouse��ƥH8:2����Ҥ����V�m���M���ն��A
#�N�V�m����Ʀs�btrainset�ܼƤ��A�N���ն���Ʀs�btestset�ܼƤ��C
house
set.seed(1230)
n = nrow(house)
n
train_idx <- sample(seq_len(n), size = round(0.8 * n))
#���X�V�m��ƻP���ո��
trainset <- house[train_idx,]
testset <- house[ - train_idx,]

#�Q��rpart�M��إߤ@�w���ЫάO�_���M��(danger)���M����ҫ��A
#�ЧQ�Φ�F��(area), ����(building_age), �Ы��`����̼�(building_sqmeter),
#�Ы�����(building_type)�ΨC����̻���(price_per_sqmeter)
#5���ܼƧ@�������ܼƩ�J�ҫ������ؼҡA�ñN�ҫ��s�bhouse.rp�ܼƤ��C

library('rpart')
house.rp = rpart(danger ~ area+building_age+building_type+building_sqmeter+price_per_sqmeter,data = trainset)

#�ЧQ��plot()�Mtext()�e�Xhouse.rp�ҫ����M����
plot(house.rp)
text(house.rp,cex = 0.8)

plot(house.rp, uniform=TRUE,branch = 0.6, margin=0.1)
text(house.rp, all=TRUE, use.n=TRUE, cex=0.7)

house.rp$variable.importance

#�аݦ��M���ƬO�_�ݭn�i��ŪK(prune)�H
house.rp$cptable
#�p�ݰŪK�бN�װū᪺�ҫ��s�^house.rp���C
min_row = which.min(house.rp$cptable[,"xerror"])
house.cp = house.rp$cptable[min_row, "CP"]

house.cp = house.rp$cptable[which.min(house.rp$cptable[,"xerror"]), "CP"]
house.rp=prune(house.rp, cp=house.cp)

#trainset���ռҫ�
predictions =predict(house.rp, trainset,type = 'class')
library('caret')
library('e1071')
confusionMatrix(table(predictions, trainset$danger))


#�бN���ն����(testset)��J�ҫ����i�����ҡA
#�аݦ��ҫ���accuracy, precision, recall���Z�Ĥ��O����H

predictions = predict(house.rp, testset,type = 'class')
library('caret')
library('e1071')
confusionMatrix(table(predictions, testset$danger))

#��ø�s�X���ҫ���ROC���u�A�íp���AUC
library(ROCR)
predictions <-predict(house.rp, testset, type="prob")
pred.to.roc<-predictions[, 'YES']
pred.rocr<-prediction(pred.to.roc, testset$danger)
perf.tpr.rocr<-performance(pred.rocr, "tpr","fpr")
plot(perf.tpr.rocr)

perf.rocr<-performance(pred.rocr, measure ="auc", x.measure="cutoff")
print(perf.rocr@y.values)


#�����ҹw�����v
y_prob = predict(house.rp,newdata=testset,type="prob")[,1]
pred <- prediction(y_prob, labels = testset$danger)
# tpr: True Positive Ratio ���T�w������;
# fpr: False Positive Ration�~�P������
perf <- performance(pred, "tpr", "fpr")
plot(perf)
points(c(0,1),c(0,1),type="l",lty=2) #�e��u

perf <- performance(pred, "auc")
( AUC = perf@y.values[[1]] )

#y_prob = predict(house.rp,newdata=testset,type="prob")[,1]
pred <- prediction(pred.to.roc,labels = testset$danger)
pred.rocr<-prediction(pred.to.roc, testset$danger)
# tpr: True Positive Ratio ���T�w������;
# fpr: False Positive Ration�~�P������
perf <- performance(pred, "tpr", "fpr")
plot(perf)
points(c(0,1),c(0,1),type="l",lty=2) #�e��u

perf <- performance(pred, "auc")
( AUC = perf@y.values[[1]] )
