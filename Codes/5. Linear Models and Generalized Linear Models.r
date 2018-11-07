
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
