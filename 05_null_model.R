# Final Project ----
# Define and fit null & baseline models

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

# model specifications ----
null_mod <- null_model() |>  
  set_engine("parsnip") |> 
  set_mode("classification")

# define workflows ----
null_wflw <- workflow() |>  
  add_model(null_mod) |> 
  add_recipe(basic_recipe)

null_fit <- null_wflw|> 
  fit_resamples(
    resamples = estate_folds, 
    control = control_resamples(save_workflow = TRUE))

save(null_fit, file = here("results/null_fit.rda"))

#baseline model
baseline_mod <- logistic_reg() |> 
  set_mode("classification") |> 
  set_engine("glm")

basic_workflow <- workflow() |>  
  add_model(baseline_mod) |>  
  add_recipe(basic_recipe)

basic_fit <- basic_workflow |> 
  fit_resamples(
    resamples = estate_folds, 
    control = control_resamples(save_workflow = TRUE))

save(basic_fit, file = here("results/basic_fit.rda"))

