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
load(here("basic analysis/basic recipes/basic_recipe.rda"))

set.seed(1234)


#elastic net model specifications
en_mod1 <- logistic_reg(
  mixture = tune(), 
  penalty = tune()) |> 
  set_engine("glmnet") |> 
  set_mode("classification")

#elastic net workflow
en_wflw1 <- workflow() |> 
  add_model(en_mod1) |> 
  add_recipe(basic_recipe)

#hyperparameter tuning values ----
en_params1 <- extract_parameter_set_dials(en_mod1) |> 
  update(mixture = mixture(c(0, 1)), 
         penalty = penalty(c(-5, 0.2)))

en_grid1 <- grid_regular(en_params1, levels = 5)

#elastic net fit
tuned_en1 <- tune_grid(en_wflw1, 
                       resamples = estate_folds,
                       grid = en_grid1, 
                       control = control_grid(save_workflow = TRUE))

save(tuned_en1, file = here("basic analysis/basic results/tuned_en1.rda"))
