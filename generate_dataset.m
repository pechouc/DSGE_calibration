%%% ------------------------------------------------------------------- %%%
%%% --- INITIAL ESTIMATION ON US DATA AND DATASET GENERATION ---------- %%%
%%% ------------------------------------------------------------------- %%%

% In this file, which relies on the Dynare script "usmodel.mod", we 
% estimate the original model of Smets & Wouters (2007) on historical US
% data and use it to generate 100 datasets with the "stoch_simul" command;
% we also save the posterior modes of the parameters, which are the values
% behind the data-generating process

% --- Estimating the model based on historical US data and running 100 stochastic simulations

dynare usmodel

% --- In the following, we get and save the posterior modes and standard deviations of the parameters

if exist("estimation_method_short") == 0
    estimation_method_short = 'noMH'
end

initial_output_file_name = ['initial_param_estimation_', estimation_method_short, '.xlsx'];

if strcmp(estimation_method_short, 'noMH')
    % For the estimated parameters - Modes and standard deviations
    temp = oo_.posterior_mode.parameters; % Getting the structure with posterior modes and names
    temp(:, 2) = oo_.posterior_std_at_mode.parameters; % Adding standard deviations
    temp = rows2vars(struct2table(temp)); % Transforming into a table object and transposing
    temp.Properties.VariableNames = {'param_name' 'mode' 'std_at_mode'}; % Renaming columns
    
    % For the standard deviations of the shocks - Modes and standard deviations
    temp_bis = oo_.posterior_mode.shocks_std; % Getting the structure with posterior modes and names
    temp_bis(:, 2) = oo_.posterior_std_at_mode.shocks_std; % Adding standard deviations
    temp_bis = rows2vars(struct2table(temp_bis)); % Transforming into a table object and transposing
    temp_bis.Properties.VariableNames = {'param_name' 'mode' 'std_at_mode'}; % Renaming columns

else
    % For the estimated parameters - Means, modes and standard deviations
    temp = oo_.posterior_mean.parameters; % Getting the structure with posterior means and names
    temp(:, 2) = oo_.posterior_mode.parameters; % Adding posterior modes
    temp(:, 3) = oo_.posterior_std.parameters; % Adding standard deviations
    temp = rows2vars(struct2table(temp)); % Transforming into a table object and transposing
    temp.Properties.VariableNames = {'param_name' 'mean' 'mode' 'std'}; % Renaming columns

    % For the standard deviations of the shocks - Means, modes and standard deviations
    temp_bis = oo_.posterior_mean.shocks_std; % Getting the structure with posterior means and names
    temp_bis(:, 2) = oo_.posterior_mode.shocks_std; % Adding posterior modes
    temp_bis(:, 3) = oo_.posterior_std.shocks_std; % Adding standard deviations
    temp_bis = rows2vars(struct2table(temp_bis)); % Transforming into a table object and transposing
    temp_bis.Properties.VariableNames = {'param_name' 'mean' 'mode' 'std'}; % Renaming columns

end

% For the estimated parameters - Names
param_table = cell2table(M_.param_names); % Fetching short parameter names in a table
param_table(:, 2) = cell2table(M_.param_names_long); % Adding long parameter names to the same table
param_table(:, 3) = cell2table(M_.param_names_tex); % Adding LaTeX parameter names to the same table
param_table.Properties.VariableNames = {'param_name' 'param_name_long' 'param_name_tex'}; % Renaming columns

% For the standard deviations of the shocks - Names
param_table_bis = cell2table(M_.exo_names); % Fetching short parameter names in a table
param_table_bis(:, 2) = cell2table(M_.exo_names_long); % Adding long parameter names to the same table
param_table_bis(:, 3) = cell2table(M_.exo_names_tex); % Adding LaTeX parameter names to the same table
param_table_bis.Properties.VariableNames = {'param_name' 'param_name_long' 'param_name_tex'}; % Renaming columns

% We vertically concatenate the two tables
temp = [temp; temp_bis];
param_table = [param_table; param_table_bis];

% We join the table with posterior modes and standard deviations and that with parameter names
param_table = join(temp, param_table);

writetable(param_table, initial_output_file_name); % Saving the table