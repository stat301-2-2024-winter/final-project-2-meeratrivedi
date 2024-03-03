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
load(here("basic analysis/basic results/null_fit.rda"))
load(here("basic analysis/basic results/log_fit1.rda"))
load(here("basic analysis/basic results/tuned_rf1.rda"))

rf_metrics1 <- tuned_rf |> 
  show_best(metric = "roc_auc") |> 
  arrange(.metric) |> 
  slice_head(n = 1) |> 
  mutate(model = "rf")
#more area under the curve, closer to 1 the better

null_metrics <- null_fit |> 
  collect_metrics() |> 
  mutate(model = "null") |> 
  filter(.metric == "roc_auc")

log_metrics1 <- log_fit1 |> 
  collect_metrics() |> 
  mutate(model = "logistic") |> 
  filter(.metric == "roc_auc")

metrics <- null_metrics |> 
  bind_rows(log_metrics1) |> 
  bind_rows(rf_metrics1)

write_csv(metrics, here("basic analysis/basic results/metrics.csv"))

#basic recipe assessment
metrics |> 
  select(.metric, .estimator, mean, n, std_err, model) |> 
  relocate(model) |>
  group_by(model) |> 
  gt() |> 
  tab_header(title = md("**Assessment Metrics**"), 
             subtitle = "Null and Logistic Models - Basic Recipe") |> 
  fmt_number(
    columns = mean, 
    decimals = 3) |> 
  row_group_order(groups = c("null", "logistic", "rf")) |> 
  tab_options(row_group.background.color = "gray50")
