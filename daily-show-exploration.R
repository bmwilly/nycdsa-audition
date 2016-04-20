## Load libraries 
library(readr)
library(plyr)
library(dplyr)
library(cowplot)
library(scales)
library(ggthemes)


## Read in data
file_name <- "~/projects/data/daily-show-guests/daily_show_guests.csv"
daily_show_data <- read_csv(file_name)
problems(daily_show_data)

daily_show_data <- read_csv(file_name, 
                            col_types = cols(Show = col_date("%m/%d/%y")))
problems(daily_show_data)
head(daily_show_data)
head(daily_show_data, n = 10)
summary(daily_show_data)


## Clean data 
ds_data <- daily_show_data 
colnames(ds_data) <- tolower(colnames(ds_data))
head(ds_data)
ds_data <- ds_data %>% 
  rename(occupation = googleknowlege_occupation, date = show, 
         guest = raw_guest_list)
unique(ds_data$group)
ds_data$group[ds_data$group == "media"] <- "Media"
ds_data %>% 
  filter(is.na(group))
ds_data$group[(is.na(ds_data$group)) | (ds_data$group == "Misc")] <- "Other"

head(ds_data)
df <- ds_data %>% 
  group_by(group) %>% 
  summarize(n = n())


## Plot counts by occupation 
head(df)
unique(df$group)
df$group <- factor(df$group, levels = df$group[order(df$n)])
df$group <- factor(df$group, 
                   levels = c("Other", 
                              levels(df$group)[levels(df$group) != "Other"]))

ggplot(df, aes(group, n)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1010)) + 
  labs(title = "Number of Daily show guests by occupation", x = "", y = "") + 
  theme(axis.ticks = element_blank())


## Recreate the graph on the fivethirtyeight post 
unique(ds_data$group)
df <- ds_data %>% 
  mutate(old_group = group) %>% 
  mutate(group = "Other")
df$group[df$old_group %in% c("Acting", "Comedy", "Musician")] <- "Acting, Comedy & Music"
df$group[df$old_group == "Media"] <- "Media"
df$group[df$old_group %in% c("Government", "Politician", "Political Aide")] <- "Government and Politics"

df <- df %>% 
  group_by(year, group) %>% 
  summarize(n = n()) %>% 
  mutate(p = n/sum(n))

head(df)
df$group <- factor(df$group, 
                   levels = c("Acting, Comedy & Music", "Media", 
                              "Government and Politics"))

ggplot(df, aes(year, p)) + 
  geom_line(aes(color = group), size = 1.5) + 
  scale_color_manual(values = c("blue", "purple", "red")) + 
  scale_x_continuous(breaks = c(2000, 2004, 2008, 2012), 
                     labels = c("2000", "'04", "'08", "'12")) + 
  scale_y_continuous(labels = percent, limits = c(0, 1), expand = c(0, 0)) + 
  labs(title = "Who Got To Be On 'The Daily Show'\nOccupation of guests, by year", 
       x = "", y = "", color = "") + 
  theme_fivethirtyeight() 







