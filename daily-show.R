library(readr)
library(plyr)
library(dplyr)
library(cowplot)

?read_csv
daily_show_data <- read_csv("~/projects/data/daily-show-guests/daily_show_guests.csv")
problems(daily_show_data)

daily_show_data <- read_csv("~/projects/data/daily-show-guests/daily_show_guests.csv", 
                            col_types = cols(Show = col_date("%m/%d/%y")))
problems(daily_show_data)
head(daily_show_data)
?head
class(daily_show_data)
?head.data.frame
head(daily_show_data, n = 10)
summary(daily_show_data)

df <- daily_show_data
unique(df$Group)
df$Group[df$Group == "media"] <- "Media"
df$Group[(is.na(df$Group)) | (df$Group == "Misc")] <- "Other"

df <- df %>% 
  group_by(Group) %>% 
  summarize(n = n())

head(df)
unique(df$Group)
df$Group <- factor(df$Group, levels = df$Group[order(df$n)])
df$Group <- factor(df$Group, 
                   levels = c("Other", 
                              levels(df$Group)[levels(df$Group) != "Other"]))

ggplot(df, aes(Group, n)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + 
  scale_y_continuous(expand = c(0, 0)) + 
  theme(axis.ticks = element_blank())

