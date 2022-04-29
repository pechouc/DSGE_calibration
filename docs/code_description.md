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

`generate_dataset.m` can be run in a standalone fashion and will prompt a message for the user to choose the estimation methodology. `usmodel.mod` can also be used as such with the `dynare` command: by default, the estimation will be run with maximum likelihood but one can operate the Metropolis-Hastings by previously running `estimation_method_short = 'MH'` in the Matlab command line.

# `calibration_errors_estimation.m`

In `main.m`, the script `calibration_errors_estimation.m` is then run. This script iterates over the 5 fixed parameters in Smets & Wouters (2007). For each of them, an X% increase and and X% decrease of the value initially set are successively considered.
