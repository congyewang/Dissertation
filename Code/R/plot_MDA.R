library(ggplot2)

df <- read.csv("../../Data/CSV/MDA.csv", header = TRUE)

p <- ggplot(data=df) +
  geom_bar(aes(x=reorder(Feature, -Weight), y=Weight), stat="identity", fill="skyblue", alpha=0.7) +
  geom_errorbar(aes(x=Feature, ymin=Weight-Std, ymax=Weight+Std), width=0.2, colour="orange", alpha=0.9, size=0.7) +
  xlab("特征") +
  ylab("MDA") +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(text = element_text(family='PingFangSC-Regular'))
p
ggsave("MDA.png", dpi=600)
