# �ۦ沣���ľ��q�P�P�_��¡�ѼƸ��
x <- c(3,3,4,3,6,8,8,9) #�ľ��q
y <- c(22,25,18,20,16,9,12,5) #�P�_��¡�Ѽ�

New_x <- data.frame(x=5) #�w����x=5�ɪ���¡�Ѽ�
# �إߤ@�ӽu�ʰj�k�ҫ�
Train <- data.frame(x = x, y = y)
lmTrain <- lm(formula = y ~ x, data = Train)
predicted <- predict(lmTrain , newdata = New_x)
#�w����x=5�ɪ���¡�Ѽ�
# �ҫ��K�n
summary(lmTrain )
# �@��
plot(y~x , main = "���ľ��q�w����¡�Ѽ�", xlab = "�ľ��q", ylab = "�P�_��¡�Ѽ�", family = "STHeiti")
points(x = New_x, y = predicted, col="green", cex = 2, pch = 16)
abline(reg = lmTrain$coefficients, col = "red", lwd = 1) #���ø�s���U�u