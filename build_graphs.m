%%% ------------------------------------------------------------------- %%%
%%% --- BUILDING THE GRAPHS FROM EXCEL FILES -------------------------- %%%
%%% ------------------------------------------------------------------- %%%

if exist("estimation_method_short") == 0
    prompt = "Which estimation method was selected? (answer by 'MLE' or 'MH')";
    estimation_method_short = input(prompt);
end

initial_file_name = ['initial_param_estimation_', estimation_method_short, '.xlsx'];
output_file_name = ['testing_calibrations_params_', estimation_method_short, '.xlsx'];

if strcmp(estimation_method_short, 'MLE') == 1
    relevant_column_name = 'mode';
    std_column_name = 'std_at_mode';
else
    relevant_column_name = 'mean';
    std_column_name = 'std';
end

if exist("percentage_change_magnitude") == 0
    prompt = "Choose the magnitude of the percentage change (like 0.01 for 1% change):";
    percentage_change_magnitude = input(prompt);
end

legend_increase = [num2str(percentage_change_magnitude * 100), '\% increase'];
legend_decrease = [num2str(percentage_change_magnitude * 100), '\% decrease'];

if exist("center_graphs") == 0
    prompt = "Do you want to center the x-axis of the graphs with pre-defined bounds? (answer by 0 or 1)";
    center_graphs = input(prompt);
end

% --- First, plotting the comparison with the data-generating parameters

% We read the Excel file that stores the posterior values obtained from the initial estimation
% These are the parameters behind the data-generating process
initial_estimates = readtable(initial_file_name);

mask = cellfun(@(x) contains(x, '{'), initial_estimates.param_name_tex);
temp = initial_estimates.param_name_tex;
temp(mask) = cellfun(@(x) ['$', x(2:length(x) - 1), '$'], initial_estimates.param_name_tex(mask), 'UniformOutput', false);
temp(~mask) = cellfun(@(x) ['$', x, '$'], initial_estimates.param_name_tex(~mask), 'UniformOutput', false);
temp = cellfun(@(x) char(x), temp, 'UniformOutput', false);
initial_estimates.param_name_tex = temp;

% We iterate over the 5 parameters that we "recalibrate"
params_to_recalibrate = {'ctou', 'clandaw', 'cg', 'curvp', 'curvw'};
params_to_recalibrate_tex = {'$\delta$', '$\lambda_w$', '$\frac{\bar g}{\bar y}$', '$\varepsilon_p$', '$\varepsilon_w$'};

for param_num = 1:length(params_to_recalibrate)
    recalibrated_param = params_to_recalibrate{param_num};
    recalibrated_param_tex = params_to_recalibrate_tex{param_num};

    % We first get the values obtained when increasing the parameter by X%
    suffix = '+';
    sheet_name = [recalibrated_param, '_', suffix];
    new_estimates = readtable(output_file_name, 'Sheet', sheet_name);
    
    % We add to the table with the new values the initial estimates
    merged_table = join(new_estimates, initial_estimates);

    % We select only the relevant subset of columns and rename them
    merged_table = merged_table(:, {'param_name', 'param_name_tex', 'average', relevant_column_name, std_column_name});
    merged_table.Properties.VariableNames = {'param_name' 'param_name_tex' 'average_plus' relevant_column_name 'std'};

    % We now get the values obtained when deecreasing the parameter by X%
    suffix = '-';   
    sheet_name = [recalibrated_param, '_', suffix];
    new_estimates = readtable(output_file_name, 'Sheet', sheet_name);

    % We add them to the merged table obtained before
    merged_table = join(merged_table, new_estimates);

    % Selecting columns of interest and renaming them
    merged_table = merged_table(:, {'param_name', 'param_name_tex', 'average_plus', relevant_column_name, 'average', 'std'});
    merged_table.Properties.VariableNames = {'param_name' 'param_name_tex' 'average_plus' relevant_column_name 'average_minus' 'std'};

    % We compute percentage changes between the estimates obtained before and after the calibration error
    if strcmp(estimation_method_short, 'MLE') == 1
        merged_table.diff_plus = merged_table.average_plus - merged_table.mode;
        merged_table.percentage_change_plus = (merged_table.diff_plus ./ merged_table.mode) * 100;

        merged_table.diff_minus = merged_table.average_minus - merged_table.mode;
        merged_table.percentage_change_minus = (merged_table.diff_minus ./ merged_table.mode) * 100;
    else
        merged_table.diff_plus = merged_table.average_plus - merged_table.mean;
        merged_table.percentage_change_plus = (merged_table.diff_plus ./ merged_table.mean) * 100;

        merged_table.diff_minus = merged_table.average_minus - merged_table.mean;
        merged_table.percentage_change_minus = (merged_table.diff_minus ./ merged_table.mean) * 100;
    end

    % We plot the bar chart with two series (X% increase, X% decrease) for each parameter estimate
    barh(categorical(merged_table.param_name_tex), [merged_table.percentage_change_plus merged_table.percentage_change_minus]);
    
    ax = gca;
    ax.TickLabelInterpreter = 'latex';
    title(['Effect of a ', num2str(percentage_change_magnitude * 100), '\% change in the fixed value of ', recalibrated_param_tex, ' on the estimated parameters'], 'interpreter','latex');
    legend({legend_increase, legend_decrease}, 'Interpreter','latex')
    xlabel(['Change in the ', relevant_column_name, ' of the estimated parameter (\%)'], 'Interpreter','latex');
    if center_graphs == 1
        set(gca, 'XLim', [-70, 70], 'XTick', -70:10:70);
    end

    % Saving the graph
    saveas(gcf, ['graphs/vs_initial_values/', recalibrated_param, '.png'])

    % We do the same with standard deviations as denominator
    merged_table.std_deviation_change_plus = (merged_table.diff_plus ./ merged_table.std);
    merged_table.std_deviation_change_minus = (merged_table.diff_minus ./ merged_table.std);

    % We plot the bar chart with two series (X% increase, X% decrease) for each parameter estimate
    barh(categorical(merged_table.param_name_tex), [merged_table.std_deviation_change_plus merged_table.std_deviation_change_minus]);

    ax = gca;
    ax.TickLabelInterpreter = 'latex';
    title(['Effect of a ', num2str(percentage_change_magnitude * 100), '\% change in the fixed value of ', recalibrated_param_tex, ' on the estimated parameters'], 'interpreter','latex');
    legend({legend_increase, legend_decrease}, 'Interpreter','latex')
    xlabel(['Change in the ', relevant_column_name, ' of the estimated parameter (expressed in standard deviations)'], 'Interpreter','latex');
    if center_graphs == 1
        set(gca, 'XLim', [-2.5, 2.5], 'XTick', -2.5:0.5:2.5);
    end

    % Saving the graph
    saveas(gcf, ['graphs/vs_initial_values_std/', recalibrated_param, '.png'])

end

% --- Second, plotting the comparison with control parameter estimates

% We follow the same logic but this time, the estimates obtained with the
% calibration error are not compared with the initial ones but with the
% "control" estimates obtained upon the simulated datasets

control_estimates = readtable(output_file_name, 'Sheet', 'control');
control_estimates = control_estimates(:, {'param_name', 'average'});
control_estimates.Properties.VariableNames = {'param_name' 'average_control'};

initial_estimates = join(initial_estimates, control_estimates);
initial_estimates = initial_estimates(:, {'param_name', 'param_name_tex', 'average_control', std_column_name});
initial_estimates.Properties.VariableNames = {'param_name' 'param_name_tex' 'average_control' 'std'};

params_to_recalibrate = {'ctou', 'clandaw', 'cg', 'curvp', 'curvw'};
params_to_recalibrate_tex = {'$\delta$', '$\lambda_w$', '$\frac{\bar g}{\bar y}$', '$\varepsilon_p$', '$\varepsilon_w$'};

for param_num = 1:length(params_to_recalibrate)
    recalibrated_param = params_to_recalibrate{param_num};
    recalibrated_param_tex = params_to_recalibrate_tex{param_num};

    suffix = '+';
    sheet_name = [recalibrated_param, '_', suffix];
    new_estimates = readtable(output_file_name, 'Sheet', sheet_name);
    
    merged_table = join(new_estimates, initial_estimates);

    merged_table = merged_table(:, {'param_name', 'param_name_tex', 'average', 'average_control', 'std'});
    merged_table.Properties.VariableNames = {'param_name' 'param_name_tex' 'average_plus' 'average_control' 'std'};

    suffix = '-';   
    sheet_name = [recalibrated_param, '_', suffix];
    new_estimates = readtable(output_file_name, 'Sheet', sheet_name);

    merged_table = join(merged_table, new_estimates);

    merged_table = merged_table(:, {'param_name', 'param_name_tex', 'average_plus', 'average_control', 'average', 'std'});
    merged_table.Properties.VariableNames = {'param_name' 'param_name_tex' 'average_plus' 'average_control' 'average_minus' 'std'};

    merged_table.diff_plus = merged_table.average_plus - merged_table.average_control;
    merged_table.percentage_change_plus = (merged_table.diff_plus ./ merged_table.average_control) * 100;

    merged_table.diff_minus = merged_table.average_minus - merged_table.average_control;
    merged_table.percentage_change_minus = (merged_table.diff_minus ./ merged_table.average_control) * 100;

    barh(categorical(merged_table.param_name_tex), [merged_table.percentage_change_plus merged_table.percentage_change_minus]);

    ax = gca;
    ax.TickLabelInterpreter = 'latex';
    title(['Effect of a ', num2str(percentage_change_magnitude * 100), '\% change in the fixed value of ', recalibrated_param_tex, ' on the estimated parameters'], 'Interpreter','latex');
    legend({legend_increase, legend_decrease}, 'Interpreter','latex')
    xlabel(['Change in the ', relevant_column_name, ' of the estimated parameter (\%)'], 'Interpreter','latex');
    if center_graphs == 1
        set(gca, 'XLim', [-1.5, 1.5], 'XTick', -1.5:0.5:1.5);
    end

    saveas(gcf, ['graphs/vs_control/', recalibrated_param, '.png'])

    % We do the same with standard deviations as denominator
    merged_table.std_deviation_change_plus = (merged_table.diff_plus ./ merged_table.std);
    merged_table.std_deviation_change_minus = (merged_table.diff_minus ./ merged_table.std);

    % We plot the bar chart with two series (X% increase, X% decrease) for each parameter estimate
    barh(categorical(merged_table.param_name_tex), [merged_table.std_deviation_change_plus merged_table.std_deviation_change_minus]);

    ax = gca;
    ax.TickLabelInterpreter = 'latex';
    title(['Effect of a ', num2str(percentage_change_magnitude * 100), '\% change in the fixed value of ', recalibrated_param_tex, ' on the estimated parameters'], 'Interpreter','latex');
    legend({legend_increase, legend_decrease}, 'Interpreter','latex')
    xlabel(['Change in the ', relevant_column_name, ' of the estimated parameter (expressed in standard deviations)'], 'Interpreter','latex');
    if center_graphs == 1
        set(gca, 'XLim', [-0.05, 0.05], 'XTick', -0.05:0.01:0.05);
    end
    
    % Saving the graph
    saveas(gcf, ['graphs/vs_control_std/', recalibrated_param, '.png'])

end


% --- Third, plotting the differences between the control and the data-generating parameters
initial_estimates = readtable(initial_file_name);

mask = cellfun(@(x) contains(x, '{'), initial_estimates.param_name_tex);
temp = initial_estimates.param_name_tex;
temp(mask) = cellfun(@(x) ['$', x(2:length(x) - 1), '$'], initial_estimates.param_name_tex(mask), 'UniformOutput', false);
temp(~mask) = cellfun(@(x) ['$', x, '$'], initial_estimates.param_name_tex(~mask), 'UniformOutput', false);
temp = cellfun(@(x) char(x), temp, 'UniformOutput', false);
initial_estimates.param_name_tex = temp;

control_estimates = readtable(output_file_name, 'Sheet', 'control');
control_estimates = control_estimates(:, {'param_name', 'average'});
control_estimates.Properties.VariableNames = {'param_name' 'average_control'};

initial_estimates = join(initial_estimates, control_estimates);
initial_estimates = initial_estimates(:, {'param_name', 'param_name_tex', 'average_control', relevant_column_name, std_column_name});
initial_estimates.Properties.VariableNames = {'param_name' 'param_name_tex' 'average_control' 'true_value' 'std'};

initial_estimates.diff = initial_estimates.average_control - initial_estimates.true_value;
initial_estimates.percentage_change = (initial_estimates.diff ./ initial_estimates.true_value) * 100;

barh(categorical(initial_estimates.param_name_tex), [initial_estimates.percentage_change]);

ax = gca;
ax.TickLabelInterpreter = 'latex';
title(['Estimation bias using the control model '], 'Interpreter','latex');
xlabel('in \% of the true value ', 'Interpreter', 'latex');
if center_graphs == 1
    set(gca, 'XLim', [-65, 65], 'XTick', -65:5:65);
end

saveas(gcf, ['graphs/control_vs_initial/', 'control_vs_initial.png'])

% We do the same with standard deviations as denominator
initial_estimates.std_deviation_change = (initial_estimates.diff ./ initial_estimates.std);

barh(categorical(initial_estimates.param_name_tex), [initial_estimates.std_deviation_change]);

ax = gca;
ax.TickLabelInterpreter = 'latex';
title(['Estimation bias using the control model '], 'Interpreter','latex');
xlabel('in standard deviations of the estimate', 'Interpreter', 'latex');
if center_graphs == 1
    set(gca, 'XLim', [-2.5, 2.5], 'XTick', -2.5:0.5:2.5);
end

% Saving the graph
saveas(gcf, ['graphs/control_vs_initial/', 'control_vs_initial_std.png'])

