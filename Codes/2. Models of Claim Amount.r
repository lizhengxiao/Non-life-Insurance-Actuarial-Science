
# ==========================================
# 指数分布
# ===========================================
theta <- c(0.5, 1, 2)
x0 <- seq(0.001, 10, length.out = 100)
par(mfrow = c(1, 1) )
f1 <- dexp(x0, rate = theta[1], log = FALSE)
f2 <- dexp(x0, rate = theta[2], log = FALSE)
f3 <- dexp(x0, rate = theta[3], log = FALSE)

matplot(x0, cbind(f1, f2, f3), type = 'l', lty = 1:3, lwd = 2, ylim = c(0, 1), ylab = '密度函数')
legend('topright', legend = c('theta = 0.5', 'theta = 1', 'theta = 2'),
       lty = c(1,2,3), bty = "n", lwd = 2,  col = 1:3)

# ==========================================
# 伽马分布
# ===========================================
par(mfrow = c(1, 2) )
# 固定形状参数
alpha <- 2                # 形状参数
theta <- c(0.5, 1, 2)     # 比率参数，尺度参数为 1/theta
x0 <- seq(0.001, 15, length.out = 100)
f1 <- dgamma(x0,  shape = alpha, rate = theta[1]) # 
f2 <- dgamma(x0,  shape = alpha, rate = theta[2])
f3 <- dgamma(x0,  shape = alpha, rate = theta[3])
matplot(x0, cbind(f1, f2, f3),ylim = c(0,0.8), main = '',  type = 'l', lty = 1:3, lwd = 2, ylab = '密度函数')
legend('topright', legend = c('alpha = 2, theta = 0.5', 
                              'alpha = 2, theta = 1', 
                              'alpha = 2, theta = 2'),
       lty = c(1,2,3), bty = "n", lwd = 2,  col = 1:3)

# 固定比率参数
alpha <- c(1,2,3)
theta <- 0.5
x0 <- seq(0.001, 15, length.out = 100)
f1 <- dgamma(x0,  shape = alpha[1], rate = theta)
f2 <- dgamma(x0,  shape = alpha[2], rate = theta)
f3 <- dgamma(x0,  shape = alpha[3], rate = theta)

matplot(x0, cbind(f1, f2, f3),ylim = c(0,0.8), main = '',  type = 'l', lty = 1:3, lwd = 2, ylab = '密度函数')
legend('topright',legend = c('alpha = 1, theta = 0.5', 
                                     'alpha = 2, theta = 0.5', 
                                     'alpha = 3, theta = 0.5'),
       lty = c(1,2,3), bty = "n", lwd = 2,  col = 1:3)


# ==========================================
# 逆高斯分布
# ===========================================
par(mfrow = c(1, 1))
x = seq(0, 4, 0.01)
f1 = sqrt(0.5/(2*pi*x^3))*exp(-0.5*(x-1)^2/(2*1^2*x))
f2 = sqrt(1/(2*pi*x^3))*exp(-1*(x-1)^2/(2*1^2*x))
f3 = sqrt(5/(2*pi*x^3))*exp(-5*(x-1)^2/(2*1^2*x))
f4 = sqrt(10/(2*pi*x^3))*exp(-10*(x-1)^2/(2*1^2*x))
matplot(x, cbind(f1, f2, f3, f4), type = 'l', lty = 1:4, lwd = 2)
legend(2, 1, c('IG(1, 0.5)', 'IG(1, 1)', 'IG(1, 5)', 'IG(1, 10)'), lty=1:4, col=1:4, lwd=c(3, 3, 3, 3))

# 还有一种方法
# 定义逆高斯分布的密度函数 fig
dig <- function(y, alpha, theta, ... ){
  fx <- alpha/(2*pi*theta*y^3)^0.5*exp(-(alpha - theta*y)^2/(2*theta*y))
  return(fx)
}

par(mfrow = c(1, 2) )
# 固定 alpha 
alpha <- 2                
theta <- c(0.5, 1, 2)     
x0 <- seq(0.001, 15, length.out = 100)
f1 <- dig(x0,  alpha = alpha, theta = theta[1])
f2 <- dig(x0,  alpha = alpha, theta = theta[2])
f3 <- dig(x0,  alpha = alpha, theta = theta[3])
matplot(x0, cbind(f1, f2, f3), main = '',  type = 'l', lty = 1:3, lwd = 2, ylab = '密度函数')
legend('topright',legend = c('alpha = 2, theta = 0.5', 
                              'alpha = 2, theta = 1', 
                              'alpha = 2, theta = 2'),
       lty = c(1,2,3), bty = "n", lwd = 2,  col = 1:3)

# 固定 theta
alpha <- c(1,2,3)
theta <- 0.5
x0 <- seq(0.001, 15, length.out = 100)
f1 <- dig(x0,  alpha = alpha[1], theta = theta)
f2 <- dig(x0,  alpha = alpha[2], theta = theta)
f3 <- dig(x0,  alpha = alpha[3], theta = theta)
matplot(x0, cbind(f1, f2, f3), main = '',  type = 'l', lty = 1:3, lwd = 2, ylab = '密度函数')
legend('topright',       legend = c('alpha = 1, theta = 0.5', 
                                    'alpha = 2, theta = 0.5', 
                                    'alpha = 3, theta = 0.5'),
       lty = c(1,2,3), bty = "n", lwd = 2,  col = 1:3)

# ==========================================
# 对数正态分布
# ===========================================
# 密度函数
dlnorm

par(mfrow = c(1, 2) )
# 固定 mu 
mu <- 2                
sigma <- c(0.5, 1, 2)     
x0 <- seq(0.001, 15, length.out = 100)
f1 <- dlnorm(x0,  meanlog = mu, sdlog = sigma[1])
f2 <- dlnorm(x0,  meanlog = mu, sdlog = sigma[2])
f3 <- dlnorm(x0,  meanlog = mu, sdlog = sigma[3])

matplot(x0, cbind(f1, f2, f3), main = '',  type = 'l', lty = 1:3, lwd = 2, ylab = '密度函数')
legend('topright',legend = c('mu = 2, sigma = 0.5', 
                             'mu = 2, sigma = 1', 
                             'mu = 2, sigma = 2'),
       lty = c(1,2,3), bty = "n", lwd = 2,  col = 1:3)

# 固定 sigma
mu <- c(1,2,3)
sigma <- 1
x0 <- seq(0.001, 15, length.out = 100)
f1 <- dlnorm(x0,  meanlog = mu[1], sdlog = sigma)
f2 <- dlnorm(x0,  meanlog = mu[2], sdlog = sigma)
f3 <- dlnorm(x0,  meanlog = mu[3], sdlog = sigma)

matplot(x0, cbind(f1, f2, f3), main = '',  type = 'l', lty = 1:3, lwd = 2, ylab = '密度函数')
legend('topright',       legend = c('mu = 1, sigma = 1', 
                                    'mu = 2, sigma = 1', 
                                    'mu = 3, sigma = 1'),
       lty = c(1,2,3), bty = "n", lwd = 2,  col = 1:3)


# ==========================================
# 帕累托分布
# ===========================================
dpareto <- function(y, alpha, theta){
  f <- alpha*(theta^alpha)/(y+theta)^(alpha+1)
  return(f)
}

par(mfrow = c(1, 2) )
# 固定 alpha 
alpha <- 2                
theta <- c(0.5, 1, 2)     
x0 <- seq(0.001, 5, length.out = 100)
f1 <- dpareto(x0,  alpha = alpha, theta = theta[1])
f2 <- dpareto(x0,  alpha = alpha, theta = theta[2])
f3 <- dpareto(x0,  alpha = alpha, theta = theta[3])
matplot(x0, cbind(f1, f2, f3), main = '',  type = 'l', lty = 1:3, lwd = 2, ylab = '密度函数', ylim = c(0,0.6))
legend('topright', legend = c('alpha = 2, theta = 0.5', 
                              'alpha = 2, theta = 1', 
                              'alpha = 2, theta = 2'),
       lty = c(1,2,3), bty = "n", lwd = 2,  col = 1:3)
# 固定 theta
alpha <- c(1,2,3)
theta <- 0.5
x0 <- seq(0.001, 5, length.out = 100)
f1 <- dpareto(x0,  alpha = alpha[1], theta = theta)
f2 <- dpareto(x0,  alpha = alpha[2], theta = theta)
f3 <- dpareto(x0,  alpha = alpha[3], theta = theta)
matplot(x0, cbind(f1, f2, f3), main = '',  type = 'l', lty = 1:3, lwd = 2, ylab = '密度函数', ylim = c(0,0.6))
legend('topright', legend = c('alpha = 1, theta = 0.5', 
                              'alpha = 2, theta = 0.5', 
                              'alpha = 3, theta = 0.5'),
       lty = c(1,2,3), bty = "n", lwd = 2,  col = 1:3)


# ==========================================
# 威布尔分布
# ===========================================
# 定义密度函数
dwei <- function(y, alpha, theta){
  f <- alpha*theta*y^(theta-1)*exp(-alpha*y^theta)
  return(f)
}

par(mfrow = c(1, 2) )
# 固定 alpha 
alpha <- 1                
theta <- c(0.5, 1, 2)     
x0 <- seq(0.001, 5, length.out = 100)

f1 <- dwei(x0,  alpha = alpha, theta = theta[1])
f2 <- dwei(x0,  alpha = alpha, theta = theta[2])
f3 <- dwei(x0,  alpha = alpha, theta = theta[3])
matplot(x0, cbind(f1, f2, f3), main = '',  type = 'l', lty = 1:3, lwd = 2, ylab = '密度函数', ylim = c(0,1))
legend('topright', legend = c('alpha = 1, theta = 0.5', 
                              'alpha = 1, theta = 1', 
                              'alpha = 1, theta = 2'),
       lty = c(1,2,3), bty = "n", col = 1:3)

# 固定 theta
alpha <- c(1,2,3)
theta <- 0.5
x0 <- seq(0.001, 5, length.out = 100)
f1 <- dwei(x0,  alpha = alpha[1], theta = theta)
f2 <- dwei(x0,  alpha = alpha[2], theta = theta)
f3 <- dwei(x0,  alpha = alpha[3], theta = theta)
matplot(x0, cbind(f1, f2, f3), main = '',  type = 'l', lty = 1:3, lwd = 2, ylab = '密度函数', ylim = c(0,1))
legend('topright', legend = c('alpha = 1, theta = 0.5', 
                              'alpha = 2, theta = 0.5', 
                              'alpha = 3, theta = 0.5'),
       lty = c(1,2,3), bty = "n", col = 1:3)

# theta = 3.6
par(mfrow = c(1, 1))
x0 <- seq(0.001, 5, length.out = 100)
f0 <- dwei(x0,  alpha = 0.1, theta = 3.6)
plot(x0, f0, type = 'l', col = 2, lwd = 3)
legend('topright', legend = c('alpha = 0.1, theta = 3.6'), 
       lwd = 3, bty = "n", col = 2)
# -----------------------------------------------------------------------------------
# 假设X服从参数为 (3,  4) 的伽马分布, 求g(X)的分布。
# -----------------------------------------------------------------------------------
# 伽马分布的密度函数
par(mfrow = c(1, 1))
f = function(x)  dgamma(x,  3,  4)
### 指数变换,  Y = exp(X)
f1 = function(x)   f(log(x))/x
### 对数变换,   Y = log(X)
f2 = function(x)    f(exp(x)) * exp(x)
x <- seq(0, 4, 0.01)
matplot(x, cbind(f(x), f1(x), f2(x)), type='l', lty=1:3, lwd=2)
legend('topright', c('X','exp(X)','log(X)'), lty=1:3, col=1:3, lwd=2)


# -----------------------------------------------------------------------------------
# 例： 两个对数正态分布的参数分别为(1, 2)和(3, 4), 如果按照30%和70%的比例把它们进行混合, 求混合分布的密度函数。
# -----------------------------------------------------------------------------------
p = 0.3
m1 = 1; s1 = 2
m2 = 3; s2 = 4
## 混合对数正态分布的密度函数
f = function(x)  p * dlnorm(x,  m1,  s1) + (1 - p) * dlnorm(x,  m2,  s2)
curve(f,  xlim = c(0,  1),  ylim = c(0,  2),   lwd = 2,  col = 2, main = '混合对数正态分布')
curve(dlnorm(x,  m1,  s1),  lty = 2,  add = TRUE)
curve(dlnorm(x,  m2,  s2),  lty = 3,  add = TRUE)
legend("topright",  c("mixed lnorm",  "lnorm(1, 2)",  "lnorm(3, 4)"),  lty = c(1,  2,  3),  col = c(2,  1,  1),  lwd = c(2,  1,  1))


# -----------------------------------------------------------------------------------
# 混合指数分布
# -----------------------------------------------------------------------------------
x = seq(0,  10,  0.01)
y1 = 1-pexp(x,  rate = 2)
y2 = 1-pexp(x,  rate = 3)
q = 0.7
y = q*y1 + (1 - q)* y2
matplot(x,  cbind(y1,  y2,  y),  lty=c(2,3,1),type = 'l',  col=c(1,2,4), xlim = c(0,  3), lwd=2, main = '生存函数')
legend('topright',  c('指数（rate = 2）', '指数（rate = 3）',  '混合指数（q = 0.7）'),  lty=c(2,3,1), col=c(1,2,4))


# -----------------------------------------------------------------------------------
# 各种估计方法的比较
# -----------------------------------------------------------------------------------
# 模拟伽马分布的随机数
set.seed(123)
x = rgamma(50, 2)  
# 调用fitdistrplus程序包
library(fitdistrplus)  
# 用极大似然法估计参数
fit1 = fitdist(x,  'gamma',  method = 'mle')  
# 用矩估计法估计参数
fit2 = fitdist(x, 'gamma', method = 'mme')  
# 用分位数配比法估计参数
fit3 = fitdist(x, 'gamma', method = 'qme', probs = c(1/3, 2/3))  
#用最小距离法估计参数
fit4 = fitdist(x, 'gamma', method = 'mge', gof = 'CvM')  
#输出参数估计结果
fit1  
plot(fit1)

# -----------------------------------------------------------------------------------
# 案例分析
# ------------------------------------------------------------------------------------------------
# 调用程序包CASdatasets中的数据集freMTPLsev, 应用适当的模型拟合ClaimAmount的分布。
# 准备包
library(CASdatasets)
library(fitdistrplus) # 用于参数估计 - fitdist
#准备数据
data(freMTPLsev)  
x <- dt$ClaimAmount
summary(x)
quantile(x, 90:100/100)
x <- x[x<=100000]
hist(x, breaks = 100000, xlim = c(0, 10000))

#------------把索赔金额x分段---------------
c1 = 400; c2 = 1000; c3 = 1300; c4 = 5000
index1 <- which(x<=c1)
index2 <- which(x>c1 & x<=c2)
index3 <- which(x>c2 & x<=c3)
index4 <- which(x>c3 & x<=c4)
index5 <- which(x>c4)
#对数正态分布拟合
fit1 = fitdist(x[index1], 'lnorm')
fit2 = fitdist(x[index2], 'lnorm')
fit3 = fitdist(x[index3], 'lnorm')
fit4 = fitdist(x[index4], 'lnorm')
##右尾用帕累托分布拟合
dpareto = function(x, alpha) alpha*c4^alpha/x^(alpha + 1) 
ppareto = function(x, alpha) 1 - (c4/x)^alpha
fit5 = fitdist(x[index5], 'pareto', start = list(alpha = 1), method = 'mle')  #帕累托从c3以后有定义

hist(x[index5], freq = F)
curve(dpareto(x, fit5$estimate[1]), add = T)

#------------得到经验分布的估计参数-----------
m1 <- fit1$estimate[1]
s1 <- fit1$estimate[2]
m2 <- fit2$estimate[1]
s2 <- fit2$estimate[2]
m3 <- fit3$estimate[1]
s3 <- fit3$estimate[2]
m4 <- fit4$estimate[1]
s4 <- fit4$estimate[2]
m5 <- fit5$estimate[1]


#######使用分段拟合的权重
w1 = length(index1)/length(x)
w2 = length(index2)/length(x)
w3 = length(index3)/length(x)
w4 = length(index4)/length(x)
w5 = length(index5)/length(x)

f = function(x) {
  ifelse(x <= c1, w1*dlnorm(x, m1, s1)/(plnorm(c1, m1, s1)),
         ifelse(x > c1 & x <= c2, w2*dlnorm(x, m2, s2)/(plnorm(c2, m2, s2) - plnorm(c1, m2, s2)), 
                ifelse(x > c2 & x<= c3, w3*dlnorm(x, m3, s3)/(plnorm(c3, m3, s3) - plnorm(c2, m3, s3)),
                       ifelse(x > c3 & x<= c4, w4*dlnorm(x, m4, s4)/(plnorm(c4, m4, s4) - plnorm(c3, m4, s4)),
                              w5*dpareto(x, m5)))))
}  

hist(x, breaks = 5000, xlim = c(0, 6000), prob = TRUE,  main = "",  xlab = "索赔额", col='grey')
curve(f, xlim = c(0, 6000), add = T,  col=2,  lwd = 2)
# ==================================================
# 指数分布和帕累托分布的平均超额函数
# ==================================================
# 指数分布的生存函数
S <- function(x) exp(-2*x)
# 指数分布的平均超额函数 ex1
ex1 <- NULL
d1 <- seq(0.1, 5, 0.1) # 免赔额
for(i in 1:length(d1)){
  ex1[i] <- integrate(S, d1[i], Inf)$value/S(d1[i])
}

# 帕累托分布的生存函数
alpha <- 5
theta <- 100
S <- function(x) {
  (theta/(x + theta))^alpha
}
# 帕累托分布的平均超额函数 ex2
ex2 <- NULL
d2 <- seq(0.1, 500, 1) # 免赔额
for(i in 1:length(d2)){
  ex2[i] <- integrate(S, d2[i], Inf)$value/S(d2[i])
}

# 绘图
par(mfrow = c(1, 2))
plot(d1, ex1, type = 'l', ylab = '指数分布的平均超额损失', ylim = c(0,1))
plot(d2, ex2, type = 'l', ylab = '帕累托分布的平均超额损失')




# -----------------------------------------------------------------------------------
# 课堂练习:对于gamma分布（shape=2,scale=100)绘图：
# 止损保费和平均超额损失随着免赔额增加而变化的曲线图
# 有限期望值随着限额变化而变化的曲线图
# 把上述分布改为pareto(shape=2,scale=200)和指数分布(rate=1/200)。
# 注：上述三个分布的均值相等，均为200
# ------------------------------------------------------------------------------------------------







