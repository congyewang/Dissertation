# 导入库
library(psych)
library(GPArotation)
library(nortest)
library(corrplot) # 相关性分析
library(PerformanceAnalytics) # 相关性分析


Sum <- read.csv("../../Data/CSV/1_Sum.csv", header = TRUE)
df_X <- full[3:165] # 抽取X
n <- subset(df, y == 0) # 正常组
abn <- subset(df, y == 1) # 非正常组

# 正态性检验
for(i in sort(names(df))) {
  s <- paste("lillie.test(abn$", i, ")", sep="")
  print(eval(parse(text=s)))
}

# Wilcoxon秩和检验(非参数检验)
for(i in 101:120) {
  s <- paste("wilcox.test(X", i, "~ y, df)", sep="")
  print(eval(parse(text=s)))
} 

# 剔除无用指标X105, X107, X220, X230, X305, X326, X501, X614
df_Wil_del <- subset(df_X, select = -c(X105, X107, X220, X230, X305, X326, X501, X614))

# 方差分析
mod <- aov(y ~ ., data=data_set)
summary(mod)

# 选择通过检验指标
df_pass_hyp <- subset(df, select = c(X101, X102, X104, X108, X109, X110, X111, X114, X115, X116, X117, X121, X122, X123, X127, X128, X129, X131, X132, X201, X202, X204, X205, X206, X207, X208, X209, X210, X211, X214, X215, X216, X217, X218, X219, X221, X224, X225, X226, X227, X228, X229, X231, X302, X304, X306, X309, X310, X312, X313, X314, X315, X318, X322, X324, X325, X327, X328, X329, X332, X334, X335, X338, X339, X340, X342, X403, X406, X407, X409, X410, X417, X419, X420, X423, X502, X505, X506, X507, X601, X602, X604, X606, X607, X608, X610, X612, X613, X615, X616, X617, X702, X703, X705))

# 相关性分析
res_cor <- cor(data_2)
corrplot(corr=res_cor)
res_cor_df <- as.data.frame(res_cor)
for (i in names(res_cor_df)) {
  for (j in names(res_cor_df)) {
    if (res_cor_df[i, j] > 0.9 | res_cor_df[i, j] < -0.9) {
      if (i < j) {
        print(c(i, j))
      }
    }
  }
}
# 画出Pearson相关性系数图
chart.Correlation(data_2, method = "pearson")

# 剔除高相关性指标
df_del_pearson <- subset(data_2, select=-c(X102,X226,X117,X123,X201,X208,X324,X204,X206,X312,X208,X324,X209,X318,X217,X225,X228,X302,X324,X329,X332,X334,X335,X403,X602,X608))

# KMO分析
KMO(df_del_pearson)

# 巴特利特球形分析
cortest.bartlett(df_del_pearson)
# 探索性因子分析
correlations <- cor(data_3)
fa.parallel(correlations, fa = "pc", main = "Screen Plots with Parallel Analysis")
fa.promax <- fa(correlations, nfactors=24, rotate="promax", fm="pa")
summary(fa.promax)
# 因子结构矩阵(或称因子载荷阵)
fsm <- function(oblique) {
  if (class(oblique)[2]=="fa" & is.null(oblique$Phi)) {
    warning("Object doesn't look like oblique EFA")
  }
  else {
    P <- unclass(oblique$loading)
    F_ <- P %*% oblique$Phi
    colnames(F_) <- c("PA1", "PA2", "PA3", "PA4", "PA5", "PA6", "PA7", "PA8", "PA9", "PA10", "PA11", "PA12", "PA13", "PA14", "PA15", "PA16", "PA17", "PA18", "PA19", "PA20", "PA21", "PA22", "PA23", "PA24") 
    return(F_)
  }
}
f_res <- fsm(fa.promax)
fa.diagram(fa.promax)
fa.varimax <- fa(correlations, nfactors=24, rotate="varimax", fm="pa")
fa.varimax