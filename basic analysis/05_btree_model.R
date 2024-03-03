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
         learn_rate = learn_rate(range = c()))

btree_grid <- grid_regular(btree_params, levels = 5)

#btree fit


#save(btree_fit, file = here("results/btree_fit.rda"))
