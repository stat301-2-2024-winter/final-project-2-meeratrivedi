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
load(here("results/estate_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("main analysis/main recipes/main_tree_recipe.rda"))

set.seed(1234)

#elastic net model specifications
en_mod2 <- logistic_reg(
  mixture = tune(), 
  penalty = tune()) |> 
  set_engine("glmnet") |> 
  set_mode("classification")

#elastic net workflow
en_wflw2 <- workflow() |> 
  add_model(en_mod2) |> 
  add_recipe(main_tree_recipe)

#hyperparameter tuning values ----
en_params2 <- extract_parameter_set_dials(en_mod2) |> 
  update(mixture = mixture(c(0, 1)), 
         penalty = penalty(c(-5, 0.2)))

en_grid2 <- grid_regular(en_params2, levels = 5)

#elastic net fit
tuned_en2 <- tune_grid(en_wflw2, 
                       resamples = estate_folds,
                       grid = en_grid2, 
                       control = control_grid(save_workflow = TRUE))

save(tuned_en2, file = here("main analysis/main results/tuned_en2.rda"))
