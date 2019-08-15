# 自行產生藥劑量與感冒痊癒天數資料
x <- c(3,3,4,3,6,8,8,9) #藥劑量
y <- c(22,25,18,20,16,9,12,5) #感冒痊癒天數

New_x <- data.frame(x=5) #預測當x=5時的痊癒天數
# 建立一個線性迴歸模型
Train <- data.frame(x = x, y = y)
lmTrain <- lm(formula = y ~ x, data = Train)
predicted <- predict(lmTrain , newdata = New_x)
#預測當x=5時的痊癒天數
# 模型摘要
summary(lmTrain )
# 作圖
plot(y~x , main = "依藥劑量預測痊癒天數", xlab = "藥劑量", ylab = "感冒痊癒天數", family = "STHeiti")
points(x = New_x, y = predicted, col="green", cex = 2, pch = 16)
abline(reg = lmTrain$coefficients, col = "red", lwd = 1) #函數繪製輔助線