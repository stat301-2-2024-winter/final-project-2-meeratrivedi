# Final Project ----
# Setup pre-processing/recipes for non-tree models

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

#basic recipe
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

save(basic_recipe, file = here("results/basic_recipe.rda"))

#main recipe
main_recipe <- recipe(satisfaction ~ ., data = estate_train) |> 
  update_role(quality_of_living, index, new_role = "indices") |> 
  step_rm(name_nsi, last_reconstruction, energy_costs, 
          orientation, loggia, balkonies, construction_type, 
          year_built, certificate, condition, type, district) |>
  step_impute_median(area) |>
  step_mutate(total_floors = 
                case_when(
                  total_floors >= 23 ~ "23-46",
                  total_floors <= 22 ~ "1-22",
                  NA ~ "unknown"
                  ),
              total_floors = factor(total_floors)) |> 
  step_mutate(floor = 
                case_when(
                  floor >= 15 ~ "15-34",
                  floor < 15 ~ "below 15",
                  NA ~ "unknown"
                  ),
              floor = factor(floor)) |> 
  step_unknown(total_floors, new_level = "unknown") |> 
  step_unknown(floor, new_level = "unknown") |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_center(all_predictors()) |> 
  step_scale(all_predictors())

prep_main <- prep(main_recipe) |> 
  bake(new_data = NULL) |> 
  view()

save(main_recipe, file = here("results/main_recipe.rda"))