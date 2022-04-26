prompt = 'Include the output files (answer by 1 or 0)?'
bool = input(prompt)

delete z_simul_*
delete *.log
delete g*.mat
delete H.dat
delete testing_calibrations.m
delete testing_calibrations_dynamic.m
delete testing_calibrations_set_auxiliary_variables.m
delete testing_calibrations_static.m

if bool == 1
    delete *.xlsx
    delete *.tex

    delete graphs/vs_control/*.png
    delete graphs/vs_control_std/*.png
    delete graphs/vs_initial_values/*.png
    delete graphs/vs_initial_values_std/*.png

    delete testing_calibrations/Output/*.mat
    delete usmodel/Output/*.mat
end