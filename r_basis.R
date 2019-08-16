### Vector
- R語言最基本的物件

character(5)  ## character vector of length 5
numeric(5)
logical(5)
x = c(1,2,3,7)
y= c(2,3,5,1)
x+y
x*y
x-y
x/y

x = c(1,2,3,7)
x + 10
x + c(10)
x + c(1,2)
x + c(1,2,1,2)

x == c(1,99,3,4)

c(1,2,3)
c(2,T,3+0i,"one")
c(2,T,3+0i)
c(c(1,2,3,4),c(5))

x = c(1,2,3,4,NA)
sum(x)
sum(x, na.rm=T)

x = c(1,2,3,4,NA)
is.na(x)
sum(x[!is.na(x)])

height_vec = c(180,169,173)
height_vec
names(height_vec) = c("Brian", "Toby", "Sherry")
height_vec

name_vec = c("Brian", "Toby", "Sherry")
names(height_vec) = name_vec
height_vec > 175
height_vec / 100
height_vec > 175 | height_vec < 170
height_vec < 175 & height_vec > 170

#R 的index從1開始
height_vec[c(1)] #index
height_vec['Brian'] #element name
height_vec[height_vec > 175] #condition (boolean vector)


##p38 example

h = c(180,169,173)
w = c(73,87,43)
bmi = w / ((h/100)^2)
names(bmi) = c("Brian", "Toby", "Sherry")
bmi < 18.5 | bmi >= 24
bmi[bmi < 18.5 | bmi >= 24]


### seq() & rep() & paste()

1:20
seq(1,20)
20:1
?seq
seq(from=1,to=20,by=2)
seq(from=1,to=20,length=2)

rep(1,5)
?rep
rep(x=c(1,2), times=5)
rep(x=c(1,2), times=c(1,2))
rep(x=c(1,2), each=5)
rep(x=c(1,2), length=5)
rep_len(x=c(1,2),length.out = 5)

paste("the","big","bang","theory")
paste("big","bang",sep="-")
length(paste("the","big","bang","theory"))

paste("big","bang",sep="")
paste("big","bang",sep=";")
paste(c("big","bang"),1:2)
paste(c("big","bang"),1:2,collapse = "+" )
length(paste(c("big","bang"),1:4,collapse = "+" ))


### Matrix

matrix(1:9, byrow=TRUE, nrow=3)
matrix(1:9, nrow=3)
kevin = c(85,73)
marry = c(72,64)
jerry = c(59,66)
mat = matrix(c(kevin, marry, jerry), nrow=3, byrow= TRUE)
colnames(mat) = c('first', 'second')
rownames(mat) = c('kevin', 'marry', 'jerry')
mat

#取得矩陣維度
dim(mat)
#取得矩陣列數
nrow(mat)
#取得矩陣欄數
ncol(mat)
#矩陣轉置(transpose)
t(mat)

#取第一列
mat[1,]
#取第一行
mat[,1]
#取第一、二列
mat[1:2,]

#取kevin和jerry成績
mat[c('kevin','jerry'),]
#取kevin和jerry成績的第一次考試成績
mat[c('kevin','jerry'),'first']

#取得第一次考試成績不及格的人
mat[mat[,1] < 60,'first']


### Matrix(續)

#新增列與行
mat2 = rbind(mat, c(78,63))
rownames(mat2)[nrow(mat2)] = 'sam'
mat2

mat3 = cbind(mat2,c(82,77,70,64))
colnames(mat3)[ncol(mat3)] = 'third'
mat3

rowMeans(mat3)
colMeans(mat3)

# arithmetic
m1 = matrix(1:4, byrow=TRUE, nrow=2)
m2 = matrix(5:8, byrow=TRUE, nrow=2)

m1 + m2
m1 - m2
m1 * m2
m1 / m2

m1 %*% m2


##p54 example

kevin = c(85,73)
marry = c(72,64)
jerry = c(59,66)
mat = matrix(c(kevin, marry, jerry), nrow=3, byrow= TRUE)
colnames(mat) = c('first', 'second')
rownames(mat) = c('kevin', 'marry', 'jerry')

final = mat %*% c(0.4,0.6)
final

cbind(mat,final)
mat2 = cbind(mat,final)
mat2
colnames(mat2)[ncol(mat2)] = 'final'
mat2



#type priority
c("string",1+2i,5.5,TRUE)
c(1+2i,5.5,TRUE)
c(5.5,TRUE)
#as.
as.data.frame(mat)
as.character(1034)
#is.
is.matrix(mat)
is.data.frame(mat)
is.numeric(mat)
is.character(mat)
#is.na
sum(c(1,2,3,NA))
sum(c(1,2,3,NA),na.rm=T)
is.na(c(1,2,3,NA))
c(1,2,3,NA)[is.na(c(1,2,3,NA))]
is.na(c(1,2,3,NA))
!is.na(c(1,2,3,NA))
c(1,2,3,NA)[!is.na(c(1,2,3,NA))]
sum(c(1,2,3,NA)[!is.na(c(1,2,3,NA))])



### Factor

# syntax
weather= c("sunny","rainy", "cloudy", "rainy", "cloudy")
weather_category = factor(weather)
weather_category
class(weather)
class(weather_category)

levels(weather_category)

# order
temperature = c("Low", "High", "High", "Medium", "Low", "Medium")
temperature_category = factor(temperature, order = TRUE, levels = c("Low", "Medium", "High"))
temperature_category
temperature_category[3] > temperature_category[1]
temperature_category[4] > temperature_category[3]

# change levels name
weather= c("s","r", "c", "r", "c")
weather_factor = factor(weather)
levels(weather_factor) = c("cloudy","rainy","sunny")
weather_factor



### Dataframe

name <- c("Joe", "Bob", "Vicky")
age <- c(28, 26, 34)
gender <- c("Male","Male","Female")
df <- data.frame(name, age, gender)
class(df)
str(df)
summary(df)

data(iris)
head(iris)
tail(iris)
tail(iris, 10)
str(iris)

#取前三列資料
iris[1:3,]
#取前三列第一行的資料
iris[1:3,1]
#取前三列Sepal.Length欄位的資料
iris[1:3,"Sepal.Length"]
head(iris[,1:2])
iris$"Sepal.Length"[1:3]

#取前五筆包含length 及 width 的資料
Five.Sepal.iris = iris[1:5, c("Sepal.Length","Sepal.Width")]
#可以用條件做篩選
setosa.data = iris[iris$Species=="setosa",1:5]
str(setosa.data)

#使用which 做資料篩選
which(iris$Species=="setosa")

#用order做資料排序
iris[order(iris$Sepal.Length, decreasing = TRUE),]

sort(iris$Sepal.Length, decreasing = TRUE)

