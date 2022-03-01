## BrainVision Analyzer

In BrainVision Analyzer, we construct a processing pipeline from raw data to final dataset with history nodes. We start by constructing this pipeline on one recording. These history nodes can then be saved in a history template, in order to apply them to all of the recordings together.

### History Template Overview

![History Nodes \label{nodes}](./images/BVA/HistoryFile.png){width=10cm}

Let's walk through each step:

1. First there is a filter (selected via `Transformation` > `Artifact Rejection/Reduction` > `Data filtering` > `IIR filters`). We select a "Low Cutoff" filter at 20 Hz and a "High Cutoff" filter at 500Hz. We also select a "Notch" filter at 50Hz (see \ref{filters})

![Filters \label{filters}](./images/BVA/IIRFilters.png){width=10cm}

Afterwards, you will get a new history node that will most-likely have remarkably less noise in during low activity.

2. Next we segment the data up into equal length data segments, centered around participant's response. To segment click on `Transformation` > `Segment Analysis Functions` > `Segmentation`. Under `What kind of Segmentation would you like to be performed?` select `Create new Segments based on a marker position`. Under `How should the data be stored?` leave it at `Do not store data, calculate on demand` (see \ref{segment1}).

![Segmentation Settings \label{segment1}](./images/BVA/segment1.png){width=10cm}

The markers for response are: 41 = Correct Response, 42 = Incorrect Response, and 43 = No Response. On \ref{segment2}, you see how we select these markers out of the list.

![Segmentation Markers \label{segment2}](./images/BVA/segment2.png){width=10cm}

We want the first 1000 ms after the participant responds, and 400 ms before the response for a baseline. On \ref{segment3}, you can see how we specify this.

![Segmentation Time \label{segment3}](./images/BVA/segment3.png){width=10cm}

Afterwards, you will get a new history node with the dataset split into segments numbering the amount of trials in the experiment.

> **Note:** We rename this "ResponseLocked" by double-clicking the node and typing the new name.

3. Next node is a macro named RMS, or Root Mean Square. This macro performs two actions: 1) Binning the data into X length time bins, and 2) Performing a RMS calculation on each bin.

To run the macro select `Macros` > `Open`, find the script `RMS.vabs` in the folder `bva_macros`. The script should open in a new window. Now you select the green arrow in the toolbar. Alternatively, you can select `Macros` > `Run`, find the script and it will run immediately.

![RMS macro \label{rms1}](./images/BVA/rms1.png){width=10cm}

Running the macro we get a new window. In this window, you can 1) Select the channels to perform the action on, 2) Specify the `Startpoint` (relative to each segment), 3) Specify the `Interval Length` of each bin (in terms of datapoints; so 200 = 100 ms when sample rate is 2000 Hz), and 4) Whether or not to include the unprocessed channels in the resulting history node.

We select both channels, starting at datapoint 1 and with interval of 200 datapoints. We also exclude the parent data, so that the resulting history node only includes the RMS transformed channels (see \ref{rms2}).

![RMS macro options \label{rms2}](./images/BVA/rms2.png){width=5cm}

The resulting history node should have the same segments with each 100 ms having the same value.

4. Next we do a baseline correction. We select to use the value at 200-100 ms before the response as the baseline.

Select `Transformation` > `Segment Analysis Functions` > `Baseline Correction`. Since the whole bin from -200 to -100ms is the same value, we select an arbitrary baseline within this time bin, i.e. from -151 ms to -150 ms (see \ref{baseline})

![Baseline Correction \label{baseline}](./images/BVA/baseline.png){width=5cm}

5. Lastly, we export this data to a `csv` file. We do this using a macro called `ExportBinsCSV.vabs`. We run this the same way as before (see 3. above). Again, we get a window for settings. We can select the channels, startpoint, and interval. Additionally, we can select the `Filename` and choose whether to write the file only when applying a history template (most of the time you want to select this). The resulting file will be saved under `bva_export`.

We choose both channels, startpoint at datapoint 1 and interval at 200 datapoints. What we name the file is unimportant, but we keep the default name `ExportBinsCSV`.

We also check `Only write data when applying node`. **This is important!** What happens is that when you run the macro for the first time (while you are constructing the pipeline), no data will be exported. Then you save the pipeline as a history template and delete the pipeline off the data file. Then you apply the history template on all of the data files together. Only then will the data be exported. If you don't select this option, the recording you construct the pipeline on will appear two times in the data.

![Export CSV \label{export}](./images/BVA/export.png){width=5cm}
