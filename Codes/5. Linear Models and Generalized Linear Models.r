
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
# =========================================================
#  weight = 1，表示等权重
# =========================================================
m2 <- lm(premium ~ area.f + type.f, data = dt, data = dt)
predict(m2)
cbind(y, predict(m2))
# =========================================================
#  weight = n^0.5
# =========================================================
m3 <- lm(premium ~ area.f + type.f, data = dt, weights = n^0.5)
cbind(y, predict(m3))


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
m0


# =================================================================
# 3. 广义线性模型（迭代加权最小二乘法）
# =================================================================
# 迭代加权最小二乘法
d2 = data.frame(y = c(1,3,3,5,6,7,9,10), x = c(-1,-1,0,0,0,0,1,1))
b = c(2, 1)
x = model.matrix( ~ x, data = d2)
m = 0
repeat{
  m = m + 1
  b1 = b
  v = diag(c(1/(x%*%b)))
  z = d2$y
  b = solve((t(x)%*%v%*%x))%*%t(x)%*%v%*%z
  if(max(abs(b1 - b)) < 1e-8) break
}
b  #迭代加权最小二乘法的参数估计值
m  #迭代次数

# glm
glm(y ~ x,data = d2, family = poisson(link = 'identity'))$coef


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

# 读取数据集
load('/中国车险数据.RData')
dat                    # 全数据集
dat0 <- dat[num > 0 ]  # 剔除 0 索赔的数据集 


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
ga <- glm(sev ~ age.f + vage.f + branch + type, family = Gamma(link = 'log'), data = dat0)

summary(po)
summary(ga)

coef(po)  # 索赔频率费率因子
coef(ga)  # 索赔强度费率银子
rate1 <- coef(po) + coef(ga)  # 纯保费的费率因子

# ----------------------------------------------------------
# 2. Tweedie regression models
# ----------------------------------------------------------　
# 建立 tweedie 回归模型
tw <- gam(cost ~　age.f + vage.f + branch + type, family = tw(), 
          method = 'REML',
          data = dat)
summary(tw)
rate2 <- coef(tw)             # 纯保费费率银子

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
# 每个风险类别的预测值
newdata
