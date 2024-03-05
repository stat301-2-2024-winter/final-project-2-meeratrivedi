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
load(here("main analysis/main recipes/main_tree_recipe.rda"))

set.seed(1234)


rf_mod2 <- rand_forest(mode = "classification", 
                       trees = 750, 
                       min_n = tune(), 
                       mtry = tune()) |> 
  set_engine('ranger')

#rf workflow
rf_wflw2<- workflow() |> 
  add_model(rf_mod2) |> 
  add_recipe(main_tree_recipe)


#hyperparameter tuning values ----
rf_params2 <- extract_parameter_set_dials(rf_mod2) |> 
  update(mtry = mtry(range = c(1, 11)))

rf_grid2 <- grid_regular(rf_params2, levels = 5)

#rf fit
tuned_rf2 <- tune_grid(rf_wflw2, 
                      resamples = estate_folds,
                      grid = rf_grid2,
                      control = control_grid(save_workflow = TRUE))


save(tuned_rf2, file = here("main analysis/main results/tuned_rf2.rda"))

