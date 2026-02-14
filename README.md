# 非寿险精算与风险模型（教材项目）

本仓库用于维护《非寿险精算学》课程教材与配套教学资料，内容包括：

- 课程讲义（R Markdown 章节）
- 教学案例与代码片段
- 图表与参考文献
- 构建后的在线电子书（`docs/`）

> 本项目适用于非寿险精算、风险管理、保险学等相关课程教学与学习。

## 在线阅读

- 课程静态网站（GitHub Pages）：
  https://lizhengxiao.github.io/Non-life-Insurance-Actuarial-Science/

## 仓库结构

```text
.
├── index.Rmd                 # 首页与课程简介
├── 01-*.Rmd ~ 08-*.Rmd       # 各章节正文
├── references.Rmd            # 参考文献页
├── _bookdown.yml             # bookdown 全局配置
├── _output.yml               # 输出格式配置（gitbook/pdf/epub）
├── style.css                 # 页面样式
├── preamble.tex              # PDF 输出头文件
├── book.bib / packages.bib   # 参考文献库
├── picture/                  # 原始图片资源
└── docs/                     # 构建产物（网页/PDF 等）
```

## 本地环境准备

建议安装以下软件：

1. **R**（建议 4.2+）
2. **RStudio**（可选，但推荐）
3. **bookdown 依赖包**

可在 R 中执行：

```r
install.packages(c("bookdown", "rmarkdown", "knitr"))
```

如果需要构建 PDF，还需要安装 LaTeX（例如 TinyTeX）：

```r
install.packages("tinytex")
tinytex::install_tinytex()
```

## 常用构建方式

### 1）构建 GitBook（HTML）

```bash
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
```

### 2）一次性构建 HTML/PDF/EPUB

```bash
sh _build.sh
```

### 3）在 R 会话中构建

```r
bookdown::render_book('index.Rmd', 'bookdown::gitbook')
```

构建完成后可在 `docs/index.html` 预览。

## 内容编写规范（建议）

- 新增章节优先使用 `NN-topic.Rmd` 命名（如 `09-pricing-practice.Rmd`）。
- 图像统一放在 `picture/`，在文中使用相对路径引用。
- 参考文献统一维护在 `book.bib` / `packages.bib`。
- 避免直接手工修改 `docs/` 内自动生成文件（除非明确需要发布结果）。

## 协作流程（简要）

1. 从主分支创建个人分支。
2. 修改对应 `.Rmd` 与资源文件。
3. 本地构建并检查目录、公式、图表与交叉引用是否正常。
4. 提交变更并发起 Pull Request，说明修改范围与影响章节。

## 许可证

本仓库采用 `LICENSE` 文件中声明的许可协议。

## 致谢

感谢课程团队老师与同学对教材内容与案例的持续完善。
