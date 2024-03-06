# Final Project ----
# Define and fit knn models

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
load(here("interact analysis/interact recipes/interact_tree_recipe.rda"))

set.seed(1234)

#knn model specifications
knn_mod3 <- nearest_neighbor(
  mode = "classification", 
  neighbors = tune()) |> 
  set_engine("kknn")

#knn workflow
knn_wflw3 <- workflow() |> 
  add_model(knn_mod3) |> 
  add_recipe(interact_tree_recipe)

#hyperparameter tuning values ----
knn_params3 <- extract_parameter_set_dials(knn_mod3)

knn_grid3 <- grid_regular(knn_params3, levels = 5)

#knn fit
tuned_knn3 <- tune_grid(knn_wflw3, 
                        resamples = estate_folds,
                        grid = knn_grid3, 
                        control = control_grid(save_workflow = TRUE))

save(tuned_knn3, file = here("interact analysis/interact results/tuned_knn3.rda"))

