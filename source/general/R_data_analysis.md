# R data analysis
## *Outliers*
There are two *types* of data with which we look for outliers:
1) The data point itself
2) the difference between two data points

Of course we want to detect outliers data points, but we also want to identify outlier spikes (changes from one data point to another).

There are also two *domains* within which we look for outliers:
1) Within each trial
2) Across trials, for each time bin index

The first domain is straight-forward. The second one requires a bit of explanation. We want to look at all time bins nr. 1 (e.g. 0-99 ms) across all trials. Then we look at all time bins nr. 2, etc. We do this for all time bin indexes.