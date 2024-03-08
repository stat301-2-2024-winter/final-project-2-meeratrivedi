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
load(here("basic analysis/basic recipes/basic_tree_recipe.rda"))

set.seed(1234)

#btree model specifications
btree_mod1 <- boost_tree(
  mtry = tune(), 
  min_n = tune(), 
  learn_rate = tune()) |> 
  set_engine("xgboost") |> 
  set_mode("classification")

#btree workflow
btree_wflw1 <- workflow() |> 
  add_model(btree_mod1) |> 
  add_recipe(basic_tree_recipe)

#hyperparameter tuning values ----
btree_params1 <- extract_parameter_set_dials(btree_mod1) |> 
  update(mtry = mtry(range = c(1, 11)), 
         learn_rate = learn_rate(range = c(-5,-0.2)))

btree_grid1 <- grid_regular(btree_params1, levels = 5)

#btree fit
tuned_bt1 <- tune_grid(btree_wflw1, 
                        resamples = estate_folds,
                        grid = btree_grid1, 
                        control = control_grid(save_workflow = TRUE))

save(tuned_bt1, file = here("basic analysis/basic results/tuned_bt1.rda"))
