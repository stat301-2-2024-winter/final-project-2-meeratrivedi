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
load(here("basic analysis/basic recipes/basic_tree_recipe.rda"))

set.seed(1234)


#rf model specifications
rf_mod1 <- rand_forest(mode = "classification", 
                        trees = 500, 
                        min_n = tune(), 
                        mtry = tune()) |> 
  set_engine('ranger')

#rf workflow
rf_wflw1 <- workflow() |> 
  add_model(rf_mod1) |> 
  add_recipe(basic_tree_recipe)


#hyperparameter tuning values ----
rf_params1 <- extract_parameter_set_dials(rf_mod1) |> 
  update(mtry = mtry(range = c(1, 11)))

rf_grid1 <- grid_regular(rf_params1, levels = 5)

#rf fit
tuned_rf <- tune_grid(rf_wflw1, 
                      resamples = estate_folds,
                      grid = rf_grid1,
                      control = control_grid(save_workflow = TRUE))


save(tuned_rf, file = here("basic analysis/basic results/tuned_rf1.rda"))

tuned_rf

show_best(tuned_rf, metric = "accuracy")
