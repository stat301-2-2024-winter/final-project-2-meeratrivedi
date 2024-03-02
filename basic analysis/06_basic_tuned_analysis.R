# Final Project ----
# Model Analysis - Tuned Models

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(kknn)
library(gt)

# handle common conflicts
tidymodels_prefer()

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# load training data
load(here("results/estate_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("results/basic_recipe.rda"))
load(here("results/main_recipe.rda"))

#load fits