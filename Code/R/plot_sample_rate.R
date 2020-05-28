library(ggplot2)
library(RColorBrewer)
library(tidyverse)
library(ggrepel)

d_10 <- read.csv("../../Data/CSV/plot_industry/plot_industry_2010.csv", header = TRUE)
d_11 <- read.csv("../../Data/CSV/plot_industry/plot_industry_2011.csv", header = TRUE)
d_12 <- read.csv("../../Data/CSV/plot_industry/plot_industry_2012.csv", header = TRUE)
d_13 <- read.csv("../../Data/CSV/plot_industry/plot_industry_2013.csv", header = TRUE)
d_14 <- read.csv("../../Data/CSV/plot_industry/plot_industry_2014.csv", header = TRUE)
d_15 <- read.csv("../../Data/CSV/plot_industry/plot_industry_2015.csv", header = TRUE)
d_16 <- read.csv("../../Data/CSV/plot_industry/plot_industry_2016.csv", header = TRUE)
d_17 <- read.csv("../../Data/CSV/plot_industry/plot_industry_2017.csv", header = TRUE)
d_18 <- read.csv("../../Data/CSV/plot_industry/plot_industry_2018.csv", header = TRUE)
d_t <- read.csv("~../..Data/CSV/plot_industry/plot_industry_total.csv", header = TRUE)

myPalette <- brewer.pal(5, "Set2") 
pie(d_t$value , labels = d_10$name, border="white", col=myPalette, family = 'PingFangSC-Regular')
p <- ggplot(d_t, aes(x = "", y = value, fill = name)) + 
  geom_bar(stat = "identity") + 
  coord_polar(theta = "y") +
  theme(text = element_text(family='PingFangSC-Regular'))
p

d_t$id <- seq(length(d_t$value))
label_data <- d_t
number_of_bar <- nrow(label_data)
angle <-  90 - 360 * (label_data$id-0.5) /number_of_bar
label_data$hjust<-ifelse(angle < -90, 1, 0)
label_data$angle<-ifelse(angle < -90, angle+180, angle)
# Start the plot
p <- ggplot(d_t, aes(x=as.factor(id), y=value)) +
  geom_bar(stat="identity", fill=alpha("skyblue", 0.7)) +
  ylim(-1000,1550) +
  theme_minimal() +
  theme(
    text = element_text(family='PingFangSC-Regular'),
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    plot.margin = unit(rep(-1,4), "cm")
  ) +
  labs(title = "样本行业分布图") +
  coord_polar(start = 0) +
  geom_text(data=label_data, aes(x=id, y=value+10, label=name, hjust=hjust), color="black", fontface="bold",alpha=0.6, size=1.5, angle= label_data$angle, inherit.aes = FALSE, family = 'PingFangSC-Regular')
p
ggsave("样本比例.png", dpi=600)

p <- ggplot(d_t, aes(x=reorder(name, -value), y=value)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  theme(
    plot.title = element_text(hjust = 0.5),
    text = element_text(family='PingFangSC-Regular'),
    axis.text.x = element_text(angle = 60, hjust = 1, vjust = 1, size = rel(0.8))) +
  xlab("行业") +
  ylab("数量")

p
