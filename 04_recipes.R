
# Setup pre-processing/recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()


#load data
load(here("results/estate_split.rda"))

#make this my fancy one and make the null one just remove all the missing variables and impute area
#use logistic reg w the basic recipe


#kitchen recipe
kitchen_recipe <- recipe(target ~ ., data = estate_train) |> 
  #add other index variables to this list
  update_role(quality_of_living, new_role = "indices") |> 
  #remove index variables
  #step_rm(name_nsi, district, type, condition, construction_type) |>
  #step_rm top missing variables up till yrbuilt
  step_impute_median(area) |> 
  #certificate total floors and floor make category be "unknown" as an ex with step_mutate
  #case when if else statement pipe to factor
  #then do step_unknown to change the category to be unknown (no more than 2-3 levels for each one)
  step_filter_missing(all_predictors(), threshold = 0) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_center(all_predictors()) |> 
  step_scale(all_predictors())

prep_kitchen <- prep(kitchen_recipe) |> 
  bake(new_data = NULL)

save(kitchen_recipe, file = here("results/kitchen_recipe.rda"))