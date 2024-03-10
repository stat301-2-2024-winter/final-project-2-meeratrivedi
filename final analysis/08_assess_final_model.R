# Final Project
# Assess final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)
library(gt)

# handle common conflicts
tidymodels_prefer()

load(here("basic analysis/basic results/tuned_rf1.rda"))
load(here("final analysis/results/best_fit_rf.rda"))
load(here("data/estate_split.rda"))

pred_rf <- estate_test |> 
  select(satisfaction) |> 
  bind_cols(predict(best_fit_rf, estate_test)) |> 
  rename(rf_pred = .pred_class)

save(pred_rf, file = here("final analysis/results/pred_rf.rda"))

#accuracy
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

roc_auc <- roc_auc(estate_result, satisfaction, .pred_satisfied)

#accuracy & roc_auc
accuracy_roc_auc <- roc_auc |> 
  bind_rows(accuracy(pred_rf, satisfaction, rf_pred))

save(accuracy_roc_auc, file = here("final analysis/results/accuracy_roc_auc.rda"))

accuracy_roc_auc |> 
  select(-.estimator) |> 
  gt() |> 
  tab_header(title = md("**ROC AUC & Accuracy**")) |>
  cols_label(.metric = md("Assessment Metric"), 
             .estimate = md("Estimate")) |>
  fmt_number(
    columns = .estimate, 
    decimals = 3)


#autoplot
estate_curve <- roc_curve(estate_result, satisfaction, .pred_satisfied)

autoplot(estate_curve)

ggsave("final analysis/results/roc_curve.png") 


#confusion matrix
conf_mat <- conf_mat(pred_rf, satisfaction, rf_pred)

autoplot(conf_mat, type = "heatmap")+
  labs(x = "Truth", y = "Prediction", 
       title = "Confusion Matrix")+
  theme(plot.title = element_text(hjust = 0.5, size = 10, face = "bold"), 
        axis.title.x = element_text(hjust = 0.5, size = 10, face = "bold"), 
        axis.title.y = element_text(hjust = 0.5, size = 10, face = "bold"))

ggsave("final analysis/results/conf_mat.png") 
