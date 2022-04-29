# `main.m`

The logic described in the methodological section of our report can be run as a block thanks to the **`main.m`** script. It will prompt 4 successive messages so that you can provide the parameters necessary to run the computations:

- First, when defining `I` in response to the first prompt, you choose the number of simulated datasets on which the estimation of each miscalibrated model should be run. This argument must be an integer between 1 and 100. Please note that this argument is the main determinant of the duration of the computations; if `I = 50` for instance, the number of estimations is given by:

```
1 + 50 * (#_miscalibration + 1) = 1 + 50 * (#_fixed_parameters * 2 + 1) = 1 + 50 * (5 * 2 + 1) = 1 + 50 * 11 = 551
```

- Second, when defining `estimation_method_short` in response to the second prompt, you choose the estimation method to be used. If `'MLE'` is selected, all estimations will be operated via maximum likelihood and the posterior modes of the estimated parameters will be studied. If `'MH'` is indicated, all estimations will rely on the Metropolis-Hastings algorithm and the posterior means of the estimated parameters will be studied. This argument can only take these two values, **with these precise quotation marks**. Eventually, note that estimations with the Metropolis-Hastings algorithm require substantially more time;

- Third, when defining `percentage_change_magnitude` in response to the third prompt, you define the magnitude of the calibration errors to consider. For instance, if `0.02` is selected, the value of each of the 5 fixed parameters will be increased by 2% and reduced by 2% before analysing the effect of these errors on the estimation of the other parameters of the model.

- Fourth, when defining `center_graphs` in response to the fourth prompt, you choose whether to center the x-axis of the graphs eventually produced around 0, with bounds and ticks fixed in the `build_graphs.m` script. These bounds have been defined in the script to fit the case of 1% changes in the values of the fixed paramaters, with estimation by maximum likelihood. If you do not know the scale to expect, we recommend that you select `0`.

# `generate_dataset.m`

The main Matlab script first runs **`generate_dataset.m`**. 

This script relies on the Dynare instructions in **`usmodel.mod`** to (i) estimate the Smets & Wouters (2007) model on historical US data (following the replication code and data file released by the authors) and (ii) generate 100 simulated datasets that contain the 7 observed variables. These are saved as `.mat` files in the process. Additionally, `generate_dataset.m` saves the posterior modes and / or means of the estimated parameters (as well as their standard deviations) in an Excel file. 

`generate_dataset.m` can be run in a standalone fashion and will by default operate the estimation with maximum likelihood. `usmodel.mod` can also be used as such with the `dynare` command: here too, by default, the estimation will be run with maximum likelihood. In both cases, one can operate the Metropolis-Hastings by entering `estimation_method_short = 'MH'` in the Matlab command line before running `run generate_dataset.m` or `dynare usmodel.mod`.

# `calibration_errors_estimation.m`

In `main.m`, the script `calibration_errors_estimation.m` is then run. 

This script iterates over the 5 fixed parameters in Smets & Wouters (2007). For each of them, an X% increase and and X% decrease of the value initially set are successively considered. At each of the 10 resulting iterations, the Dynare script **`testing_calibrations.mod`** is called. This Dynare script again defines the model of Smets & Wouters but using the modified values for the fixed parameters. Iterating over the simulated datasets, it estimates the model over each of them and saves the resulting modes or means (depending on the estimation method selected) in a table. After **`testing_calibrations.mod`** has run, the table with the results from the successive estimations is saved in an Excel file, under the relevant tab.

Note that, before estimating the different models with calibration errors, a "control" model is estimated over the different simulated datasets with the same calibrations as the ones initially retained by Smets & Wouters.

`calibration_errors_estimation.m` can be run in a standalone fashion if simulated datasets have been previously generated. By default, the estimation will be operated via maximum likelihood, over 5 simulated datasets for each set of calibrations and considering 1% deviations from initial values. Each of these options can be modified by respectively defining variables `estimation_method_short`, `I` and / or `percentage_change_magnitude` before running `run calibration_errors_estimation.m`. If a calibration is defined before as in the Matlab script, `testing_calibrations.mod` can run on its own too, although use cases should be limited.

# `build_graphs.m`

Eventually, the `build_graphs.m` script is called. 

Based on the Excel files generated in the previous steps of the code, this script creates the graphs that we present in our report. These graphs are of five different types. First, for each of the fixed parameters that are modified to account for "calibration errors", they compare: 

- the average modes or means of the estimated parameters with the values behind the data-generating process, the difference being expressed in percentage f the values initially estimated;
- the average modes or means of the estimated parameters with the values behind the data-generating process, the difference being expressed in the standard deviations estimated initially on historical data;
- the average modes of means of the estimated parameters with the average control modes or means, the difference being expressed in percentage of the control values;
- the average modes of means of the estimated parameters with the average control modes or means, the difference being expressed in the standard deviations estimated initially on historical data.

Two other graphs eventually compare the average control modes or means with the values behind the data-generating process, the difference being expressed respectively as a percentage of the values initially estimated and in the standard deviations estimated from historical US data. All these graphs are saved as `.png` files in the `graphs` folder.

Note that if `center_graphs = 1` was selected, the x-axis is centered around 0 for all graphs and uniform bounds are set to facilitate the visual comparison of the different graphs. These bounds, directly defined in the Matlab script, were chosen to fit the case of 1% changes in the values of the fixed paramaters, with estimation by maximum likelihood. If you do not know the scale to expect, we recommend that you select `center_graphs = 0`.

If relevant Excel files are stored in the root folder, the `build_graphs.m` script can run in a standalone fashion. It will prompt three successive messages for the user to indicate the estimation method and the magnitude of the percentage changes that were selected to generate the Excel outputs, as well as whether to center the x-axis of the graphs or not.

# `clean_folder.m`

Running the **`clean_folder.m`** script allows to clean the working folder. Outputs (graphs and Excel files essentially) are only eliminated if this is explicitly chosen by the user in response to a prompted message.
