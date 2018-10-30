# =============================================================================
# 一、集体风险模型
# ============================================================================

# =============================================================================
# 解析法：计算卷积
# ============================================================================
library(actuar)
pn = c(0.3, 0.5, 0.2)              #损失次数的概率分布
fx = c(0.2, 0.4, 0.2, 0.1, 0.1)    #损失金额的概率分布
Fc = aggregateDist("convolution", model.freq = pn, model.sev = fx, x.scale = 100)
plot(Fc)

#累积损失的概率
diff(Fc) # 譬如，累积损失等于0的概率为0.408，累积损失等于800的概率为0.02。
S <- seq(from = 0, to = 800, by = 100)
cbind(S, diff(Fc))

# =============================================================================
# 递推法
# ============================================================================
# 连续型分布离散化
# 1. rouding and mathcing method (公式计算)
x = 1:30;
y1 = exp(-0.1*(2*x - 1)) - exp(-0.1*(2*x + 1))
y2 = -10*exp(-0.2*x) + 5*exp(-0.2*(x-1))+5*exp(-0.2*(x+1))
y_rounding = c(0.09516, y1)  # rounding (h = 2), 0.09516 为零点的概率
y_matching = c(0.09365, y2)  # mathcing (h = 2)
par(mfrow = c(1,2))
matplot(c(0, x), cbind(y_rounding, y_matching), type = 'h', xlab = 'i', ylab = 'fi', col = c(2,4), lwd = 2)
plot(y_rounding, y_matching)
abline(0,1)

# 2. rouding and mathcing method (运用 discretize 函数)
y_rounding2 <- discretize(cdf = pexp(x, rate = 0.1), from = 0, to = 60, step = 2, method = "rounding")
y_rounding2
par(mfrow = c(1,1))
plot(y_rounding[1:30], y_rounding2[1:30]) # 两种方法求得的结果是一样的

# 3. 连续型分布 VS 离散型分布
par(mfrow = c(1,1))
x <- seq(0, 50, 2)
curve(pexp(x, rate = 0.1), xlim = c(0, 50), type = 'l', ylim = c(0, 1),
     ylab = '指数分布的累积分布函数')
fr <- discretize(pexp(x, rate = 0.1), from = 0, to = 50, step = 2, method = "rounding")                              # 离散化分布后的概率函数
fu <- discretize(pexp(x, rate = 0.1), from = 0, to = 50, step = 2, method = "unbiased", lev = levexp(x, rate = 0.1)) # 离散化分布后的概率函数

plot(stepfun(head(x, -1), diffinv(fr)), pch = 18,
     add = TRUE,
     col = 'red')
plot(stepfun(x, diffinv(fu)), pch = 18,
     add = TRUE,
     col = 'blue')
legend(30, 0.4, 
       legend = c("连续分布", "Rounding", "Unbiased"),
       col = c('black', "red", "blue"), 
       pch = 19, lty = 1)

# 4. 各种离散化结果的比较
library(actuar)
fu <- discretize(cdf = pexp(x, rate = 0.1), 
                 method = 'upper', 
                 from = 0, to = 50, step = 2) # 向上离散化
fl <- discretize(cdf = pexp(x, rate = 0.1), 
                 method = 'lower', 
                 from = 0, to = 50, step = 2) # 向下离散化
fr <- discretize(cdf = pexp(x, rate = 0.1), 
                 method = 'rounding', 
                 from = 0, to = 50, step = 2) # 折中离散化

par(col = "blue")
x <- seq(0, 50, 2)
curve(pexp(x, rate = 0.1), xlim = c(0, 50),
      ylab = '指数分布分布函数')
plot(stepfun(head(x, -1), diffinv(fu)), pch = 19, 
     col = "red",
     add = TRUE)
plot(stepfun(x, diffinv(fl)), pch = 18,
     add = TRUE,
     col = 'blue'
)
plot(stepfun(head(x,-1), diffinv(fr)), pch = 17,
     add = TRUE,
     col = 'yellow'
)
legend(30, 0.4, 
       legend = c("Upper", "Lower", "Rounding"),
       col = c("red", "blue", "yellow"), 
       pch = 19, lty = 1)



# 4. 递推法 (aggregateDist函数)
# 首先对指数分布进行离散化得到强度分布，频数分布选用 poisson 分布, 特别
# 指定poisson 分布参数 lambda = 2。
x <- seq(0, 50, 0.1)
fx <- discretize(pexp(x, 1), from = 0, to = 100, method = "rounding")
Fs <- aggregateDist(method = "recursive", model.freq = "poisson",
                    model.sev = fx, lambda = 2)
par(mfrow = c(1,1))
plot(Fs)


# =============================================================================
# 递推法：作业 (自定义函数)
# ============================================================================
# 对 pareto 离散化后，求复合分布S
dpareto <- function(x) {
  L = 4 * (10^4)/((x + 10)^(4 + 1))
  return(L)
  }
ppareto <- function(x) {
  L = 1 - (10/(x + 10))^4
  return(L)
  }
v = 1 - ppareto(6)
lambda = 3 * v
Yp <- function(y) {
  if (y < 13.5)
    L = 1 - (1 - ppareto(y/0.75 + 6))/v else L = 1
    return(L)
}
# pareto分布的离散化
h = 2.25
f = Yp(h/2)
k = 0
repeat {
  k = k + 1
  last = Yp((k + 0.5) * h) - Yp((k - 0.5) * h)
  f = c(f, last)
  if (sum(f) >= 0.99) 
  break
  }
# 递推公式求S
g = exp(-lambda * (1 - f[1]))
k = 0
repeat {
  k = k + 1
  summ = 0
  if (k < length(f)) 
    upper = k else upper = length(f) - 1
  for (j in 1:upper) {
    summ = summ + j * f[j + 1] * g[k - j + 1]
    }
  g = c(g, summ * lambda/k)
  if (sum(g) > 0.999999) 
    break
  }
sum(g)
## [1] 0.9999995
g
plot(g, type = 'h', lwd = 2, xlab = '0:(k)')


# =============================================================================
# 随机模拟（Simluation）
# ============================================================================
lam = 3                   #泊松参数
mu = 6; sigma = 1.5       #对数正态分布的参数
u = 1000
s = n = NULL
for ( i in 1:10000) {
  n[i] = rpois(1, lambda = lam)
  s[i] = sum(pmin(rlnorm(n[i], meanlog = mu, sdlog = sigma), u))
  s[i] = round(s[i])
}
par(mfrow = c(1, 2))
hist(s, freq = F, breaks = 1000, col = 2, main = '')
s = sort(s)
plot(s, cumsum(s)/sum(s), type = 's', col = 2)

# =========================================================================
# 例~2.7 随机模拟求累积损失的分布
# =========================================================================
set.seed(321) # 设定随机种子
iter <- 10000 # 模拟次数
d <- 250; u <- 1000 # 免赔额和限额
r <- 3; beta <- 2 # 负二项分布的参数
alpha <- 100; theta <- 0.2 # 伽马分布的参数
P <- NULL # 保险人的年度累积赔款

# 开始模拟
for (i in 1:iter){
  n <- rnbinom(1, size = r, mu = r*beta)  # 模拟损失次数
  x <- rgamma(n, shape = alpha, rate = theta) # 模拟每次事故的损失额，x 是一个向量
  w <- pmin(x, d)  # 保单持有人对每次损失的自负金额
  v <- min(sum(w), u) # 保单持有人自负的总金额\
  S <- sum(x)   # 保单持有人的总损失
  P[i] <- S - v # 保单持有人的年度累积赔款
}

hist(P, breaks = 50, col = 'grey', prob = T, main = '',
     ylab = '频率', xlab = '累积赔款'
)
mean(P);quantile(P, 0.95)





# =============================================================================
# 二、个体风险模型
# ============================================================================
# =======================================
# 1. 二项分布和泊松分布(精确分布)
# =======================================
q <- 0.001
n <- 1000
# 总赔款 S 服从二项分布(1000,0.001)，也可以近似服从lambda = 1的泊松分布
# P(S>=3.5)的概率为
1 - pbinom(3.5, 1000, 0.001)
ps1 <- 1 - ppois(3.5, 1)
ps1
# =======================================
# 2. 正态近似
# =======================================
# 根据矩估计得到正态分布的两个参数 mu 和 sigma
mu <- 1
sigma2 <- 0.999
ps2 <- 1 - pnorm(3.5, mean = mu, sd = sqrt(sigma2))
ps2

# =======================================
# 3. 对数正态近似
# =======================================
# 根据矩估计得到对数正态分布的两个参数 mu 和 sigma
mu <- -0.34657
sigma <- 0.83256
ps3 <- 1 - plnorm(3.5, mu, sigma)
ps3
# =======================================
# 4. 平移伽马近似
# =======================================
# 根据矩估计得到平移伽马分布的三个参数 x0 alpha beta
x0 <- -1
alpha <- 4 
beta <- 2
# S + 1 服从参数为 (4,2) 的伽马分布
ps4 <- 1 - pgamma(4.5, shape = 4, rate = 2)
ps4
# =======================================
# 5. NP 近似
# =======================================
# 泊松分布的均值、方差、偏度系数为 1
mu <- sigma <- gamma <- 1
a <- - 3/gamma + sqrt(9/gamma^2 + 1 + 6/gamma * (3.5 - mu)/ sigma)
ps5 <- 1 - pnorm(a)
# =======================================
# 6. 比较结果
# =======================================
dt <- data.frame(rbind(ps2, ps3, ps5, ps4))
rownames(dt) <- c('Normal', 'Lognormal', 'Normal power', 'Translated gamma')
colnames(dt) <- '精确值＝0.0190'
dt$Error <- rbind(ps2, ps3, ps5, ps4) - ps1
round(dt, 4)




# -----------------------------------------------------------------------------------
# tweedie 分布
# ------------------------------------------------------------------------------------------------
# 泊松-伽马复合分布
lambda = 1                         # 泊松的参数
alpha = 10  ;   beta = 2      # 伽马分布的参数，beta为rate参数
n = 10000                            # 模拟次数
Y = NULL                              # tweedie模拟值
set.seed(11)
for ( i in 1:n) {
  N = rpois(1,  lambda)
  Y[i] = sum(rgamma(N, shape =  alpha,  rate = beta))
}
hist(Y,  breaks = 50,  col = 'grey',  main = 'Tweedie模拟')


# -----------------------------------------------------------------------------------
# tweedie 分布
# ------------------------------------------------------------------------------------------------
library(tweedie)
# 泊松分布参数
lambda <- 1
# 伽马分布参数
shape <- 10
scale <- 1/2
# 计算 tweedie 分布的参数
mu <- lambda*shape*scale
power <- (shape + 2)/(shape + 1)
phi <- lambda^(1 - power)*(shape * scale)^(2 - power)/(2 - power)
# 输出 tweedie 分布的参数
cbind(mu, power, phi)
# 计算 tweedie 分布在零点的概率
dtweedie(0, power = power, mu = mu, phi = phi)
# 绘制 tweedie 分布的密度函数图
y <- seq(0, 1000, 0.1)
fy <- dtweedie(y = y, power = power, mu = mu, phi = phi)
plot(y, fy, type = 'l', xlim = c(0, 30), lwd = 2, col = 2)
