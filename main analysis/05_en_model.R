# Final Project ----
# Define and fit elastic net models

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


#elastic net model specifications


#elastic net workflow


#elastic net fit


#save(en_fit, file = here("results/en_fit.rda"))
