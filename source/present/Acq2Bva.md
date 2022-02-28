## Acq2Bva

### Folder structure

The complete folder structure for the EMG recordings looks like this:

```
+-- acq_data
|   +-- [AcqKnowledge recordings]
+-- bva_data
|   +-- [BrainVision Analyzer data files]
+-- bva_export
|   +-- [BrainVision Analyzer exports]
+-- bva_hist
|   +-- [BrainVision Analyzer history files]
+-- bva_macros
|   +-- [BrainVision Analyzer scripts]
+-- settings.toml
```

- The `acq_data` folder contains all of the AcqKnowledge recordings.

- The `bva_data` folder contains all of the BrainVision Analyzer data files, produced with `acq2bva` from the AcqKnowledge recordings

- The `bva_export` folder contains any exported data from BrainVision Analyzer, after processing

- The `bva_hist` folder contains the history files for each of the BrainVision Analyzer data files.

  - A history file is a snapshot of the processing pipeline on each data file

- The `bva_macros` folder contains all BrainVision Analyzer macro scripts that you might include
  - Macro is a user-written script in the language SAX BASIC, that can be applied as a node in the data file pipeline

### `settings.toml` file

The acq2bva settings are written in the `settings.toml`. The full file looks like this:

```toml
acq_folder="acq_data"
output_folder="bva_data"
channel_indexes=[0, 1]
channel_names=["EMG_Corr", "EMG_Zygo"]
write_markers=true
marker_channel_index=9
expected_nr_markers=4818

[marker_map]
"1-8" = "Trial Start"
"11-18" = "Trial End"
"21-28" = "Feedback Start"
"31-38" = "Feedback End"
"41" = "Correct Response"
"42" = "Incorrect Response"
"43" = "No Response"
"45" = "Target Onset"
"51-58" = "Block Start"
"61-68" = "Block End"
"71-78" = "Practice Trial Start"
"81-88" = "Practice Trial End"
"91-98" = "Practice Feedback Start"
"101-108" = "Practice Feedback End"
"50" = "Practice Block Start"
"60" = "Practice Block End"
```

- The `acq_folder` and `output_folder` are set to `acq_data` and `bva_data`, respectively. Recordings from the `acq_data` folder are read and transformed into data files saved in `bva_data`.

- We only select the muscle readings, which are the first two channels (0 and 1). We rename them "EMG_Corr" and "EMG_Zygo", respectively.

- We write markers from channel 9 and tell `acq2bva` to expect 4818 individual markers.

- We specify the marker map, with the marker value on the left side and marker description on the right side

### Running `acq2bva`

Open up a command line interface (e.g. powershell). Use the command `cd [directory]` to navigate to the folder containing `acq_data`, `bva_data` and `settings.toml`. Assuming you have installed `acq2bva` (see the General Documentation for more detail), simply type in `acq2bva` in the command line and press enter.

> **Note:** Please read carefully any errors or warnings you might receive.
