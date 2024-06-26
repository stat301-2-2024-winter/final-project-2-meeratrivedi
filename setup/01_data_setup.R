# Final Project ----
# Reading in Data and Quality Check
  
# load packages ----
library(tidyverse)
library(here)
library(skimr)
library(naniar)
library(janitor)


#load data
realestate <- read_delim("data/raw/Real_Estate_Dataset.csv", 
                         delim = ";", escape_double = FALSE, trim_ws = TRUE) |> 
  clean_names()


#missingness
miss_table <- miss_var_summary(realestate)

miss_names <- miss_table |> 
  pull(variable)

realestate |> 
  select(miss_names) |> 
  gg_miss_var()


#quality of living filtered na values out
clean_qol <- realestate |> 
  filter(!is.na(quality_of_living)) |> 
  mutate(
    satisfaction = if_else(quality_of_living <= 85, "unsatisfied", "satisfied") |> 
      factor(levels = c("satisfied", "unsatisfied")),
    quality_of_living = factor(quality_of_living)
    ) |>
  arrange((quality_of_living)) |> 
  relocate(satisfaction)

save(clean_qol, file = "data/clean_qol.rda")

#checking proportions of variables im making/messing with
clean_qol |> 
  count(satisfaction) |> 
  janitor::adorn_percentages(denominator = "col")

clean_qol|> 
  mutate(
    total_floors = case_when(
      total_floors >= 23 ~ "23-46",
      total_floors <= 22 ~ "1-22",
      NA ~ "unknown"
      ), 
  total_floors = factor(total_floors))|> 
  count(total_floors) |> 
  janitor::adorn_percentages(denominator = "col")

clean_qol|> 
  mutate(
    floor = case_when(
      floor >= 15 ~ "15-34",
      floor < 15 ~ "below 15",
      NA ~ "unknown" 
    ), 
    floor = factor(floor))|> 
  count(floor) |> 
  janitor::adorn_percentages(denominator = "col") |> 
  view()

#quality of living w ordered levels - not relevant anymore
clean_qol_lvls <- clean_qol |> 
  mutate(quality_of_living = fct_collapse(quality_of_living, 
                                          "4-10" = c("4", "5", "6", "7", "8", "9", "10"), 
                                          "27-51" = c("27", "37", "38", "44", "49", "51"), 
                                          "53-61" = c("53", "55", "57", "58", "59", "61"), 
                                          "62-69" = c("62", "63", "64", "65", "66", "67", '68', "69"), 
                                          "71-79" = c("71", "72", "73", "74", "75", "76", '77', '78', "79"), 
                                          "81-89" = c("81", "82", "83", "84", "85", "86", '87', '88', "89"), 
                                          "91-99" = c("91", "92", "93", "94", "95", "96", '97', '98', "99")))

qol_levels = c("4-10", "27-51", "53-61", "62-69", "71-79", "81-89", "91-99")

#80% of Training Dataset
training_sample <- estate_train |> 
  slice_sample(prop = 0.8)

save(training_sample, file = "data/training_sample.rda")



