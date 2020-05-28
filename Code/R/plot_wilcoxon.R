library(ggplot2)


df <- read.csv('../../Data/CSV/Wilcoxon秩和检验.csv', header = T)

p <- ggplot(df, aes(x=var, y=p_value)) +
  geom_bar(stat = "identity", fill=rgb(0.1,0.4,0.5,0.7)) +
  theme(
    axis.text.x = element_text(angle = 60, hjust = 1, vjust = 1, size = rel(0.8))) +
  xlab("Variable") +
  ylab("P-Value")

p
