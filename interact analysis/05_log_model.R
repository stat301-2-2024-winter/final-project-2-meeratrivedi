# Final Project ----
# Define and fit logistic model

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
load(here("interact analysis/interact recipes/interact_recipe.rda"))

set.seed(1234)


logistic_mod3 <- logistic_reg() |> 
  set_engine("glm") |> 
  set_mode("classification")

log_wflw3 <- workflow() |> 
  add_model(logistic_mod3) |> 
  add_recipe(interact_recipe)

log_fit3 <- log_wflw3 |> 
  fit_resamples(
    resamples = estate_folds, 
    control = control_resamples(save_workflow = TRUE))

save(log_fit3, file = here("interact analysis/interact results/log_fit3.rda"))

