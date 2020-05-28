library(ggplot2)
library(ggrepel)

df <- read.csv("../../Data/CSV/BayesianOptimization.csv", header = TRUE)

p <- ggplot(data = df, aes(x = iter, y = target)) +
  geom_point(color="#7A81FF", size=3) +
  geom_line(color="#3F709F") +
  geom_smooth(size = 0.5, color = "red", linetype="dashed") +
  theme_light() +
#  xlab("迭代次数") +
#  ylab("ROC_AUC") +
#  labs(title = "贝叶斯优化") +
  xlab("迭代次数") +
  ylab("ROC_AUC") +
  theme(plot.title = element_text(hjust = 0.5), panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
  theme(text = element_text(family='PingFangSC-Regular'))
  #geom_text_repel(data = df, aes(x = iter, y = target), label = df$target)
p
ggsave("BayesianOptimization.png", dpi=600)

