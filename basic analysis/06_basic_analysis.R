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


null_metrics <- null_fit |> 
  collect_metrics() |> 
  mutate(model = "null")

log_metrics1 <- log_fit1 |> 
  collect_metrics() |> 
  mutate(model = "logistic")

metrics <- null_metrics |> 
  bind_rows(log_metrics1)

write_csv(metrics, here("results/metrics.csv"))

#basic recipe assessment
metrics |> 
  relocate(model) |>
  group_by(model) |> 
  gt() |> 
  tab_header(title = md("**Assessment Metrics**"), 
             subtitle = "Null and Logistic Models - Basic Recipe") |> 
  fmt_number(
    columns = mean, 
    decimals = 3) |> 
  fmt_number(
    columns = std_err, 
    decimals = 7) |> 
  row_group_order(groups = c("null", "logistic")) |> 
  tab_options(row_group.background.color = "gray50")