# Final Project ----
# Define and fit elastic net models

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# load training data
load(here("data/estate_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("interact analysis/interact recipes/interact_tree_recipe.rda"))

set.seed(1234)

#elastic net model specifications
en_mod3 <- logistic_reg(
  mixture = tune(), 
  penalty = tune()) |> 
  set_engine("glmnet") |> 
  set_mode("classification")

#elastic net workflow
en_wflw3 <- workflow() |> 
  add_model(en_mod3) |> 
  add_recipe(interact_tree_recipe)

#hyperparameter tuning values ----
en_params3 <- extract_parameter_set_dials(en_mod3) |> 
  update(mixture = mixture(c(0, 1)), 
         penalty = penalty(c(-5, 0.2)))

en_grid3 <- grid_regular(en_params3, levels = 5)

#elastic net fit
tuned_en3 <- tune_grid(en_wflw3, 
                       resamples = estate_folds,
                       grid = en_grid3, 
                       control = control_grid(save_workflow = TRUE))

save(tuned_en3, file = here("interact analysis/interact results/tuned_en3.rda"))
