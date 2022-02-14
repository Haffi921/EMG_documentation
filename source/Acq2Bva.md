# Acq2Bva

## *An overview of the recording-to-data pipeline*
BioPac's AcqKnowledge program is the standard to record data from BioPac's EMG recording equipment. This program records all data points from each channel for the specified sampling rate you have selected. It also records and calculates the event markers you have selected to record. All of this data is saved in a proprietary file format with the extension `.acq`. However, this program is not suitable (at the time of writing in 2022) for further analysis.

For analysis, a good program to use is BrainVision Analyzer (BVA). This program reads raw binary data with the extension `.dat`. It also requires a header file with the same name and extension `.vhdr`. This is a simple text file written in a `toml` format. This file contains configuration of how the raw data file is organized, so that BVA can correctly read the data. Optionally, it also reads a marker file with the same name and extension `.vmrk`. This file is similar and contains information about event markers. These files are not easy write and often require redundant information when using AcqKnowledge files.

However, there is an issue. AcqKnowledge does not allow for exporting the `.acq` data to this BVA format with the corresponding `.vhdr` and `.vmrk` files. To export this we use an open-source program called `acq2bva`. For an explanation of this program and a step-by-step user guide, see *Using Acq2Bva* below.

The important thing about the recording-to-data pipeline is to save all `.acq` files in one folder with a descriptive name (e.g. "[Name of Experiment]-[Subject number]"). Then you use `acq2bva` to convert the `.acq` files to BVA format using a `setting.toml` file (where you specify the relevant information to your study). The BVA files are saved to a different data folder to reduce the risk of contamination or corruption of the `.acq` files.

## *Using Acq2Bva*
### **Prerequisites**
In order to use `acq2bva` you need:

* A working knowledge of a windows terminal, such as `cmd` or `powershell`
  * For a short introduction, see refer to Appendix A: "Using the command line"
* `python` version 3.6 or greater
  * The newest version of `python` as of January 2022, version 3.10 is recommended
* `pip` version 21.2.4 or greater
  * The package manager for `python`
  * Comes with the installation of `python`

### **Installation**
* Using the command line, type in `pip install https://github.com/Haffi921/acq2bva`

### **Using**
#### Setting up
* The AcqKnowledge recordings (`.acq` files) should be together in one input folder
  * We will call this folder: `acq_data`
* The `acq2bva` program will produce corresponding `.dat`, `.vhdr`, and `.vmrk` (if applicable) files in an output folder that you will need to create
  * We will call this folder: `bva_data`

Create these two folders and place the AcqKnowledge recordings in the `acq_data` folder

> **Note:** The recordings in `acq_data` will not be modified or touched in any way. The output in `bva_data`, however, will be overwritten everytime you run the program

#### Configuration
The `acq2bva` program requires you to specify the information about particular settings that are relevant to your recordings. For example, the input/output folders (i.e. `acq_data` and `bva_data`; see above) are required in order to run `acq2bva`.

There are two ways to specify settings: 1) By arguments in the command line interface, such as: `acq2bva acq_data bva_data`, or 2) By using a `settings.toml` file in the same folder that contains the input and output folders. Any arguments proveded via the command line take precedence over settings in the `.toml` file. However, the recommendation is to use a `settings.toml` file in order to better control and configure the settings you need for your situation. We will therefore discard the idea of using the command line and focus only on the `.toml` file.

Create a file called `settings.toml` in the same folder as the input/output folders are. Open it up in a text editor. Let's start by setting the input/output folders by typing:

```toml
acq_folder="acq_data"
output_folder="bva_data"
```

Next we realize we have many extraneous channels in the original recording, and might just want one or two channels in our final BVA data. We can cherrypick the channels and rename them for our convenience by typing:

```toml
channel_indexes=[0, 1]
channel_names=["EMG_1", "EMG_2"]
```

Note how we specify channels 0 and 1. Channel numbers are zero-indexed, meaning the first channel is number 0. In this example, we have selected channels 0 and 1 and renamed them "EMG_1" and "EMG_2", respectively.

Similarly, we can specify the scales and units for each of the selected channels, just like we renamed them. A scalar number is multiplied with each datapoint of the channel and defaults to 1. A unit is for example `Volt`, `mV`, etc. The unit defaults to what the AcqKnowledge recording specifies. Example of how you set this is:

```toml
channel_scales=[1, 1.5]
channel_units=["V", "V"]
```

Lastly, we want to include the markers we recorded. This assumes you recorded markers as a specialized channel, like we have exemplified in this documentation. We need to do three things: 1) Tell `acq2bva` that we want marker files, 2) Specify which channel is the marker channel (**Note:** This channel does not to be included in the `channel_indexes` above), and 3) Specify a "marker map" which tells `acq2bva` what to name each marker. Additionally, it is possible to specify the number of markers you expect from the file. If the number of markers differs from this, `acq2bva` will notify you of this mismatch.

Let's do all of this by typing:
```toml
write_markers=true
marker_channel_index=8
expected_nr_markers=4818
```

Here we have told `acq2bva` to "`write_markers`" and that the "`marker_channel_index`" is 8. Additionally, `acq2bva` will notify us if the number of markes differs from 4818. However, we have not created the "marker map". Let's do that next. We need to start by creating a new section in the `.toml` file, like this:

```toml
[marker_map]
```

Next we specify markers with either single numbers (e.g. "48") or a range of numbers (e.g. "1-9"), followed by a `=` and a text giving a description of the respective marker (e.g. "Trial Start"). Note that both the marker numbers and descriptions are in quotation marks. Here I have filled in example markers:

```toml
[marker_map]
"1-8" = "Trial start"
"11-18" = "Trial End"
"41" = "Correct Response"
"42" = "Incorrect Response"
"43" = "No Response"
"45" = "Target Onset"
"51-58" = "Block Start"
"61-68" = "Block End"
```

#### Running
Having the settings file configured in the same directory as the input and output folders, we can finally run the `acq2bva` program. Open a command line (e.g. `cmd`, `powershell`) and navigate to the directory.

> **Note:** There are many good resources online for how to navigate the computer file system using a command line interface.

When your command line is in the directory, and you have the `settings.toml` file correctly in place, you can simply run: `acq2bva`. You will see some output about what files were detected and what files are being written. Make sure to note if you see any warnings or errors.

If everything worked out correctly, then you now have data that can explore in BrainVision Analyzer!