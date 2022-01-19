# EMG documentation

## 1\. Theoretical - Main Concepts

### *What is being recorded?*

#### **Data points**
At the most fundamental level, an EMG recording is just a collection of *data points*. Each data point represents a **voltage reading** at a certain point of time. Let's say you record 2 data points per second (sample rate of 2). The first data point would be the voltage reading at time 0 sec, the second would be the reading at time 0.5 sec, etc.

#### **Sample rate**
The number of data points you record per second is called it's *sample rate*. In most cases you will be recording 2000 data points per second. In that example you, the sample rate would be 2000. For facial recorings, this is sufficient.

#### **Channels**
You can record multiple sets of data points concurrently using BioPac's equipment. This is useful, for example, when recording multiple electrode placements or event markers (see below). Each set of data points is represented by *Channels*. Each of these channels has their own sample rate (although, generally you want to keep it the same) and is separated from other channels in the final dataset.

#### **Event markers**
While conducting an experiment with EMG data, in most cases you will want to mark certain events in the experiment into the EMG data. This is done with Event Markers. In BioPac's AcqKnowledge program, it is necessary to record this using **7 recording channels** (each representing an on/off switch) and **1 calculation channel** which calculates the data from the recording channels into a 7-bit binary number. The binary number system falls out of the scope of this documentation. However, if you would like to learn more there is a vast number of material found by searching "Binary number system basics" online.

### *Fourier Transform* (Optional theoretical)
An important concept for a deeper understanding of the transformations that can be performed on the data. The basic idea is that for every possible waveform (e.g the resulting wave created by our data points), you can decompose it into its primal sine waves of a certain frequencies, of a certain amplitude.

>For example, a complex wave could consist of:
> - A 5 Hz sine wave with amplitude 1 mm
> - A 6 Hz sine wave of amplitude 0.5 mm
> - ... etc.

An easy way of thinking about this is that it is similar to how numbers can be decomposed into its prime factors of a certain power (e.g. 12 = 2^2^ + 3). For further reading, I again suggest searching for "Fourier Transform basics" online.

### *Main transformations*

#### **Filters**
By doing a fourier transfrom (mentioned above) on the data that we record, programs like *AcqKnowledge* and *BrainVision Analyzer* can identify the compository frequency waves that our data consists of. However, some of these waves are irrelevant and/or are considered noise. First and foremost, in Europe the electrical current from the socket uses a 50 Hz rythmn (in the USA 60 Hz). Additionally, for facial EMG recordings we are only interested in the data from the 20-500 Hz range.

We use filters to reduce noise. There are three types of filters: 1) Low-cut filter, 2) High-cut filter, and 3) Notch filter. Low-cut and High-cut filters remove all frequencies lower or higher, respectively, than their reference frequency. A Notch filter will remove a specific frequency from the waveform.

> In our example of 20-500 Hz with noise on the 50 Hz frequency, we want a Low-cut filter of 20 Hz, High-cut filter of 500 Hz, and a Notch filter at 50 Hz.

**Be aware:** Confusingly, *Low-cut* filters are sometimes called *High-pass* filters, and vice versa, *High-cut* filters are sometimes called *Low-pass* filters. This is because a *Low-cut* filter of 20 Hz ***cuts frequencies lower*** than 20 Hz and ***passes through frequencies higher*** than 20 Hz. The opposite applies to *High-cut* filters. In this document we use the "cut" terminology, instead of "pass", since the reference frequency for *Low-cut* filters is always lower than for *High-cut* filter... unless you want to filter out all of your data!

#### **Binning**
"Binning" simply means splitting the data points into groups. This is done for better analysis. We can not practically do data analysis on 2000 data points per second. We therefore group them up into ranges of equal size bins. For example bin sizes of 100 ms (0-99 ms, 100-199 ms, etc.). With a sampling rate of 2000 Hz, we get 200 data points per bin. If the data that we are interested in is of total length 1000 ms, we get values for 10 bins which is a lot easier to manage than 2000 data points. What you do with the bins to extract value is up to you. However, a common practice is to use a RMS transformation which we will discuss next.

#### **Root Mean Square (RMS)**
Root Mean Square is a transformation of data similar to the calculation of a *standard deviation* in statistics. Our recordings of EMG data alternates between positive and negative numbers. However, we do not care about whether the values are positive or negative, instead we care about is how much the voltage deviates from zero. If we take the average voltage of the *raw* data, the average will simply approximate zero. We want to make all data points positive before we take the average. The RMS transformation allows us do this.

The process of RMS is simple. We start by taking a bin of data points (e.g. 100 ms; see *Binning* above). We then square all the data points in that range. Next we take the average of all these data points. Finally, we take the root of this mean value. An observant reader will see that we just walked backwards through the term "(3) Root (2) Mean (1) Square". The outcome of this is a single value representing the RMS value of the data bin we started with.

> **Note**: Similar to standard deviation (Root Sum Square), this method is not a simple average of the data we use. Instead this method increase the weight of higher absolute values, and decreases the weight of lower absolute values - the more the value deviates form zero, the more it effects our RMS value.

#### **Baseline correction**
Baseline correction is the method of selecting a certain data point (or bin) to center the data around. The selected data point (A) will become zero and all other data points will move to keep its relative position to data point A. This is common practice in EMG research as the voltage readings at any point in time can vary.

#### **Z-Score**
A Z-score should be familiar to most people who know statistics. However, there are certain specifics to how we use Z-scores on EMG data. Firstly, we want to normalize the data in order to be able to better compare readings from one experiment trial to another. Secondly, we want to identify outliers using z-scores.

The former is easier to explain to those familar with statistics. Often the last step of EMG data transformation is to normalize all data using its Z-score within each condition/factor and for each participant separately.

The latter is more complicated and there are many possible methods. We will explain a method used by [Ref] in chapter 4: ***R data analysis***.

> **Note**: Explaining the concept of Z-scores falls out of the scope of this documentation. If you would like to learn more, I again suggest searching for it online.

## 2\. Acq2Bva

### *An overview of the recording-to-data pipeline*
BioPac's AcqKnowledge program is the standard to record data from BioPac's EMG recording equipment. This program records all data points from each channel for the specified sampling rate you have selected. It also records and calculates the event markers you have selected to record. All of this data is saved in a proprietary file format with the extension `.acq`. However, this program is not suitable (at the time of writing in 2022) for further analysis.

For analysis, a good program to use is BrainVision Analyzer (BVA). This program reads raw binary data with the extension `.dat`. It also requires a header file with the same name and extension `.vhdr`. This is a simple text file written in a `toml` format. This file contains configuration of how the raw data file is organized, so that BVA can correctly read the data. Optionally, it also reads a marker file with the same name and extension `.vmrk`. This file is similar and contains information about event markers. These files are not easy write and often require redundant information when using AcqKnowledge files.

However, there is an issue. AcqKnowledge does not allow for exporting the `.acq` data to this BVA format with the corresponding `.vhdr` and `.vmrk` files. To export this we use an open-source program called `acq2bva`. For an explanation of this program and a step-by-step user guide, see *Using Acq2Bva* below.

The important thing about the recording-to-data pipeline is to save all `.acq` files in one folder with a descriptive name (e.g. "[Name of Experiment]-[Subject number]"). Then you use `acq2bva` to convert the `.acq` files to BVA format using a `setting.toml` file (where you specify the relevant information to your study). The BVA files are saved to a different data folder to reduce the risk of contamination or corruption of the `.acq` files.

### *Using Acq2Bva*
#### **Prerequisites**
In order to use `acq2bva` you need:

* A working knowledge of a windows terminal, such as `cmd` or `powershell`
  * For a short introduction, see refer to Appendix A: "Using the command line"
* `python` version 3.6 or greater
  * The newest version of `python` as of January 2022, version 3.10 is recommended
* `pip` version 21.2.4 or greater
  * The package manager for `python`
  * Comes with the installation of `python`

#### **Installation**
* Using the command line, type in `pip install https://github.com/Haffi921/acq2bva`

#### **Using**


## 3\. BrainVision Analyzer

## 4\. R data analysis
### *Outliers*
There are two *types* of data with which we look for outliers:
1) The data point itself
2) the difference between two data points

Of course we want to detect outliers data points, but we also want to identify outlier spikes (changes from one data point to another).

There are also two *domains* within which we look for outliers:
1) Within each trial
2) Across trials, for each time bin index

The first domain is straight-forward. The second one requires a bit of explanation. We want to look at all time bins nr. 1 (e.g. 0-99 ms) across all trials. Then we look at all time bins nr. 2, etc. We do this for all time bin indexes.