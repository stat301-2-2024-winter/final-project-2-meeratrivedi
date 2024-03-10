## What is in the Final Analysis Folder

This is what can be found in the final analysis folder:

## R Scripts

- `07_train_final_model`: code used to fit/train winning model (random forest on basic recipe) to the entire training dataset

- `08_assess_final_model`: code used to assess winning model on the testing dataset. Includes a prediction table, accuracy, area under ROC curve, ROC curve, and a confusion matrix. 


## Folders

- `best hyperparameters`: contains the resulting RDA files from finding the best hyperparameters of each model that was tuned. There are four files corresponding to each model type that was tuned and the observations correspond to each of the three models for that type on each of the three difference recipe types. 

- `results`: contains the results of assessing the final model.
