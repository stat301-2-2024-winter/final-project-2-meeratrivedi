# Final Project ----
# Define and fit random forest models

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


#rf model specifications


#rf workflow


#hyperparameter tuning values ----


#rf fit


#save(rf_fit, file = here("results/rf_fit.rda"))
