
# ================================================================
# 1. 泊松分布
# ================================================================
# density function 概率函数
dpois(x, lambda, log = FALSE) # lambda 表示均值, log = TRUE 表示输出log(f(x))
# distribution function 分布函数
ppois(q, lambda, lower.tail = TRUE, log.p = FALSE)
# quantile function 分布函数的逆函数（分位数函数）
qpois(p, lambda, lower.tail = TRUE, log.p = FALSE)
# 泊松分布的随机数 - 模拟
rpois(n, lambda = 10) # 模拟 n 个服从期望为10的泊松分布
# -----------------------------------------------------------------
# 画图- 不同lambda的泊松分布的概率函数图
# -----------------------------------------------------------------
par(mfrow = c(2,2))
lambda.po <- c(1, 2, 5, 10) # lambda 取值为 1,2,5,10
x0 <- seq(0, 20)            # x 取值为 0-25 的整数
for(lambda.po in c(1, 2, 5, 10)){
  barplot(dpois(x0, lambda.po), names.arg = x0, main = paste('lambda = ', lambda.po, sep = ''))
}

## 索赔次数等于3的概率
dpois(3, lambda = 2)
## 索赔次数小于等于4的概率为
ppois(4, lambda = 2)
## 索赔次数大于等于3小于等于5的概率
ppois(5, 2) - ppois(2, 2)

## 模拟20个索赔次数观察值
set.seed(111) # 设定随机种子
sim = rpois(n = 20, lambda = 2) # 模拟生成20个服从lambda=2的泊松分布的随机数量
sim
## 对模拟的索赔次数进行列表
table(sim)


# ================================================================
# 2. 负二项分布
# ================================================================
# 参数 size = r
# 参数 prob = p
dnbinom(x, size, prob, mu, log = FALSE)
pnbinom(q, size, prob, mu, lower.tail = TRUE, log.p = FALSE)
qnbinom(p, size, prob, mu, lower.tail = TRUE, log.p = FALSE)
rnbinom(n, size, prob, mu)

# 负二项分布的概率函数
x <- 0:20
par(mfrow = c(2, 2))
for (r in c(1, 2, 3, 4)){
  barplot(dnbinom(x, size = r, prob = 0.3), 
          main = paste0('r = ', r, ',  ','p = ', 0.3), names.arg = x)
}

# -----------------------------------------------------------------
# 例： 零截断负二项分布的计算
# -----------------------------------------------------------------
## 负二项分布的概率
x = 0:10
p = dnbinom(x, 4, 0.7)
round(p,3)
## 零截断负二项分布的概率
p0 = p[1]   
## 零点的概率
pt1 = p[2:11]/(1-p0)  
## 其它点上的概率
pt = c(0, pt1)
round(pt, 3)
## 绘图比较负二项和零截断负二项的概率
com = rbind(负二项 = p, 零截断负二项 = pt)
par(mfrow = c(1, 1))
barplot(com, beside = TRUE, names.arg = 0:10,legend.text = TRUE)

# -----------------------------------------------------------------
# 例： 零调整负二项分布的计算
# -----------------------------------------------------------------
## 负二项分布的概率
x = 0:10
p = dnbinom(x, 4, 0.7)
round(p,3)
## 零调整负二项分布的概率
p0 = 0.3  
## 调整零点的概率
pm = (1 - p0)*p[2:11]/(1 - p[1])  
## 其它点上的概率
pm = c(p0, pm)
round(pm, 3)
## 绘图
com = rbind(负二项 = p, 零调整负二项 = pm)
barplot(com, beside = TRUE, names.arg = 0:10, legend.text = TRUE)




# ================================================================
# 二项分布
# ================================================================
# 参数 size = n
# 参数 prob = q
dbinom(x, size, prob, log = FALSE)
pbinom(q, size, prob, lower.tail = TRUE, log.p = FALSE)
qbinom(p, size, prob, lower.tail = TRUE, log.p = FALSE)
rbinom(n, size, prob)

# 画图 
n <- c(1, 5, 10, 20)
q0 <- 0.3
x0 <- seq(0, 15)

par(mfrow = c(2, 2) )
for (i in 1:length(n)){
  fpo <- dbinom(x0, size = n[i], prob = q0, log = FALSE)
  barplot(fpo, 
          main = paste0('m = ', n[i], ',  ','q = ', q0),
          names.arg = x0)
}

# ================================================================
# 例： 假设损失次数观察值来自两类保单，一类保单的损失次数服从参数为2的泊松分布，另一类保单的损失次数服从参数为(1, 1/5)的负二项分布。在保单组合中，第一类保单占40%，第二类保单占60%，请求保单组合的损失次数分布。
# 泊松分布与负二项分布混合后的概率函数
# ================================================================
f = function(x)   0.4 * dpois(x, 2) + 0.6 * dnbinom(x, 1, 1/5)
## 绘图
x = 0:20
barplot(f(x), names.arg = x)


# ================================================================
# 泊松-逆高斯分布的概率
# ================================================================
# 泊松参数为lambda =1.2，逆高斯分布均值为1，tao = 0.5，请计算泊松-逆高斯分布的概率。

lam = 1.2
tao = 0.5
f = function(theta) exp(-lam * theta) * (lam * theta)^k/gamma(k + 1) * exp(-(theta - 1)^2/2/tao/theta)/sqrt(2 * pi * theta^3 * tao)
p = NULL
i = 0
for (k in 0:20) {
  i = i + 1
  p[i] = integrate(f, 0, Inf)$value
}
p
sum(p)

# ================================================================
# 泊松-对数正态分布的概率
# ================================================================
# 泊松参数为lambda = 1.2，对数正态分布的均值为1，sigma = 0.5，请计算泊松-对数正态分布的概率。
lam = 1.2
sig = 0.5
f = function(x) exp(-lam * x) * (lam * x)^k/gamma(k + 1) * dlnorm(x, meanlog = -sig^2, sdlog = sig^2)
p = NULL
i = 0
for (k in 0:10) {
  i = i + 1
  p[i] = integrate(f, 0, Inf)$value
}
p
sum(p)

# ================================================================
# 复合泊松分布的递推公式（1） - (a, b, 0)
# ================================================================
COMPO = function (lam, f0, f) {
  cum = g = exp(lam*(f0 - 1)) 
  k = 0 # 循环标识
  repeat {
    k = k + 1
    last = lam / k * sum(1:k * head(f, k) * rev(g))
    g = c(g, last)
    cum = cum + last
    if (cum > 0.9999999) break  
  }
  return(g) 
}
#负二项分布的概率函数\
f0 = dnbinom(0, size = 4, prob = 0.3)     #零点的概率
f = dnbinom(1:500, size = 4, prob = 0.3)  #1:500的概率
#泊松-负二项分布的概率
g = COMPO(lam = 2, f0, f) 
plot(0:(length(g)-1), g, type = 'h', col = 2, xlim = c(0, 50))

# 应用actuar程序包
library(actuar)
par(mfrow = c(1, 3))
sev = dnbinom(0:500, size = 4, prob = 0.3)
Fs1 = aggregateDist(method = "recursive", model.freq = "poisson", model.sev = sev, lambda = 2)
plot(0:10, dpois(0:10, 2), type = "h", col = 2, xlab = "", ylab = "", main = "poisson")
plot(0:50, dnbinom(0:50, size = 4, prob = 0.3), type = "h", col = 2, xlab = "",  ylab = "", main = "negative binomial")
plot(diff(Fs1), type = "h", col = 2, xlab = "", ylab = "", xlim = c(0, 50), main = "poisson-negative binomial")




