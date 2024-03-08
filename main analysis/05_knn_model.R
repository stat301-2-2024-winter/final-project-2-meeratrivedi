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
load(here("data/estate_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("main analysis/main recipes/main_tree_recipe.rda"))

set.seed(1234)

#knn model specifications
knn_mod2 <- nearest_neighbor(
  mode = "classification", 
  neighbors = tune()) |> 
  set_engine("kknn")

#knn workflow
knn_wflw2 <- workflow() |> 
  add_model(knn_mod2) |> 
  add_recipe(main_tree_recipe)

#hyperparameter tuning values ----
knn_params2 <- extract_parameter_set_dials(knn_mod2)

knn_grid2 <- grid_regular(knn_params2, levels = 5)

#knn fit
tuned_knn2 <- tune_grid(knn_wflw2, 
                        resamples = estate_folds,
                        grid = knn_grid2, 
                        control = control_grid(save_workflow = TRUE))

save(tuned_knn2, file = here("main analysis/main results/tuned_knn2.rda"))

