
clean_data <- function(ds_data) {
  # Fix column names
  colnames(ds_data) <- tolower(colnames(ds_data))
  ds_data <- ds_data %>% 
    rename(occupation = googleknowlege_occupation, date = show, 
           guest = raw_guest_list)
  
  # Fix occupation groups
  ds_data$group[ds_data$group == "media"] <- "Media"
  ds_data %>% 
    filter(is.na(group))
  ds_data$group[(is.na(ds_data$group)) | (ds_data$group == "Misc")] <- "Other"
  
  # Create new occupation grouping 
  df <- ds_data %>% 
    mutate(old_group = group) %>% 
    mutate(group = "Other")
  df$group[df$old_group %in% c("Acting", "Comedy", "Musician")] <- "Acting, Comedy & Music"
  df$group[df$old_group == "Media"] <- "Media"
  df$group[df$old_group %in% c("Government", "Politician", "Political Aide")] <- "Government and Politics"
  
  df
}
