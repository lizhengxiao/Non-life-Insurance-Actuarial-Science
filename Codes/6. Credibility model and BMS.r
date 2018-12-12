# ======================================================================
# 索赔频率的完全可信度标准
# ======================================================================
r <- c(0.1, 0.075, 0.05, 0.04, 0.03, 0.02, 0.01) # 波动性
alpha <- c(20, 10, 5, 4, 3, 2, 1, 0.1, 0.01)/100 # 显著性水平， 1 - alpha：置信度（可靠水平）
n.mat <- matrix(NA, nrow = length(alpha), ncol = length(r))
for(i in 1:length(alpha)){
  U <- qnorm(p = 1 - alpha/2, mean = 0, sd = 1)  # 1 - alpha/2 下正态分布对应的分位数
  n.mat[i, ] <- round((U[i]/r)^2, 0)            # 索赔频率的完全可信度标准
}
colnames(n.mat) <- r
rownames(n.mat) <- alpha
n.mat


# ======================================================================
# 例：信度保费 - 贝叶斯保费
# - 误差比较
# ======================================================================
# 生成数据
set.seed(111)  # 随机数量
theta <- rgamma(50, shape = 50, rate = 10) # 生成 50 个服从伽马分布的随机数
X.mat <- matrix(NA, nrow = 50, ncol = 10)   # 50*10的矩阵
for (i in 1:50){
  X.mat[i, ] <- rpois(n = 10, lambda = theta[i]) # 根据每个theta的值模拟生成10的样本（泊松分布）
}
colnames(X.mat) <- paste0('j', seq(1:10))
rownames(X.mat) <- paste0('i', seq(1:50))
# ------------------------------------------------------------------------------------------------
# 1. 极大似然估计(每个i对应的样本均值)
X.bar <- apply(X.mat, MARGIN = 1, FUN = mean) # 对每个 i = 1,...50 求得样本均值

# 2. 信度模型估计
C <- 0.5*X.bar + 0.5*5    # 对每个 i = 1,...50 求得信度保费预测值

# 3. 计算总平方误差
S1 <- sum((X.bar - theta)^2)
S2 <- sum((C - theta)^2)
c(S1, S2)  
# 信度模型的估计 < 样本均值的估计（极大似然）


# 4. 如果信度模型的信度因子 Z 不是最优的，如何影响结果
# 本例中的最优值为 Z = 0.5, mu = 5
Z <- 0.6; mu <- 6
C <- Z*X.bar + (1 - Z)*mu
# 计算总平方误差
S1 <- sum((X.bar - theta)^2)
S2 <- sum((C - theta)^2)
c(S1, S2)  # 信度模型的估计 < 样本均值的估计（极大似然）

# 4. 信度保费是如何改进估计结果的？
Z <- 0.5; mu <- 5
mse.mean <- theta/10  # 样本均值的 均方误差
bias.credibility <- 2.5 - 0.5*theta  # 信度保费的 偏差
var.credibility <- 0.25*theta/10       # 信度保费的 方差
mse.credibility <- (bias.credibility)^2 + var.credibility  # 信度保费的 均方误差
result <- data.frame(theta = theta, mse.mean = mse.mean, bias.credibility = bias.credibility, var.credibility = var.credibility, mse.credibility = mse.credibility)
result <- result[order(result$theta),] # 按照 theta 的值进行排序
head(result)

# 比较均方误差的图
plot(x = result$theta, y = result$mse.credibility, type = 'o', col = 'red', lwd = 2)
lines(x = result$theta, y = result$mse.mean, type = 'o', col = 'blue', lwd = 2)
legend('top',legend = c('样本均值的均方误差', '信度保费的均方误差'), 
       col = c('blue', 'red'),
       lwd = 2,  pch = 1, bty = 'n')

# ======================================================================
# 信度模型（credibility models） 与 线性混合模型（linear mixed models）
# 等价的
# ======================================================================
  library(lme4)
  library(data.table)
# =====================================
#  Bühlmann model
# =====================================
# 例题
  y <- c(3, 5, 7, 6, 12, 9) # 
  i = c(1, 2)               # b
  j = c(1, 2, 3)
  dt <- expand.grid(i = i, j = j)
  dt <- data.table(dt)
  
  dt <- dt[order(i)]
  dt[, y := y]
  
  m <- lmer(y ~ 1 + (1|i), data = dt)
  summary(m)
  sigma.residuals <-  6.500
  sigma.random <- 5.833
  k <- sigma.residuals/sigma.random
  k
  # 预测结果
  dt.pred <- data.table(i = c(1:2))
  predict(m, newdata = dt.pred)
  
# 习题
  y <- c(73, 80, 65, 70, 65, 65, 63, 75)
  i <- c(1, 2)
  j <- c(1, 2, 3, 4)
  dt <- expand.grid(i = i, j = j)
  dt <- data.table(dt)
  dt <- dt[order(i)]
  dt[, y := y]
  
  m <- lmer(y ~ 1 + (1|i), data = dt)
  summary(m)
  sigma.residuals <-  34.333
  sigma.random <- 3.917
  k <- sigma.residuals/sigma.random
  k
  # 预测结果
  dt.pred <- data.table(i = c(1:2))
  predict(m, newdata = dt.pred)
 
# =====================================
# Bühlmann-Straub model
# ===================================== 
# 例题
  y <- c(3, 2, 2, 0, 2, 1, 0)
  w <- c(2, 2, 2, 1, 4, 3, 2)
  i = c(1, 1, 1, 1, 2, 2, 2)
  j = c(1, 2, 3, 4, 1, 2, 3)
  dt <- data.table(i = i, j = j, w = w, y = y, ynew = y/w)
  
  m <- lmer(ynew ~ 1 + (1|i), data = dt, weights = w)
  summary(m)
  k <- 0.3667/0.1757
  
    
# 练习
  y <- c(7, 8, 5, 6, 6, 9, 7)
  w <- c(12, 18, 9, 11, 13, 16, 15)
  i = c(1, 1, 1, 1, 2, 2, 2)
  j = c(1, 2, 3, 4, 1, 2, 3)
  dt <- data.table(i = i, j = j, w = w, y = y, ynew = y/w)
  
  m <- lmer(ynew ~ 1 + (1|i), data = dt, weights = w)
  summary(m)
  
  
  
# ======================================================================
# 奖惩系统 （NCD）
# ======================================================================
  library(lme4)
# =====================================
# 转移概率矩阵 （个体保单）
# 假设索赔次数服从 lambda = 0.4 的泊松分布
# =====================================
  p0 <- dpois(0, lambda = 0.4)
  p1 <- dpois(1, lambda = 0.4)
  p2 <- dpois(2, lambda = 0.4)
  
  # 转移概率矩阵
  M.row1 <- c(p0, p1, p2, 1-p0-p1-p2) # 第一行的元素
  M.row2 <- c(p0, 0, p1, 1-p0-p1)
  M.row3 <- c(0, p0, 0, 1-p0)
  M.row4 <- c(0, 0, p0, 1-p0)
  M <- (rbind(M.row1, M.row2, M.row3, M.row4))
  
  M %*% M%*% M%*% M%*% M%*% M%*% M%*% M%*% M%*% M%*% M%*% M%*% M%*% M%*% M%*% M%*% M%*% M%*% M
  
  e <- matrix(1, nrow = 4)
  E <- matrix(1, nrow = 4, ncol = 4)
  I <- diag(1, nrow = 4, ncol = 4)
  
  a = t(e)%*%solve((I - M  + E))
  a
  
  
  
  
  
  
  
  