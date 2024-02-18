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

clean_qol <- read_csv(here("data/clean_qol.csv"))

#transform data


#set.seed
set.seed(1234)

#split data
estate_split <- initial_split(clean_qol, 
                              prop = 0.8, 
                              strata = quality_of_living, breaks = 4)
estate_train <- training(estate_split)
estate_test <- testing(estate_split)

#TASK 2----

estate_folds <- vfold_cv(estate_train, v = 10, repeats = 3,
                     strata = quality_of_living)

save(estate_train, estate_test, estate_folds, file = here("results/estate_split.rda"))

main_recipe <- recipe(quality_of_living ~ ., data = estate_train) |> 
  step_rm(name_nsi, district, type, condition, construction_type) |>
  step_filter_missing(all_predictors(), threshold = 0)
  step_dummy(all_nominal_predictors()) |> 
  #step_log(sqft_living, sqft_lot, sqft_above, sqft_living15, sqft_lot15, base = 10) |> 
  #step_mutate(sqft_basement = if_else(sqft_basement >0, 1, 0)) |> 
  #step_ns(lat, deg_free = 5) |> 
  step_zv(all_predictors()) |> 
  step_center(all_predictors()) |> 
  step_scale(all_predictors())

prep_main <- prep(main_recipe) |> 
  bake(new_data = NULL)

save(main_recipe, file = here("results/main_recipe.rda"))

