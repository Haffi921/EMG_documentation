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
