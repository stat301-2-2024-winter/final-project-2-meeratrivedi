# Final Project ----
# Model Analysis - Tuned Models

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(kknn)
library(gt)

# handle common conflicts
tidymodels_prefer()

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# load training data
load(here("data/estate_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("interact analysis/interact recipes/interact_recipe.rda"))

#load fits
load(here("interact analysis/interact results/log_fit3.rda"))
load(here("interact analysis/interact results/tuned_rf3.rda"))
load(here("interact analysis/interact results/tuned_knn3.rda"))
load(here("interact analysis/interact results/tuned_bt3.rda"))
load(here("interact analysis/interact results/tuned_en3.rda"))

log_metrics3 <- log_fit3 |> 
  collect_metrics() |> 
  mutate(model = "logistic") |> 
  filter(.metric == "roc_auc")

en_metrics3 <- tuned_en3 |> 
  show_best(metric = "roc_auc") |> 
  arrange(.metric) |> 
  slice_head(n = 1) |> 
  mutate(model = "en")

knn_metrics3 <- tuned_knn3 |> 
  show_best(metric = "roc_auc") |> 
  arrange(.metric) |> 
  slice_head(n = 1) |> 
  mutate(model = "knn")

rf_metrics3 <- tuned_rf3 |> 
  show_best(metric = "roc_auc") |> 
  arrange(.metric) |> 
  slice_head(n = 1) |> 
  mutate(model = "rf")

bt_metrics3 <- tuned_bt3 |> 
  show_best(metric = "roc_auc") |> 
  arrange(.metric) |> 
  slice_head(n = 1) |> 
  mutate(model = "bt")

metrics3 <- log_metrics3 |> 
  bind_rows(rf_metrics3) |> 
  bind_rows(knn_metrics3) |> 
  bind_rows(bt_metrics3) |> 
  bind_rows(en_metrics3) 

save(metrics3, file = here("interact analysis/interact results/metrics3.rda"))

metrics3 |> 
  select(mean, n, std_err, model) |> 
  arrange(desc(mean)) |> 
  relocate(model) |> 
  gt() |> 
  tab_header(title = md("**Assessment Metrics**"), 
             subtitle = "All Models - Interaction Recipe") |>
  cols_label(std_err = md("Standard Error"), 
             mean = md("Mean ROC AUC"), 
             n = md("Number of Models"), 
             model = md("Model Type")) |> 
  fmt_number(
    columns = mean, 
    decimals = 3) |> 
  fmt_number(
    columns = std_err, 
    decimals = 7) 



