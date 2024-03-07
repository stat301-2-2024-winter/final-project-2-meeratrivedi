# Final Project ----
# Model Analysis - Non-Tuned Models

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(gt)
library(gtExtras)

# handle common conflicts
tidymodels_prefer()

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# load training data
load(here("results/estate_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("results/main_recipe.rda"))

#load fits
load(here("main analysis/main results/log_fit2.rda"))
load(here("main analysis/main results/tuned_rf2.rda"))
load(here("main analysis/main results/tuned_knn2.rda"))
load(here("main analysis/main results/tuned_bt2.rda"))
load(here("main analysis/main results/tuned_en2.rda"))

load(here("basic analysis/basic results/metrics.rda"))
load(here("interact analysis/interact results/metrics3.rda"))


#main recipe assessment
log_metrics2 <- log_fit2 |> 
  collect_metrics() |> 
  mutate(model = "logistic") |> 
  filter(.metric == "roc_auc")

rf_metrics2 <- tuned_rf2 |> 
  show_best(metric = "roc_auc") |> 
  arrange(.metric) |> 
  slice_head(n = 1) |> 
  mutate(model = "rf")

knn_metrics2 <- tuned_knn2 |> 
  show_best(metric = "roc_auc") |> 
  arrange(.metric) |> 
  slice_head(n = 1) |> 
  mutate(model = "knn")

bt_metrics2 <- tuned_bt2 |> 
  show_best(metric = "roc_auc") |> 
  arrange(.metric) |> 
  slice_head(n = 1) |> 
  mutate(model = "bt")

en_metrics2 <- tuned_en2 |> 
  show_best(metric = "roc_auc") |> 
  arrange(.metric) |> 
  slice_head(n = 1) |> 
  mutate(model = "en")


metrics2 <- log_metrics2 |> 
  bind_rows(rf_metrics2) |> 
  bind_rows(knn_metrics2) |> 
  bind_rows(bt_metrics2) |> 
  bind_rows(en_metrics2) 

save(metrics2, file = here("main analysis/main results/metrics2.rda"))


metrics2 |> 
  select(.estimator, mean, n, std_err, model) |> 
  arrange(desc(mean)) |> 
  relocate(model) |> 
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
    decimals = 7) 
  #row_group_order(groups = c("logistic")) |> 
  #tab_options(row_group.background.color = "gray50")

#comparison table
metrics |> 
  mutate(recipe = "basic") |> 
  bind_rows(metrics2 |> mutate(recipe = "main")) |>
  bind_rows(metrics3 |> mutate(recipe = "interactions")) |> 
  select(mean, n, std_err, model, recipe) |> 
  relocate(recipe, model) |>
  group_by(model) |> 
  arrange(desc(mean)) |> 
  gt() |> 
  tab_header(title = md("**Assessment Metrics**"), 
             subtitle = "All Models - All Recipes") |>
  cols_label(recipe = md("Recipe"), 
    std_err = md("Standard Error"), 
    mean = md("Mean ROC AUC"), 
    n = md("Number of Models")) |> 
  fmt_number(
    columns = mean, 
    decimals = 3) |> 
  fmt_number(
    columns = std_err, 
    decimals = 5) |> 
  row_group_order(groups = c("rf", "bt", "knn", "en", "logistic")) |> 
  tab_options(row_group.background.color = "grey50")
