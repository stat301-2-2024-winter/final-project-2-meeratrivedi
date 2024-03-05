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
load(here("results/main_recipe.rda"))

#load fits
load(here("results/log_fit2.rda"))
load(here("main analysis/main results/tuned_rf2.rda"))


#main recipe assessment
log_metrics2 <- log_fit2 |> 
  collect_metrics() |> 
  mutate(model = "logistic") |> 
  filter(.metric == "roc_auc")

log_metrics2 |> 
  relocate(model) |>
  group_by(model) |> 
  select(.estimator, mean, n, std_err, model) |> 
  relocate(model) |>
  arrange(desc(mean)) |> 
  gt() |> 
  tab_header(title = md("**Assessment Metrics**"), 
             subtitle = "All Models - Main Recipe") |>
  cols_label(.estimator = md("Estimator"), 
    std_err = md("Standard Error"), 
    mean = md("Mean ROC AUC"), 
    n = md("Number of Models")) |> 
  fmt_number(
    columns = mean, 
    decimals = 3) |> 
  fmt_number(
    columns = std_err, 
    decimals = 7) |> 
  row_group_order(groups = c("logistic")) |> 
  tab_options(row_group.background.color = "gray50")
