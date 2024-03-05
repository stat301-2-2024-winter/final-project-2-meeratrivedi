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

#load fits
load(here("basic analysis/basic results/null_fit.rda"))
load(here("basic analysis/basic results/log_fit1.rda"))
load(here("basic analysis/basic results/tuned_rf1.rda"))
load(here("basic analysis/basic results/tuned_knn1.rda"))
load(here("basic analysis/basic results/tuned_bt1.rda"))
load(here("basic analysis/basic results/tuned_en1.rda"))


null_metrics <- null_fit |> 
  collect_metrics() |> 
  mutate(model = "null") |> 
  filter(.metric == "roc_auc")

log_metrics1 <- log_fit1 |> 
  collect_metrics() |> 
  mutate(model = "logistic") |> 
  filter(.metric == "roc_auc")

rf_metrics1 <- tuned_rf |> 
  show_best(metric = "roc_auc") |> 
  arrange(.metric) |> 
  slice_head(n = 1) |> 
  mutate(model = "rf")
#more area under the curve, closer to 1 the better

knn_metrics1 <- tuned_knn1 |> 
  show_best(metric = "roc_auc") |> 
  arrange(.metric) |> 
  slice_head(n = 1) |> 
  mutate(model = "knn")

bt_metrics1 <- tuned_bt1 |> 
  show_best(metric = "roc_auc") |> 
  arrange(.metric) |> 
  slice_head(n = 1) |> 
  mutate(model = "bt")

en_metrics1 <- tuned_en1 |> 
  show_best(metric = "roc_auc") |> 
  arrange(.metric) |> 
  slice_head(n = 1) |> 
  mutate(model = "en")

metrics <- null_metrics |> 
  bind_rows(log_metrics1) |> 
  bind_rows(rf_metrics1) |> 
  bind_rows(knn_metrics1) |> 
  bind_rows(bt_metrics1) |> 
  bind_rows(en_metrics1) |> 
  select(.metric, .estimator, mean, n, std_err, model) 


write_csv(metrics, here("basic analysis/basic results/metrics.csv"))

#basic recipe assessment
metrics |> 
  select(.estimator, mean, n, std_err, model) |> 
  relocate(model) |>
  arrange(desc(mean)) |> 
  #group_by(model) |> 
 # mutate(.metric = "ROC AUC") |> 
  gt() |> 
  tab_header(title = md("**Assessment Metrics**"), 
             subtitle = "All Models - Basic Recipe") |>
  cols_label(#.metric = md("Assessment Metric"), 
             .estimator = md("Estimator"), 
             std_err = md("Standard Error"), 
             mean = md("Mean ROC AUC"), 
             n = md("Number of Models")) |> 
  fmt_number(
    columns = mean, 
    decimals = 3) |> 
  fmt_number(
    columns = std_err, 
    decimals = 5) 
  #row_group_order(groups = c("null", "logistic", "rf", "knn", "bt", "en")) |> 
  #tab_options(row_group.background.color = "grey50")
