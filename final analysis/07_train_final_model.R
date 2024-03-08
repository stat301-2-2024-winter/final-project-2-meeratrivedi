# Final Project
# Train final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

# handle common conflicts
tidymodels_prefer()

load(here("basic analysis/basic results/tuned_rf1.rda"))
load(here("results/estate_split.rda"))

rf_wflw4 <- tuned_rf |> 
  extract_workflow(tuned_rf) |> 
  finalize_workflow(select_best(tuned_rf, metric = "roc_auc"))

best_fit_rf <- fit(rf_wflw4, data = estate_train)

save(best_fit_rf, file = here("results/best_fit_rf.rda"))
