
# =================================================================
# 1. 最小二乘法(加法模型)
# =================================================================
area <- c('A','B','C','A','B',	'C','A','B','C') # 地区变量的不同水平
type <- rep(1:3, each = 3)                       # 车型变量的不同水平
area.f <- factor(area, levels = c('A','B','C')) # 转化为 factor，基础类别为 A
type.f <- factor(type, levels = c(2, 3, 1))     # 转化为 factor，基础类别为 2

claim <- c(8400,7020,3600,17340,7200,4590,825,1140,	2640) # 各风险类别的经验赔款
n <- c(80,	52,20,136,	60,24,4,8,	16)                   # 各风险类别的风险单位数
premium <- claim/n                                        # 各风险类别的经验纯保费
dt <- data.frame(area, type, area.f, type.f, n, claim, premium)           # 最终的数据集
dt
X <- model.matrix( ~ area.f + type.f, data = dt)  # 构建设计矩阵
X
# ===================================================
# 定义损失函数Q (loss function)
# ===================================================
loss.f <- function(par, X, y, n, index = 1){
  # y 经验纯保费
  # n 风险单位数
  # X 为设计矩阵
  # par 为待估计参数，如 mu, alpha_i, beta_j
  muij <- X%*%par
  Qij <- (n)^(index)*(y - muij)^2   # 损失函数
  Q <- sum(Qij)                     # 损失函数求和
  return(Q)
}
starts <- (rep(1, length = ncol(X)))  # 初始值
# 运用 optim 函数进行最优化（迭代算法）
m0 <- optim(par = starts,  # 参数的初始值
            fn = loss.f,   # 损失函数（优化的目标函数）
            y = dt$premium, # 数据
            X = X,          # 设计矩阵
            n = dt$n,
            index = 1,
            method = "CG", hessian = T)
# 显示参数估计值
m0
m0$par

# ===========================================================
# 或者直接运用 lm 函数，进行线性回归模型的预测和构建
# weight = n
# ===========================================================
m1 <- lm(premium ~ area.f + type.f, data = dt, weights = n)
y.fit <- X%*%m0$par # 纯保费预测值
y <- premium        # 经验纯保费
cbind(y.fit, y) # 纯保费拟合值和观测值的比较
dt$yn <- predict(m1)
# =========================================================
#  weight = 1，表示等权重
# =========================================================
m2 <- lm(premium ~ area.f + type.f,  data = dt)
predict(m2)
cbind(y, predict(m2))
dt$y1 <- predict(m2)
# =========================================================
#  weight = n^0.5
# =========================================================
m3 <- lm(premium ~ area.f + type.f, data = dt, weights = n^0.5)
cbind(y, predict(m3))
dt$yn05 <- predict(m3)

dt
# =================================================================
# 2. 最小二乘法(乘法模型)
# =================================================================
X <- model.matrix(~ area.f + type.f, data = dt)
# X <- X[,c(1, 6:9)]

loss.f <- function(par, X, y, n, index = 1){
  # y 经验纯保费
  # n 风险单位数
  # X 为设计矩阵
  muij <- exp(X%*%par)
  Qij <- (n)^(index)*(y - muij)^2
  Q <- sum(Qij)
  return(Q)
}
starts <- (rep(1, length = ncol(X)))
par <- starts
m0 <- optim(par = starts, 
            fn = loss.f, 
            y = dt$premium,
            X = X,
            n = dt$n,
            index = 1,
            method = "CG", hessian = T)
beta.hat <- m0$par
dt$ynew <- exp(X%*%beta.hat)

dt

# =================================================================
# 3. 广义线性模型（伽马回归模型）
# =================================================================
# 模拟解释变量
n <- 500  # 样本数
set.seed(123)
x1 <- rgamma(n, shape = 2, rate = 1)  # 解释变量 x1
x2 <- rgamma(n, shape = 2, rate = 3)  # 解释变量 x２
x3 <- rbinom(n, 1, 0.4)　# 分类变量 x３
x4 <- rbinom(n, 1, 0.7)　　# 分类变量 x４
# 模拟数据使用的回归系数的真实值
b0 <- 7
b1 <- 0.8
b2 <- - 0.8
b3 <- 0.5
b4 <- -0.2
b5 <- -0.25
alpha <- 4
# 线性预测项
eta <- b0 + b1*x1 + b2*x2 + b3*x3 + b4*x4 + b5*x2*x3
# 因变量的均值（期望）
mu <- exp(eta)
# 因变量的模拟（期望）
y <- rgamma(n, shape = alpha, rate = alpha/mu)
# 模拟数据集
dt <- data.frame(x1, x2, x3, x4, y)
dt

# ===============================
# (1) 广义线性模型下的伽马回归
mga <- glm(y ~ x1 + x2 + x3 + x4 + x2*x3, family = Gamma(link = log), data = dt)
summary(mga)

# ===============================
# (2) 定义优化函数 - 极大似然估计（写出模型的对数似然函数）
loglike.ga <- function(par, X, y) {
  coef <- par[1:6] # 回归系数
  alpha <- par[7]  # 伽马分布的参数
  eta <- X%*%coef  # 线性预测项
  mu <- exp(eta)   # log 连接函数
  loglike <- 0     # 定义对数似然函数
  for(i in 1:n){
    loglike[i] <- dgamma(y[i], shape = alpha, rate = alpha/mu[i], log = T) 
  }
  return(-sum(loglike))  # 返回对数似然函数的和
}
mga2 <- optim(par = c(6, 0.8, -0.8, 0.5, -0.2, -0.2, 4),
              fn = loglike.ga,
              X = model.matrix(~ x1 + x2 + x3 + x4 + x2*x3, data = dt),
              y = dt$y,
              method = "Nelder-Mead",  # 优化方法
              hessian = T  # 输出 hessian 矩阵
              )

mga2 # 输出结果
GA.par　<- mga2$par          # 输出回归系数结果
GA.hessian <- mga2$hessian   ## Hessian 矩阵
GA.se <- sqrt(diag(solve(GA.hessian))) ## 参数估计的标准误
GA.Z <- GA.par/GA.se           ##  Z统计量
GA.p <- ifelse(GA.Z >= 0, pnorm(GA.Z, lower = F)*2, pnorm(GA.Z)*2)    ## p值
NLGA <- - mga2$value  # loglikelihood value
AICGA <- -2*length(mga2$par) - 2*NLGA  # BIC 统计量
BICGA <- -log(length(dt$y))*length(mga2$par) - 2*NLGA # AIC 统计量
(summarytable = round(data.frame(coef = GA.par, se = GA.se, Z = GA.Z, pvalue = GA.p), 3))
list(summary = summarytable, ll = NLGA)


# =================================================================================
# 4. 广义线性模型（应用一）
# =================================================================================
claims <- c(8400, 7020, 3600, 17340, 7200, 4590, 825, 1140, 2640)*100 # 索赔金额
exposures <- c(8000, 5200, 2000, 13600, 6000, 2400, 400, 800, 1600)   # 风险单位数
pure <- round(claims/exposures,0) # 经验纯保费
region <- rep(c('A','B','C'), 3) # 地区
type <- rep(c('1', '2', '3'), each = 3)
dat <- data.frame(region, type, claims, exposures, pure) # 分析数据集

# 泊松回归
mod <- glm(pure ~ factor(region) + factor(type), 
           weights = exposures, # 权重
           family = poisson(link = 'log'), 
           data = dat)
matrix(fitted(mod), 3, 3, byrow = T)# 预测结果
dat$pred.po <- fitted(mod)
# 伽马回归
mod <- glm(pure ~ factor(region) + factor(type), 
           weights = exposures, # 权重
           family = Gamma(link = 'log'), 
           data = dat)
matrix(fitted(mod), 3, 3, byrow = T) # 预测结果

dat$pred.ga <- fitted(mod)
dat


# =================================================================================
# 5. 广义线性模型（应用二 - 车险数据分析）
# =================================================================================
library(tweedie) # tweedie 回归需要使用的包
library(mgcv)    # tweedie 回归需要使用的包
library(cplm)   # tweedie 回归需要使用的包
library(data.table) # 整理数据、清理数据的 packages

# 读取数据集
dat <- fread('D:/对外经济贸易大学 - 教学/CT6 - 非寿险精算/非寿险精算（2018 秋）/2018 - 2019 学期 - R 代码/Case - Vehicleclaim.csv', header = T)

# ----------------------------------------------------------
# 0. 数据初步整理
# ----------------------------------------------------------
# type、gender、branch 因子化
dat[, type := factor(type)]
dat[, gender := factor(gender)]
dat[, branch := factor(branch)]
dat[, pure := cost/ee]

# 是否发生索赔
dat[, R := ifelse(num == 0, 0, 1)]
dat[, logee := log(ee)]

# 把年龄离散化
dtage <- dat[, list(pure = mean(pure)), by = age]; dtage
plot(pure ~ age, data = dtage, type = 'l')
dat$age.f = cut(dat$age, breaks = c(18, 25, 30, 50, 60, 70), labels = c('18_25','25_30',"30_50",'50_60','60+'), include.lowest = TRUE)              #离散化
table(dat$age.f)

# 把车龄离散化
dtvage = dat[, list(pure = mean(pure)),by = vage]; dtvage
plot(pure ~ vage, data = dtvage, type = 'l')
dat$vage.f= factor(with(dat, ifelse(vage <=1, '0_1', ifelse(vage >= 8, '8+' , '2-7'))))              #离散化
table(dat$vage.f)

# ---------------------------------------
# 设定基准水平
# ---------------------------------------
dat$type <- relevel(dat$type, ref = '转入')
dat$gender <- relevel(dat$gender, ref = 'M')
dat$branch <- relevel(dat$branch, ref = '北京')
dat$age.f <-  relevel(dat$age.f, ref = '30_50')
dat$vage.f <-  relevel(dat$vage.f, ref = '2-7')

# 最终数据
dat                    # 全数据集
dat0 <- dat[cost > 0]  # 剔除 0 索赔的数据集 


# ----------------------------------------------------------
# 0. 描述性分析
# ----------------------------------------------------------
dtage <- dat[, list(pure = mean(pure)),by = age.f]; dtage
dtvage <- dat[, list(pure = mean(pure)),by = vage.f]; dtvage
dtgender <- dat[, list(pure = mean(pure)),by = gender]; dtgender
dttype <- dat[, list(pure = mean(pure)),by = type]; dttype
dtbranch <- dat[, list(pure = mean(pure)),by = branch]; dtbranch

# ----------------------------------------------------------
# 1. Possison - Gamma regression models （广义线性模型）
# ----------------------------------------------------------
po <- glm(num ~ age.f + vage.f + branch + type, family = poisson, data = dat)
ga <- glm(sev ~ age.f + vage.f + branch + type, family = Gamma(link = 'log'), weight = num, data = dat0)

summary(po)
summary(ga)

coef(po)  # 索赔频率费率因子
coef(ga)  # 索赔强度费率银子
rate1 <- coef(po) + coef(ga)  # 纯保费的费率因子

# ----------------------------------------------------------
# 2. Tweedie regression models
# ----------------------------------------------------------　
# 建立 tweedie 回归模型（两种方法）
# 第一种： p 未知
tw <- gam(cost ~　age.f + vage.f + branch + type, family = tw(), 
          method = 'REML',
          data = dat)  # Tweedie 中的参数 p 与参数 beta 一起估计
# 第二种： p 已知
tw <- glm(cost ~ age.f + vage.f + branch + type, family = Tweedie(p = 1.6), data = dat) # Tweedie 中的参数 p 事先设定

summary(tw)
rate2 <- coef(tw)             # 纯保费费率银子
rate2

# 两种方法下的费率因子估计值比较
exp(cbind(rate1, rate2))

# ----------------------------------------------
# 对保单的风险组合进行预测
# ----------------------------------------------
# 构建风险组合数据集（需要预测的数据结构）
newdata <- dat[,.(age.f, vage.f, branch, type)]
newdata <- newdata[!duplicated(newdata)] # 剔除重复值

numpred <- predict(po, type = 'response', newdata = newdata)  # 索赔频率预测
sevpred <- predict(ga, type = 'response', newdata =  newdata) # 索赔强度预测
P0 <- numpred*sevpred  # 索赔频率 * 索赔强度
P1 <- predict(tw, type = "response", newdata = newdata) #　直接纯保费预测

newdata$P0 <- P0   # 泊松分布＋伽马分布预测值
newdata$P1 <- P1   # Tweedie预测值
# 每个风险类别的预测值（最终结果， 纯保费的预测值）
newdata
