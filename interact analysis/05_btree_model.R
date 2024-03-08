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
load(here("results/estate_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("interact analysis/interact recipes/interact_tree_recipe.rda"))

set.seed(1234)

#btree model specifications
btree_mod3 <- boost_tree(
  mtry = tune(), 
  min_n = tune(), 
  learn_rate = tune()) |> 
  set_engine("xgboost") |> 
  set_mode("classification")

#btree workflow
btree_wflw3 <- workflow() |> 
  add_model(btree_mod3) |> 
  add_recipe(interact_tree_recipe)

#hyperparameter tuning values ----
btree_params3 <- extract_parameter_set_dials(btree_mod3) |> 
  update(mtry = mtry(range = c(1, 11)), 
         learn_rate = learn_rate(range = c(-5,-0.2)))

btree_grid3 <- grid_regular(btree_params3, levels = 5)

#btree fit
tuned_bt3 <- tune_grid(btree_wflw3, 
                       resamples = estate_folds,
                       grid = btree_grid3, 
                       control = control_grid(save_workflow = TRUE))

save(tuned_bt3, file = here("interact analysis/interact results/tuned_bt3.rda"))
