# L05 Resampling ----
# Initial data checks, data splitting, & data folding

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

#load data
realestate <- read_delim("data/Real_Estate_Dataset.csv", 
                         delim = ";", escape_double = FALSE, trim_ws = TRUE) |> 
  clean_names()

load(here("data/clean_qol.rda"))

#transform data

#set.seed
set.seed(1234)

#split data
estate_split <- initial_split(clean_qol, 
                              prop = 0.8, 
                              strata = satisfaction, breaks = 4)
estate_train <- training(estate_split)
estate_test <- testing(estate_split)

#TASK 2----

estate_folds <- vfold_cv(estate_train, v = 10, repeats = 3,
                     strata = satisfaction)

save(estate_train, estate_test, estate_folds, file = here("results/estate_split.rda"))

