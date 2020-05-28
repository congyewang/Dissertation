library(ggplot2)
library(ggrepel)
library(forcats)
library(dplyr)

df <- read.csv("../../Data/CSV/feature_importance.csv", header = TRUE)
# Reorder following the value of another column:
df %>%
  mutate(feature_name = fct_reorder(feature_name, importance)) %>%
  ggplot(aes(x=feature_name, y=importance)) +
  geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
  coord_flip() +
  xlab("") +
  ylab("使用次数") +
#  labs(title = "特征重要性排序") +
  theme_bw() +
  theme(text = element_text(family='PingFangSC-Regular')) +
  theme(plot.title = element_text(hjust = 0.5))
ggsave("特征重要性排序.png", dpi=600)
