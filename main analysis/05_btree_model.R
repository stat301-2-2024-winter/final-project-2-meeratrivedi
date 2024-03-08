# Final Project ----
# Define and fit boosted tree models

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(xgboost)

# handle common conflicts
tidymodels_prefer()

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# load training data
load(here("data/estate_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("main analysis/main recipes/main_tree_recipe.rda"))

set.seed(1234)

#btree model specifications
btree_mod2 <- boost_tree(
  mtry = tune(), 
  min_n = tune(), 
  learn_rate = tune()) |> 
  set_engine("xgboost") |> 
  set_mode("classification")

#btree workflow
btree_wflw2 <- workflow() |> 
  add_model(btree_mod2) |> 
  add_recipe(main_tree_recipe)

#hyperparameter tuning values ----
btree_params2 <- extract_parameter_set_dials(btree_mod2) |> 
  update(mtry = mtry(range = c(1, 11)), 
         learn_rate = learn_rate(range = c(-5,-0.2)))

btree_grid2 <- grid_regular(btree_params2, levels = 5)

#btree fit
tuned_bt2 <- tune_grid(btree_wflw2, 
                       resamples = estate_folds,
                       grid = btree_grid2, 
                       control = control_grid(save_workflow = TRUE))

save(tuned_bt2, file = here("main analysis/main results/tuned_bt2.rda"))
