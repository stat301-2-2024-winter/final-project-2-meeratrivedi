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
load(here("basic analysis/basic recipes/basic_recipe.rda"))
load(here("basic analysis/basic recipes/basic_tree_recipe.rda"))

set.seed(1234)


#knn model specifications
knn_mod1 <- nearest_neighbor(
  mode = "classification", 
  neighbors = tune()) |> 
  set_engine("kknn")

#knn workflow
knn_wflw1 <- workflow() |> 
  add_model(knn_mod1) |> 
  add_recipe(basic_tree_recipe)


#hyperparameter tuning values ----
knn_params1 <- extract_parameter_set_dials(knn_mod1)

knn_grid1 <- grid_regular(knn_params1, levels = 5)

#knn fit
tuned_knn1 <- tune_grid(knn_wflw1, 
                       resamples = estate_folds,
                       grid = knn_grid1, 
                       control = control_grid(save_workflow = TRUE))

save(tuned_knn1, file = here("basic analysis/basic results/tuned_knn1.rda"))

