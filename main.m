%%% ------------------------------------------------------------------- %%%
%%% --- ONE MATLAB SCRIPT TO RULE THEM ALL ---------------------------- %%%
%%% ------------------------------------------------------------------- %%%

prompt = 'On how many simulated datasets do you wish to run the estimation?';
I = input(prompt);

prompt = "Which method do you wish to use? (answer by 'MLE' or 'MH' with these quotation marks)";
estimation_method_short = input(prompt);

prompt = "Choose the magnitude of the percentage change (like 0.01 for 1% changes):";
percentage_change_magnitude = input(prompt);

% Estimating the original model on US data and generating 100 simulated datasets
run generate_dataset.m

% Estimating the model on simulated datasets for different calibration errors
run calibration_errors_estimation.m

% Cleaning the folder
% delete z_simul_*

% Building the graphs from the Excel file with the results
run build_graphs.m