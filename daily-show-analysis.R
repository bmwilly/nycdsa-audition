# Set working directory to the git project root
proj_root <- system("git rev-parse --show-toplevel", intern = TRUE)
setwd(proj_root)

## Load libraries
suppressMessages(library(tidyverse))
suppressMessages(library(cowplot))
suppressMessages(library(scales))
suppressMessages(library(ggthemes))

# Source functions
source("function_library/clean-data.R")
source("function_library/create-plots.R")

# Get command line argument (directory paths)
cmd_args <- commandArgs(trailingOnly = TRUE)
data_dir <- cmd_args[1]
output_dir <- cmd_args[2]

## Read in data
file_name <- file.path(data_dir, "daily_show_guests.csv")
daily_show_data <- read_csv(file_name,
    col_types = cols(Show = col_date("%m/%d/%y"))
)

## Clean data
df <- clean_data(daily_show_data)

## Create and save plots
plts <- ds_plots(df)
save_plot(file.path(output_dir, "counts.png"), plts[["p1"]],
    base_aspect_ratio = 1.7, base_width = 9
)
save_plot(file.path(output_dir, "fivethirtyeight.png"), plts[["p2"]],
    base_aspect_ratio = 1.2, base_height = 8
)
