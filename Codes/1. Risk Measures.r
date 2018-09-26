# ==============================================================================================
# 1. 风险度量
# ==============================================================================================
# 例：损失的均值为100，标准差为223.607
# 用正态分布，帕累托分布和 Weibull 分布计算在 90%，99% 和 99.9% 水平的 VaR
library(actuar)
q <- c(0.90,0.99,0.999)
varNorm <- qnorm(q, mean = 100, 223.607) # 正态分布
varPar <- actuar::qpareto(q, scale = 120, shape = 2.2) # 帕累托分布
varWei <- qweibull(q, shape = 0.5, scale = 50)  # Weibull分布

result <- data.frame(q, varNorm, varPar,varWei)
result


# ==============================================================================================
# 课堂练习
# ==============================================================================================
set.seed(111)
loss = c(rlnorm(100, 0, 1), rep(2, 40))
p = 1:length(loss)/length(loss)
plot(sort(loss), p, type = "s")
VaR = quantile(loss, 0.99)
VaR
TVaR = mean(loss[loss > VaR])
TVaR

# 假设损失服从gamma(shape = 3,scale = 400)，计算95%水平下的VaR和TVaR
Var.ga <- function(q) qgamma(q, shape = 3, scale = 400) # 定义 VaR 函数
TVar.ga <- function(q) {
  integrate(Var.ga, lower = q, upper = 1)$value/(1 - q)  # 定义 TvaR 函数
}
Var.ga(0.95); TVar.ga(0.95)

# 假设损失服从lnorm(meanlog = 3,sdlog = 2)，计算95%水平下的VaR和TVaR
Var.lnorm <- function(q) qlnorm(q, meanlog = 3, sdlog = 2) # 定义 VaR 函数
TVar.lnorm <- function(q) {
  integrate(Var.lnorm, lower = q, upper = 1)$value/(1 - q)  # 定义 TvaR 函数
}
Var.lnorm(0.95); TVar.lnorm(0.95)



# ==============================================================================================
# 指数保费原理
# ==============================================================================================
shape = 2; scale = 500
GAM = function(a) -shape*log(1-scale*a)/a
curve(GAM(x),xlim = c(0,1/501), xlab='指数原理的风险厌恶系数',ylab='指数保费原理下的风险保费',col=2,lwd=2)
text(0.0007,4000,'X服从伽马分布(shape=2,scale=500)')
text(0.0007,5000,expression(H(alpha)==frac(1,alpha)*log(E(exp(alpha*X)))))


# ==============================================================================================
# Esscher principle (保费原理)
# ==============================================================================================
par(mfrow = c(1, 1))
h = 0.002; shape = 2; scale = 100
f = function(x) dgamma(x, shape = shape, scale = scale)
f2 = function(x) dgamma(x, shape = shape, scale = scale)*exp(h*x)
M = integrate(f,0,Inf)$value
g = function(x)  dgamma(x, shape = shape, scale = scale)*exp(h*x)/M
curve(f(x), xlim = c(0,1000), ylim = c(0,0.008))
curve(g(x), xlim = c(0,1000), col = 2, lty = 2, lwd = 2, add = T)
text(500,0.006,'虚线为Esscher变换后的密度函数,h=0.002,
     实线表示原分布的密度函数，为伽马(shape=2,scale=100)')
