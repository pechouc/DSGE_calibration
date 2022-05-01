%%% ------------------------------------------------------------------- %%%
%%% --- TESTING DIFFERENT CALIBRATIONS -------------------------------- %%%
%%% ------------------------------------------------------------------- %%%

% In this file, we successively increase and decrease by 1% one of the
% fixed parameters of the model before estimating the model on I (or, by
% default, 5) simulated datasets; as a form of control, we also re-estimate
% the model once without any calibration error

if exist("estimation_method_short") == 0
    estimation_method_short = 'noMH';
end

if exist("percentage_change_magnitude") == 0
    percentage_change_magnitude = 0.01;
end

output_file_name = ['testing_calibrations_params_', estimation_method_short, '.xlsx'];

% --- First, without changing any parameter for reference

sheet_name = 'control'

ctou_calib = .025;
clandaw_calib = 1.5; 
cg_calib = 0.18; 
curvp_calib = 10; 
curvw_calib = 10;

dynare testing_calibrations.mod % Running the estimations

output.average = mean(table2array(output(:, 2:(I+1))), 2); % Taking the mean of the parameter modes estimated on each simulated dataset
writetable(output, output_file_name, 'FileType', 'spreadsheet', 'Sheet', sheet_name); % Saving the table

% --- Second, introducing "calibration errors"

percentage_changes = {-percentage_change_magnitude, percentage_change_magnitude}; % We try both 1% increases and 1% decreases
params_to_recalibrate = {'ctou', 'clandaw', 'cg', 'curvp', 'curvw'} % Fixed parameters that we "recalibrate"

for change_num = 1:length(percentage_changes) 
    percentage_change = percentage_changes{change_num}

    for param_num = 1:length(params_to_recalibrate)
        param = params_to_recalibrate{param_num}
    
        % Calibration error in the capital depreciation rate
        if strcmp(param, 'ctou') == 1
            ctou_calib = .025 * (1 + percentage_change)
            clandaw_calib = 1.5; 
            cg_calib = 0.18; 
            curvp_calib = 10; 
            curvw_calib = 10;
   
        % Calibration error in the steady state wage mark-up
        elseif strcmp(param, 'clandaw') == 1
            ctou_calib = .025;
            clandaw_calib = 1.5 * (1 + percentage_change)
            cg_calib = 0.18; 
            curvp_calib = 10; 
            curvw_calib = 10;
        
        % Calibration error in the exogenous spending-to-GDP ratio
        elseif strcmp(param, 'cg') == 1
            ctou_calib = .025; 
            clandaw_calib = 1.5; 
            cg_calib = 0.18 * (1 + percentage_change)
            curvp_calib = 10; 
            curvw_calib = 10;

        % Calibration error in the curvature of the Kimball aggregator for prices
        elseif strcmp(param, 'curvp') == 1
            ctou_calib = .025; 
            clandaw_calib = 1.5; 
            cg_calib = 0.18;
            curvp_calib = 10 * (1 + percentage_change) 
            curvw_calib = 10;

        % Calibration error in the curvature of the Kimball aggregator for wages
        elseif strcmp(param, 'curvw') == 1
            ctou_calib = .025; 
            clandaw_calib = 1.5; 
            cg_calib = 0.18;
            curvp_calib = 10; 
            curvw_calib = 10 * (1 + percentage_change)
    
        end
    
        dynare testing_calibrations.mod % Running the estimations

        % Defining the name of the Excel sheet where to save the results
        if percentage_change > 0
            sheet_name = [param, '_+'];
        else
            sheet_name = [param, '_-'];
        end

        output.average = mean(table2array(output(:, 2:(I+1))), 2); % Taking the mean of the parameter modes estimated on each simulated dataset
        writetable(output, output_file_name, 'FileType', 'spreadsheet', 'Sheet', sheet_name); % Saving the table
        
        % std_deviations.mean = mean(table2array(std_deviations(:, 2:(I+1))), 2);
        % writetable(std_deviations, 'testing_calibrations_std_deviations.xlsx', 'FileType', 'spreadsheet', 'Sheet', sheet_name); % Saving the table

    end

end