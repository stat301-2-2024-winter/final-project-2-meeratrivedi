# Final Project ----
# Setup basic and basic tree pre-processing/recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()


#load data
load(here("results/estate_split.rda"))

#null: remove all the missing variables and impute area
#use logistic reg w the basic recipe

#basic recipe - null and logistic
basic_recipe <- recipe(satisfaction ~ ., data = estate_train) |> 
  step_rm(name_nsi, last_reconstruction, energy_costs, 
          orientation, loggia, balkonies, construction_type, 
          year_built, certificate, total_floors, floor, 
          quality_of_living, index, condition, type, district) |>
  step_impute_median(area) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_center(all_predictors()) |> 
  step_scale(all_predictors())

prep_basic <- prep(basic_recipe) |> 
  bake(new_data = NULL) |> 
  view()

save(basic_recipe, file = here("basic analysis/basic recipes/basic_recipe.rda"))

#basic tree recipe - knn en rf btree

basic_tree_recipe <- recipe(satisfaction ~ ., data = estate_train) |> 
  step_rm(name_nsi, last_reconstruction, energy_costs, 
          orientation, loggia, balkonies, construction_type, 
          year_built, certificate, total_floors, floor, 
          quality_of_living, index, condition, type, district) |>
  step_impute_median(area) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_center(all_predictors()) |> 
  step_scale(all_predictors())

prep_basic_tree <- prep(basic_tree_recipe) |> 
  bake(new_data = NULL) |> 
  view()

save(basic_tree_recipe, 
     file = here("basic analysis/basic recipes/basic_tree_recipe.rda"))
