
# Setup pre-processing/recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()


#load data
load(here("results/estate_split.rda"))

#kitchen recipe
kitchen_recipe <- recipe(quality_of_living ~ ., data = estate_train) |> 
  step_rm(name_nsi, district, type, condition, construction_type) |>
  step_filter_missing(all_predictors(), threshold = 0)
step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_center(all_predictors()) |> 
  step_scale(all_predictors())

prep_kitchen <- prep(kitchen_recipe) |> 
  bake(new_data = NULL)

save(kitchen_recipe, file = here("results/kitchen_recipe.rda"))