## Result files

### Fits

- `null_fit.rda`: contains fitted model results to the folded dataset for null model with `basic_recipe`

- `log_fit1.rda`: contains fitted model results to the folded dataset for logistic model with `basic_recipe`

- `log_fit2.rda`: contains fitted model results to the folded dataset for logistic model with `main_recipe`


### Analysis

- `metrics.csv`: contains the performance metrics for the null and logistic models on the basic recipe

- `log_metrics2.csv`: contains the performance metrics for the logistic model on the main recipe

### Recipes

- `basic_recipe.rda`: the basic recipe for the non-tree models
- `main_recipe.rda`: the main recipe for the non-tree models


### Split

- `estate_split.rda`: contains the split data as `estate_test` and `estate_train` and `estate_folds` data files
