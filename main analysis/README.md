## What is in the Main Analysis Folder

This is what can be found in the main analysis folder:

## R Scripts

- `04_main_recipes`: code for the main recipe for non-tree models and the main recipe for tree models

- `05_log_model`: code used for model specifications, workflows, and fits for the logistic model

- `05_en_model`: code used for model specifications, workflows, and fits for the elastic net model

- `05_knn_model`: code used for model specifications, workflows, and fits for the nearest neighbor model

- `05_rf_model`: code used for model specifications, workflows, and fits for the random forest model

- `05_btree_model`: code used for model specifications, workflows, and fits for the boosted tree model

- `06_main_analysis`: code used to complete model analyses for the models on the main recipes. It additionally contains the code used to make the big comparison table of the assessment metrics for all the models on all the recipes, and the code used to make the tables that show the best hyperparameters for the tuned models. 

## Folders

- `main recipes`: contains the `main_recipe` and the `main_tree_recipe` as RDA files

- `main results`: contains the model fits for all 6 models in each R script labeled with a 2 after the model name since there are multiple of these model types throughout this project. It also contains `metrics2.rda` which contains the assessment metric values for all 6 model fits.
