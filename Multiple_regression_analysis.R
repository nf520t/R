# �ۦ沣���ľ��q�B�����C��ίv�ɶ��P�P�_��¡�ѼƸ��
x1 <- c(3,3,4,3,6,8,8,9) #�ľ��q
x2 <- c(3,1,6,4,9,10,8,11) #�����C��ίv�ɼ�
y <- c(22,25,18,20,16,9,12,5) #�P�_��¡�Ѽ�
#�s�w�̸��
New_x1 <- 5 #�w����x=5�ɪ���¡�Ѽ�
New_x2 <- 7 #�C��ίv�ɼ�
New_data <- data.frame(x1 = 5, x2=7)
# �إߤ@�ӽu�ʰj�k�ҫ�
Train <- data.frame(x1 = x1, x2=x2, y = y)
lmTrain <- lm(formula = y ~., data = Train)
#�w���s�w�̷P�_��¡�Ѽ�
predicted <- predict(lmTrain , newdata = New_data)
predicted
# �ҫ��K�n
summary(lmTrain )