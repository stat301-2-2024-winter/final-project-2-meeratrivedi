# Final Project ----
# Setup pre-processing/recipes for interaction terms models

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

load(here("main analysis/main recipes/main_recipe.rda"))
load(here("main analysis/main recipes/main_tree_recipe.rda"))

interact_recipe <- main_recipe |> 
  step_interact(~price:environment) |> 
  step_interact(~price:relax) |> 
  step_interact(~price:services) |> 
  step_interact(~services:transport) |> 
  step_interact(~environment:safety)

prep_interact <- prep(interact_recipe) |> 
  bake(new_data = NULL) |> 
  view()

save(interact_recipe, file = here("interact analysis/interact recipes/interact_recipe.rda"))

interact_tree_recipe <- main_tree_recipe |> 
  step_interact(~price:environment) |> 
  step_interact(~price:relax) |> 
  step_interact(~price:services) |> 
  step_interact(~services:transport) |> 
  step_interact(~environment:safety)

prep_interact_tree <- prep(interact_tree_recipe) |> 
  bake(new_data = NULL) |> 
  view()

save(interact_tree_recipe, file = here("interact analysis/interact recipes/interact_tree_recipe.rda"))


