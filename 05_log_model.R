# L05 Resampling ----
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
load(here("results/basic_recipe.rda"))
load(here("results/main_recipe.rda"))

set.seed(1234)

#logistic model - basic recipe
logistic_mod1 <- logistic_reg() |> 
  set_engine("glm") |> 
  set_mode("classification")

log_wflw1 <- workflow() |> 
  add_model(logistic_mod) |> 
  add_recipe(basic_recipe)

log_fit1 <- log_wflw |> 
  fit_resamples(
    resamples = estate_folds, 
    control = control_resamples(save_workflow = TRUE))

save(log_fit1, file = here("results/log_fit1.rda"))


#logistic model - main recipe
logistic_mod2 <- logistic_reg() |> 
  set_engine("glm") |> 
  set_mode("classification")

log_wflw2 <- workflow() |> 
  add_model(logistic_mod) |> 
  add_recipe(main_recipe)

log_fit2 <- log_wflw |> 
  fit_resamples(
    resamples = estate_folds, 
    control = control_resamples(save_workflow = TRUE))

save(log_fit2, file = here("results/log_fit2.rda"))
