%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prompt = 'Are the data already loaded? (answer by 0 or 1)';
already_loaded = input(prompt);

% --- To get the data files obtained from "simul_replic=100"

% if already_loaded == 0
%     clear all;
%     
%     run clean_folder.m;
%     
%     simul_replic_dummy = 1;
%     dynare usmodel.mod;
% end
% 
% simulated_series = get_simul_replications(M_, options_);
% 
% series_to_compare = [3; 6; 45; 78; 99];
% 
% for i=1:length(series_to_compare)
%     series_index = series_to_compare(i);
%     sheet_name = ['series_', num2str(series_index)];
% 
%     writematrix(simulated_series(:, :, series_index), 'z_simul_extract.xlsx', 'Sheet', sheet_name)
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- If usmodel.mod calls 100 times the "stoch_simul" command

if already_loaded == 0
    clear all;
    
    run clean_folder.m;
    
    dynare usmodel.mod;
end

series_to_compare = [3; 6; 45; 78; 99];

for i=1:length(series_to_compare)
    clear file_name sheet_name dc dy dw dinve pinfobs labobs robs;

    series_index = series_to_compare(i);

    file_name = ['z_simul_', num2str(series_index), '.mat'];
    sheet_name = ['series_', num2str(series_index)];

    load(file_name);

    output = array2table(dc);
    output.dinve = dinve;
    output.dw = dw;
    output.dy = dy;
    output.labobs = labobs;
    output.pinfobs = pinfobs;
    output.robs = robs;

    writetable(output, 'z_simul_extract.xlsx', 'Sheet', sheet_name)
end



