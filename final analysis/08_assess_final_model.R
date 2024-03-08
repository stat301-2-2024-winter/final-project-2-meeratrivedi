# Final Project
# Assess final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

# handle common conflicts
tidymodels_prefer()

load(here("basic analysis/basic results/tuned_rf1.rda"))
load(here("results/best_fit_rf.rda"))
load(here("results/estate_split.rda"))

pred_rf <- estate_test |> 
  select(satisfaction) |> 
  bind_cols(predict(best_fit_rf, estate_test)) |> 
  rename(rf_pred = .pred_class)

pred_rf |> 
  accuracy(satisfaction, rf_pred) 

#roc_auc
pred_class <- predict(best_fit_rf, estate_test, type = "class")

# obtain probability of category
pred_prob <- predict(best_fit_rf, estate_test, type = "prob")

# bind cols together
estate_result <- estate_test |> 
  select(satisfaction) |>
  bind_cols(pred_class, pred_prob)

estate_result |> 
  slice_head(n = 5)

roc_auc(estate_result, satisfaction, .pred_satisfied)

#autoplot
estate_curve <- roc_curve(estate_result, satisfaction, .pred_satisfied)

autoplot(estate_curve)

#confusion matrix
conf_mat(pred_rf, satisfaction, rf_pred)



