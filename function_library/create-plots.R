
ds_plots <- function(df) {
  p1 <- plot_counts(df)
  p2 <- plot_538(df)
  list(p1 = p1, p2 = p2)
}

plot_counts <- function(ds_data) {
  df <- ds_data %>% 
    select(group = old_group) %>% 
    group_by(group) %>% 
    summarize(n = n())
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
}


plot_538 <- function(ds_data) {
  df <- ds_data %>% 
    group_by(year, group) %>% 
    summarize(n = n()) %>% 
    mutate(p = n/sum(n))
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
}