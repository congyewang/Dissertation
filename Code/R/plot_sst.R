library(ggplot2)
library(hrbrthemes)


df <- read.csv("../../Data/CSV/碎石图.csv", header = TRUE)
p <- ggplot(data = df, aes(x = num, y = data)) +
  geom_point(color="#7A81FF", size=3) +
  geom_segment( aes(x=num, xend=num, y=0, yend=data), color="skyblue") +
  geom_line(color="#3F709F") +
  geom_hline(aes(yintercept=1), colour="red", linetype="dashed") +
  theme_light() +
  xlab("成分数") +
  ylab("特征值") +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(text = element_text(family='PingFangSC-Regular'))

p

ggsave("碎石图.png", dpi=600)
