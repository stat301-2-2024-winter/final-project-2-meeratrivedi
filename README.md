## Basic repo setup for final project

This repo contains all the work for my final project about apartment listings in Slovakia, and how we can use data about them to predict the satisfaction. 

# What the Repo Contains

## Folders

- `data`: In this folder you can find the raw data

- `memos`: In this folder you can find my progress memos.

- `results`: In this folder you can find the split data, recipes, and model fits, and assessment metrics


## R Scripts

- `01_data_setup`: reads in the data and has some data cleaning and subsetting

- `02_target_analysis`: explores the target variable: `satisfaction` and includes old code that explores the `quality_of_living` variable 

- `03_splitting`: splits data into training and testing data sets, and uses V-fold cross validation on the training data set

- `04_recipes`: has the basic recipe for non-tree models and the main recipe for non-tree models. may eventually include another more complicated recipe for non-tree models

- `04_tree_recipes` will contain all tree model recipes

- `05_null_model`: code used for model specifications, workflow, and fit for the null model

- `05_log_model`: code used for model specifications, workflows, and fits for the logistic models

- `05_en_model`: code used for model specifications, workflows, and fits for the elastic net models

- `05_knn_model`: code used for model specifications, workflows, and fits for the nearest neighbor models

- `05_rf_model`: code used for model specifications, workflows, and fits for the random forest models

- `05_btree_model`: code used for model specifications, workflows, and fits for the boosted tree models

- `06_model_analysis`: code used to complete model analyses for the models that do not use tuning

- `06_tuned_analysis`: code used to complete model analyses for the models that use tuning


