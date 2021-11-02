#====================================================================================================================================================#
# R Data Exploration
# UW Madison Women in Economics Fall 2021
#
# Use this script as a template to get started exploring and analyzing data in R
#   - As an example we are loading data on historical phone usage from Tidy Tuesday, a great source of
#     cleaned datasets on a wide variety of topics
#     (source: https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-11-10/readme.md)
#
#====================================================================================================================================================#

#========================#
# ==== load packages ====
#========================#
  # R is "open-source", meaning that people from all over the world can contribute to it.
  # Usually, the calculations, functions, and visualizations you're interested in using 
  # are also popular among other R users, so you can access the existing functions 
  # by installing and loading packages.
  
  install.packages('readr') #this package is helpful for loading data from github
  install.packages('ggplot2') # this package has great functions to help with visualizing data  
  install.packages('tidyr')  # this package has great functions to help with tidying data
  install.packages('dplyr') # this package has great functions to help with reshaping data
  
  library(readr) 
  library(ggplot2) 
  library(tidyr)
  library(dplyr) 

#====================#
# ==== load data ====
#====================#

  # Load in the datasets directly from github as data frames
  mobile <- as.data.frame(read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-11-10/mobile.csv'))
  landline <- as.data.frame(read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-11-10/landline.csv'))

#=======================#
# ==== explore data ====
#=======================#
  
  # View the structure of the data to get a sense of the column names and the values available
  str(mobile)
  str(landline)
  
  # Notice how all of the columns seem to be the same, with the exception of "landline" and "mobile" subs
  # This means we can merge to two data sources together
  merge_by_cols <- setdiff(names(mobile), "mobile_subs")
  merged_phone_usage <- merge(x  = mobile, 
                              y  = landline,
                              by = c("entity", "code", "year", "continent"),
                              all = T,
                              suffixes = c("_mobile", "_landline"))
  
  # Look at data inconsistencies -- the mobile and landline data doesn't
  # report the same populations in the same year
  sum(merged_phone_usage$total_pop_mobile == merged_phone_usage$total_pop_landline, na.rm = T)  
  
  # How many years/locations/genres/categories are in your data? Use the '$' to specify the name of a column
  table(data$year)
  table(data$unit_type)
  table(data$region, data$unit_type) 
  
  # Let's focus in on one part of the data. Subsetting to the United States
  usa_phone_usage <- subset(merged_phone_usage, code == "USA")
  
  # Summarizing the data helps you see the range of values
  summary(usa_phone_usage$mobile_subs)
  
#====================#
# ==== visualize ====
#====================#
  # Visualizing data can be a great step when asking a question about the relationship between multiple variables
  
  # format the specific data for your plot -- we'll take the visitation data just for these three parks for now. 
  # need all numbers to be in one "long" column to plot them both on the same axes
  long_usa_phone_data <- gather(data  = usa_phone_usage, 
                                key   = "phone_type", 
                                value = "thousands_subscribed", 
                                mobile_subs, landline_subs)
  
  # Let's create a line plot showing relative phone usage over time since 1990 
  # Specify the name of your data, the values on the x and y axes, and the variable to color the points by
  ggplot(data = long_usa_phone_data, aes(x = year, y = thousands_subscribed, color = phone_type, group = phone_type)) +
    geom_point() +
    geom_line()
  
  
