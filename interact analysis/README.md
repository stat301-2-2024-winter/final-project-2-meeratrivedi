## What is in the Interact Analysis Folder

This is what can be found in the interact analysis folder:

## R Scripts

- `04_interact_recipes`: code for the recipe that includes interaction terms for non-tree models and the recipe that includes interaction terms for for tree models

- `05_log_model`: code used for model specifications, workflows, and fits for the logistic model

- `05_en_model`: code used for model specifications, workflows, and fits for the elastic net model

- `05_knn_model`: code used for model specifications, workflows, and fits for the nearest neighbor model

- `05_rf_model`: code used for model specifications, workflows, and fits for the random forest model

- `05_btree_model`: code used for model specifications, workflows, and fits for the boosted tree model

- `06_interact_analysis`: code used to complete model analyses for the models on the interaction recipes. 

## Folders

- `interact recipes`: contains the `interact_recipe` and the `interact_tree_recipe` as RDA files

- `interact results`: contains the model fits for all 6 models in each R script labeled with a 3 after the model name since there are multiple of these model types throughout this project. It also contains `metrics3.rda` which contains the assessment metric values for all 6 model fits.
