library(ggplot2)


df <- read.csv("../../Data/CSV/plot_true_false.csv", header = TRUE)

df$date<-factor(df$date)

ggplot(data=df, aes(x=Date, y=Value)) +
  geom_bar(aes(fill=factor(Type)), stat="identity", alpha=.6, width=.4) +
  xlab("年份") +
  ylab("数量") +
  theme(text = element_text(family='PingFangSC-Regular')) +
  theme(plot.title = element_text(hjust = 0.5))

ggsave("样本审计意见分类图.png", dpi=600)
