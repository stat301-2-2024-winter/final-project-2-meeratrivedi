# Final Project ----
# Define and fit boosted tree models

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(xgboost)

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


#btree model specifications


#btree workflow


#hyperparameter tuning values ----


#btree fit


#save(btree_fit, file = here("results/btree_fit.rda"))
