# 非寿险精算学

本课程是一门三学分课程（精算与风险管理专业必修、其他专业选修），适合风险管理、保险与精算等相关专业的**本科高年级学生**参考。 


非寿险精算主要内容是**费率厘定**、**准备金评估**和**再保险**三部分

- **损失模型**：风险度量、索赔次数、索赔金额、累积损失模型
- **费率厘定**：分类费率厘定、经验费率厘定
- **准备金评估**：未到期责任准备金、未决赔款准备金、理赔费用准备金评估
- **再保险定价**

在实证研究中，以 **R 语言** 为计算工具，提供了详细的程序代码，方便读者再现完整的编程和计算过程。

## 先修内容
需要概率论与数理统计、高等数学、线性代数、保险学的基础知识

- **概率论与数理统计**：随机变量、概率分布、中心极限定理
- **高等数学**：微积分、泰勒公式
- **线性代数**：矩阵运算
- **保险学**：基本概念和专业术语



## 课程讲义
- [Markdown 新手指南](https://www.jianshu.com/p/q81RER)
- [Markdown 语法大全](https://www.appinn.com/markdown/)
- [Week 1 - 非寿险精算简介](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Lectures/Week%201%20-%20%E9%9D%9E%E5%AF%BF%E9%99%A9%E7%B2%BE%E7%AE%97%E7%AE%80%E4%BB%8B.ppt)
	- 课程安排
	- R 软件介绍
	- 非寿险概念
- [Week 2 - 风险度量基础](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Lectures/Week%202%20-%20%E9%A3%8E%E9%99%A9%E5%BA%A6%E9%87%8F%E5%9F%BA%E7%A1%80.pptx)
	- VaR（在险价值）
	- TVaR（条件在险价值）/ CVaR（尾部在险价值）
	- 保费原理
- [Week 3 - 损失金额模型](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Lectures/Week%203%20-%20%E6%8D%9F%E5%A4%B1%E9%87%91%E9%A2%9D%E6%A8%A1%E5%9E%8B.pptx)
	- 指数分布、伽马分布、逆高斯分布、对数正态分布、帕累托分布、威布儿分布
	- 对数变换、指数变换
	- 混合分布
	- 案例分析
- [Week 4.5 - 损失次数模型](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Lectures/Week%204%20-%20%E6%8D%9F%E5%A4%B1%E6%AC%A1%E6%95%B0%E6%A8%A1%E5%9E%8B.pptx)
	- (a,b,0) 分布
	- (a,b,1) 分布
    - 混合分布：混合泊松分布
    - 复合分布：复合泊松分布
    - 免赔额对索赔次数模型的影响
- [Week 6.7 - 累积损失模型](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Lectures/Week%206%20-%20%E7%B4%AF%E7%A7%AF%E6%8D%9F%E5%A4%B1%E6%A8%A1%E5%9E%8B.pptx)
	- 集体风险模型（近似法、解析法、递推法、随机模拟）
	- 个体风险模型（参数近似）
- [Week 8.9 - 費率厘定基本原理](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Lectures/Week%208%20-%20%E8%B4%B9%E7%8E%87%E5%8E%98%E5%AE%9A%E7%9A%84%E5%9F%BA%E6%9C%AC%E5%8E%9F%E7%90%86.ppt)
	- 专业属于和基本概念
	- 纯保费法、赔付率法
- [Week 10.11 - 分类费率与广义线性模型]()
	- 风险分类
	- 广义线性模型
	- 应用案例


## R 代码和数据
- [案例分析数据 - freMTPLsev](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Datasets/freMTPLsev.csv)
-  [Week 2 - 风险度量](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Codes/1.%20Risk%20Measures.r)
-  [Week 3 - 损失金额模型](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Codes/2.%20Models%20of%20Claim%20Amount.r)
-  [Week 4.5 - 损失次数模型](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Codes/3.%20Models%20of%20Claim%20Count.r)
-  [Week 6.7 - 累积损失模型](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Codes/4.%20Models%20of%20Aggregate%20Loss.r)
- [Homework 1 Solutions](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Codes/Homework%201.Rmd)


## 课后作业
1. 假设被保险人的损失 X 服从伽马分布，参数为：shape = 2，scale = 1000。两份保单如下：

	（1）保单 A 的免赔额为100。

	（2）保单 B 的免赔额为100，赔偿限额为3000。（d=100，u=3100）
	- 分别计算保险公司对保单 A 和保单 B 的期望赔款（含零赔款在内）。
	- 如果发生 10% 的通货膨胀，上述结果将如何变化？
	- 如果通胀函数为1.1x^0.5，上述结果将如何变化？
	
2. 对于 gamma 分布（shape=2,scale=100) 绘图：
	- 止损保费和平均超额损失随着免赔额增加而变化的曲线图
	- 有限期望值随着限额变化而变化的曲线图
	- 把上述分布改为 pareto(shape=2,scale=200) 和指数分布 (rate=1/200)
    - 上述三个分布的均值相等，均为200

3. 某团体意外伤害险保单在保险期间的事故次数服从负二项分布（size=1, p=0.1），假设每次事故导致的索赔次数服从泊松分布(lambda=2)，请计算该保单下的索赔次数的分布。

4. 首分布为｛p0=0.1,  p1=0.3,  p2=0.3,  p3=0.2,  p4=0.1｝，次分布为｛q1=0.2,  q2=0.3,  q3=0.3,  q4=0.2｝，求复合分布的概率。

5. 假设损失次数服从负二项（r=2, beta=0.5）- 零截断负二项（ r=3, beta=0.1）的复合分布，损失金额小于500的概率为0.1, 如果免赔额为500，求索赔次数的分布。

6. 假设个体风险服从参数为$\left( \lambda \Theta  \right)$泊松分布，
结构函数$\Theta $为均值为1，方差为$1/\alpha $ 伽马分布，相关参数表示为$\left( \alpha ,\alpha  \right)$，且密度函数为  

	${{f}_{\Theta }}(\theta )=\frac{1}{\Gamma (\theta )}{{\alpha }^{\alpha }}{{\theta }^{\alpha -1}}\exp (-\alpha \theta ),\theta >0$

	- 推导出混合泊松-伽马分布等价的负二项分布，写出概率函数$P\left( N=k \right)$。当$\alpha =1,\ \ \lambda =1.2$时，运用R软件dnbinom函数求出$k=1,2,...,10$对应的概率
	- 直接运用R中的积分算法（integrate）函数求出混合泊松-伽马分布在$k=1,2,...,10$的概率。（参考课件中混合泊松-逆高斯分布和混合泊松-负二项分布的相关代码，$\alpha =1,\ \ \lambda =1.2$）
	- 比较两种计算方法是否一致？

7. 假设损失次数服从负二项分布, 参数为（r = 2,  β = 3）,  每次损失的金额服从对数正态分布, 参数为（μ=5, σ=2）, 计算累积损失在90%、95%和99% 水平下的 VaR 和 TVaR。
注：累积损失的分布用随机模拟。


8. 损失次数服从泊松 (lam = 3)，损失金额服从帕累托(a = 4,  q =10)，对每次损失的一般免赔额为6，对每次损失的赔偿限额为18，共保比例为 75%。应用随机模拟求保险公司累积赔款 S 的分布。


**要求:用 R 编写程序代码。**



------------------------
## 教材和参考资料
- 孟生旺, 刘乐平. 非寿险精算学(第三版), 中国人民大学出版社, 2015
- [Klugman S. A., Panjer H. H., Willmot G. E. Loss models: from data to decisions (4th edition).  London: John Wiley & Sons, 2012.](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Reference%20books/Loss%20models%20from%20data%20to%20decisions%20(fourth%20editon)%20-%20Stuart%20A.%20Klugman%20(%E6%95%99%E5%AD%A6%E8%B5%84%E6%96%99).pdf)
- [Tse, Yiu-Kuen. Nonlife actuarial models: theory, methods and evaluation.  London: Cambridge University Press, 2009.](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Reference%20books/Nonlife%20Actuarial%20Models%20Theory%20Methods%20and%20Evaluation%20(%E6%95%99%E5%AD%A6%E8%B5%84%E6%96%99).pdf)
- [ggplot2 - Elegant graphics for data analysis.](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Reference%20books/ggplot2%20guide.pdf)
- [R in Action](https://github.com/lizhengxiao/Non-life-Insurance-Actuarial-Science/blob/master/Reference%20books/R%20in%20Action-2010.pdf)

---

 ![](非寿险精算学.png)
