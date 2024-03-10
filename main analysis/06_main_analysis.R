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
load(here("data/estate_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("main analysis/main recipes/main_recipe.rda"))

#load fits
load(here("main analysis/main results/log_fit2.rda"))
load(here("main analysis/main results/tuned_rf2.rda"))
load(here("main analysis/main results/tuned_knn2.rda"))
load(here("main analysis/main results/tuned_bt2.rda"))
load(here("main analysis/main results/tuned_en2.rda"))

load(here("basic analysis/basic results/metrics.rda"))
load(here("interact analysis/interact results/metrics3.rda"))

#load fits
load(here("interact analysis/interact results/log_fit3.rda"))
load(here("interact analysis/interact results/tuned_rf3.rda"))
load(here("interact analysis/interact results/tuned_knn3.rda"))
load(here("interact analysis/interact results/tuned_bt3.rda"))
load(here("interact analysis/interact results/tuned_en3.rda"))


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
  select(mean, n, std_err, model) |> 
  arrange(desc(mean)) |> 
  relocate(model) |> 
  gt() |> 
  tab_header(title = md("**Assessment Metrics**"), 
             subtitle = "All Models - Main Recipe") |>
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


bestparams_rf <- select_best(tuned_rf, metric = "roc_auc") |>
  mutate(recipe = "basic") |> 
  bind_rows(select_best(tuned_rf2, metric = "roc_auc")|>
              mutate(recipe = "main")) |> 
  bind_rows(select_best(tuned_rf3, metric = "roc_auc")|>
              mutate(recipe = "interactions")) |> 
  select(-.config) |> 
  relocate(recipe)

save(bestparams_rf, file = here("final analysis/best hyperparameters/bestparams_rf.rda"))

#random forest hyperparams
bestparams_rf |> 
  gt()|> 
  tab_header(title = md("**Best Hyperparameters - Random Forest**"), 
             subtitle = "Random Forest - All Recipes") |>
  cols_label(recipe = md("Recipe"), 
             mtry = md("Number of <br> Sample Predictors"), 
             min_n = md("Minimal <br> Node Size")) 

#knn hyperparams
bestparams_knn <- select_best(tuned_knn1, metric = "roc_auc") |>
  mutate(recipe = "basic") |> 
  bind_rows(select_best(tuned_knn2, metric = "roc_auc")|>
              mutate(recipe = "main")) |> 
  bind_rows(select_best(tuned_knn3, metric = "roc_auc")|>
              mutate(recipe = "interactions")) |> 
  select(-.config) |> 
  relocate(recipe)

save(bestparams_knn, file = here("final analysis/best hyperparameters/bestparams_knn.rda"))

bestparams_knn |> 
  gt()|> 
  tab_header(title = md("**Best Hyperparameters - Nearest Neighbors**"), 
             subtitle = "Nearest Neighbors - All Recipes") |>
  cols_label(recipe = md("Recipe"), 
             neighbors = md("Neighbors")) 

#boosted tree hyperparams
bestparams_bt <- select_best(tuned_bt1, metric = "roc_auc") |>
  mutate(recipe = "basic") |> 
  bind_rows(select_best(tuned_bt2, metric = "roc_auc")|>
              mutate(recipe = "main")) |> 
  bind_rows(select_best(tuned_bt3, metric = "roc_auc")|>
              mutate(recipe = "interactions")) |> 
  select(-.config) |> 
  relocate(recipe)

save(bestparams_bt, file = here("final analysis/best hyperparameters/bestparams_bt.rda"))

bestparams_bt |> 
  gt()|> 
  tab_header(title = md("**Best Hyperparameters - Boosted Tree**"), 
             subtitle = "Boosted Tree - All Recipes") |>
  cols_label(recipe = md("Recipe"), 
             mtry = md("Number of <br> Sample Predictors"), 
             min_n = md("Minimal<br> Node Size"), 
             learn_rate = md("Learning <br> Rate")) |> 
  fmt_number(
    columns = learn_rate, 
    decimals = 3)

#elastic net hyperparams
bestparams_en <- select_best(tuned_en1, metric = "roc_auc") |>
  mutate(recipe = "basic") |> 
  bind_rows(select_best(tuned_en2, metric = "roc_auc")|>
              mutate(recipe = "main")) |> 
  bind_rows(select_best(tuned_en3, metric = "roc_auc")|>
              mutate(recipe = "interactions")) |> 
  select(-.config) |> 
  relocate(recipe)

save(bestparams_en, file = here("final analysis/best hyperparameters/bestparams_en.rda"))

bestparams_en |> 
  gt()|> 
  tab_header(title = md("**Best Hyperparameters - Elastic Net**"), 
             subtitle = "Elastic Net - All Recipes") |>
  cols_label(recipe = md("Recipe"), 
             penalty = md("Penalty"), 
             mixture = md("Mixture")) |> 
  fmt_number(
    columns = penalty, 
    decimals = 3)

