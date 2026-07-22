# Matlab code for Ensemble Parameter Estimation
## Main Parameter Estimation code - Ensemble_Parameter_Estimation_LPLSP.m
### Supporting functions
1. rank_reduction.m - Reduces and reshapes a full rank matrix into a matrix of rank $r$
2. temperature_model.m - Computes transient temperature with R, K matrices using LPLSP method
3. residuals_rank.m - Computes error between predicted and measured temperatures
4. compute_temperatures.m - Passes R, K and new input power P to temperature_model.m to compute temperature
5. load_RK_param_rank_reduced.m - Read parameter names: R11, R21, ..., K11, K12 ...
6. load_validation_power.m - Imports new input power dissipation for prediction
## Prediction Script for new inputs - Temperature_Prediction_LPLSP.m

## Data files
### Training Data - Training.xlsx
### Test Data - Test.xlsx
### R,K parameters - parameters_rank_reduced.xlsx
### Temperature predictions for Test Data - output_rank_reduced.xlsx
