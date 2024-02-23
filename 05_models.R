# L05 Resampling ----
# Define and fit ...

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(kknn)

# handle common conflicts
tidymodels_prefer()

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# load training data
load(here("results/estate_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("results/kitchen_recipe.rda"))

set.seed(1234)

#classification: null/naive bayes, logistic, elastic net, knn, rf, btree

# model specifications ----


# define workflows ----
#log_workflow <- workflow() |> 
#  add_model(log_model) |> 
#  add_recipe(kitchen_recipe)


#fit_folds_lm <- fit_resamples(lm_workflow, 
                            #  resamples = estate_folds)

#save(fit_folds_lm, file = here("results/fit_folds_lm.rda"))

#metrics <- fit_folds_lm |> 
#  collect_metrics() |> 
#  mutate(model = "lm") |>  
  #bind_rows(fit_folds_ridge |>  collect_metrics() |>  mutate(model = "ridge")) |>  
  #bind_rows(fit_folds_lasso |>  collect_metrics() |>  mutate(model = "lasso")) |> 
 # bind_rows(fit_folds_rf |>  collect_metrics() |>  mutate(model = "rf")) |>  
 # bind_rows(fit_folds_knn |>  collect_metrics() |>  mutate(model = "knn")) |>  
  # we are going to choose roc_auc as our metric
#  filter(.metric == "rmse" | .metric == "rsq")

#metrics |>  
#  select(.metric, model, mean, std_err) |>  
#  group_by(.metric) |> 
#  gt() |> 
#  row_group_order(groups = c("rmse", "rsq")) |> 
#  tab_options(row_group.background.color = "gray40")



