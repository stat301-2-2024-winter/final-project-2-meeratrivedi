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

#basic tree recipe

#save(basic_tree_recipe, file = here("results/basic_tree_recipe.rda"))

#main tree recipe

#save(main_tree_recipe, file = here("results/main_tree_recipe.rda"))

