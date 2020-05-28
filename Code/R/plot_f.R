library(ggplot2)
library(RColorBrewer)
library(tidyverse)
library(ggrepel)
library(extrafont)


d_t <- read.csv("../../Data/CSV/plot_industry/plot_f.csv", header = TRUE)

myPalette <- brewer.pal(5, "Set2") 
pie(d_t$value , labels = d_t$name, border="white", col=myPalette, family = 'PingFangSC-Regular')
p <- ggplot(d_t, aes(x = "", y = value, fill = name)) + 
  geom_bar(stat = "identity") + 
  coord_polar(theta = "y") +  ## 把柱状图折叠成饼图（极坐标）
  theme(text = element_text(family='PingFangSC-Regular'))
p

d_t$id <- seq(length(d_t$value))
label_data <- d_t
number_of_bar <- nrow(label_data)
angle <-  90 - 360 * (label_data$id-0.5) /number_of_bar
label_data$hjust<-ifelse(angle < -90, 1, 0)
label_data$angle<-ifelse(angle < -90, angle+180, angle)
# Start the plot
p <- ggplot(d_t, aes(x=as.factor(id), y=value)) +       # Note that id is a factor. If x is numeric, there is some space between the first bar
  
  # This add the bars with a blue color
  geom_bar(stat="identity", fill=alpha("#FF7E00", 0.7)) +
  
  # Limits of the plot = very important. The negative value controls the size of the inner circle, the positive one is useful to add size over each bar
  ylim(-20,60) +
  
  # Custom the theme: no axis title and no cartesian grid
  theme_minimal() +
  theme(
    text = element_text(family='PingFangSC-Regular'),
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    plot.margin = unit(rep(-1,4), "cm")      # Adjust the margin to make in sort labels are not truncated!
  ) +
  labs(title = "样本行业分布图") +
  # This makes the coordinate polar instead of cartesian.
  coord_polar(start = 0) +
  # Add the labels, using the label_data dataframe that we have created before
  geom_text(data=label_data, aes(x=id, y=value+2, label=name, hjust=hjust), color="black", fontface="bold",alpha=0.6, size=1.5, angle= label_data$angle, inherit.aes = FALSE, family = 'PingFangSC-Regular')
p
ggsave("非标准意见分布.png", dpi=600)

p <- ggplot(d_t, aes(x=reorder(name, -value), y=value)) +
  geom_bar(stat = "identity", fill = "#FF7E00") +
  theme(
    plot.title = element_text(hjust = 0.5),
    text = element_text(family='PingFangSC-Regular'),
    axis.text.x = element_text(angle = 60, hjust = 1, vjust = 1, size = rel(0.8))) +
  xlab("行业") +
  ylab("数量")
#  labs(title = "样本中非标准意见分布")
p
ggsave("非标准意见分布.png", dpi=600)
ggsave("非标准意见分布.pdf")
