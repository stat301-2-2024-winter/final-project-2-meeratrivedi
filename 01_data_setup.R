
# Reading in Data and Quality Check
  
# load packages ----
library(tidyverse)
library(here)
library(skimr)
library(naniar)
library(janitor)


#load data
realestate <- read_delim("data/Real_Estate_Dataset.csv", 
                         delim = ";", escape_double = FALSE, trim_ws = TRUE) |> 
  clean_names()

#missingness
miss_table <- miss_var_summary(realestate) |> 
  filter(n_miss != 0)

miss_names <- miss_table |> 
  pull(variable)

realestate |> 
  select(miss_names) |> 
  gg_miss_var()

#quality of living filtered na values out
new <- realestate |> 
  filter(!is.na(quality_of_living))
