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
load(here("main analysis/main recipes/interact_recipe.rda"))

#load fits
load(here("main analysis/main results/log_fit3.rda"))
#load(here("main analysis/main results/tuned_rf2.rda"))
#load(here("main analysis/main results/tuned_knn2.rda"))
#load(here("main analysis/main results/tuned_bt2.rda"))
#load(here("main analysis/main results/tuned_en2.rda"))

log_metrics3 <- log_fit3 |> 
  collect_metrics() |> 
  mutate(model = "logistic") |> 
  filter(.metric == "roc_auc")


