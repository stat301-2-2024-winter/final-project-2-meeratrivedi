# Final Project ----
# Define and fit random forest models

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# load training data
load(here("results/estate_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("interact analysis/interact recipes/interact_tree_recipe.rda"))

set.seed(1234)


rf_mod3 <- rand_forest(mode = "classification", 
                       trees = 750, 
                       min_n = tune(), 
                       mtry = tune()) |> 
  set_engine('ranger')

#rf workflow
rf_wflw3<- workflow() |> 
  add_model(rf_mod3) |> 
  add_recipe(interact_tree_recipe)


#hyperparameter tuning values ----
rf_params3 <- extract_parameter_set_dials(rf_mod3) |> 
  update(mtry = mtry(range = c(1, 11)))

rf_grid3 <- grid_regular(rf_params3, levels = 5)

#rf fit
tuned_rf3 <- tune_grid(rf_wflw3, 
                       resamples = estate_folds,
                       grid = rf_grid3,
                       control = control_grid(save_workflow = TRUE))


save(tuned_rf3, file = here("interact analysis/interact results/tuned_rf3.rda"))

