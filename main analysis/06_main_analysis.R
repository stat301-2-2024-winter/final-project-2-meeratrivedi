# Final Project ----
# Model Analysis - Non-Tuned Models

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(gt)

# handle common conflicts
tidymodels_prefer()

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# load training data
load(here("results/estate_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("results/basic_recipe.rda"))
load(here("results/main_recipe.rda"))

#load fits
load(here("results/null_fit.rda"))
load(here("results/log_fit1.rda"))
load(here("results/log_fit2.rda"))

#main recipe assessment
log_metrics2 <- log_fit2 |> 
  collect_metrics() |> 
  mutate(model = "logistic")

write_csv(log_metrics2, here("results/log_metrics2.csv"))

log_metrics2 |> 
  relocate(model) |>
  group_by(model) |> 
  gt() |> 
  tab_header(title = md("**Assessment Metrics**"), 
             subtitle = "Logistic Model - Main Recipe") |> 
  fmt_number(
    columns = mean, 
    decimals = 3) |> 
  fmt_number(
    columns = std_err, 
    decimals = 7) |> 
  row_group_order(groups = c("logistic")) |> 
  tab_options(row_group.background.color = "gray50")
