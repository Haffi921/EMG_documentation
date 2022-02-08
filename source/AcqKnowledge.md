# AcqKnowledge

BioPac's AcqKnowledge is used to conduct the actual recording of EMG data (or EEG, ECG, etc).

AcqKnowledge can also be used for analysis and has a lot to explore. You can, for example, perform a wide array of transformations on the recordings, as running some analysis functions. The interface is highly customizable, and can be set up to display any number of descriptive statistics.

However, in this documentation we will only discuss the necessary steps to 1) setup, 2) record and 3) save EMG data. We leave learning any more advanced functions and use cases of AcqKnowledge to you the reader (visit Biopac's own [Knowledge Base](https://www.biopac.com/knowledge-base/) for more information)

## *Settings*
### **MP160**
In order to open AcqKnowledge, a USB lincese dongle needs to be connected to the computer. In order to effectively setup AcqKnowledge for recordings, a data acquisition unit (such as BioPac's MP160) you want to set up needs to be connected to the computer and turned on. The MP160 unit is connected to a computer with a ethernet-to-USB connection, via a ethernet-USB adapter. The MP160 must also be connected to electricity and turned on.

### **New file**
Opening AcqKnowledge, you will have to choice to create a new recording or open up an existing one. A new recording can be created with a template file (see below), or without any prior configurations. By default, a recording is not saved to a disk until you manually press `ctrl-s`, or do `File > Save As`. Therefore, it is wise to habitually save the recording manually, and never forget to save immediately after recording has stopped.

### **Template files (.gtl)**
You are able to save a configuration of AcqKnowledge to a `.gtl` file. The configurations include settings on the data acquisition unit, any custom channels (such as for the event markers), and which channels are plotted during recording, the X and Y scales of the plot, etc. It is recommended to configure and standardize `.gtl` file before any experiment. This allows the experimenters to spend the minimum amount of time configuring before pressing `Record`.

> **Note:** When opening a template file, you need to start by manually saving the recording as a new file. The template file only opens up AcqKnowledge with the right configurations but the recording is still an "Untitled" recording.

### **Event Markers**
Event markers are signals sent from the experiment program to AcqKnowledge via a 25-pin parallel port cable. The cable is connected to the computer on which the experiment is being run, and to a **Isolated Digital Interface** like BioPac's STP100D (see Figure \ref{STP100D}).

![STP100D \label{STP100D}](./images/STP100D.jpg){width=10cm}

The experiment program sends 7-bit number to the STP100D device. AcqKnowledge is able to record these bits as digital input of either 0V or 5V. We need to set up a calculation channel that takes this data and processes it back into a 7-bit number.

In order to do that we need to first select the digital channels for acquisition (see image 2). Next we need to create a new calculation channel under the "Calculation" tab.

[Set up]

The formula for this calculation channel is as follows (see also figure):
```C
( D8 + (D9 * 2) + (D10 * 4) + (D11 * 8) + (D12 * 16) + (D13 * 32) + (D14 * 64) ) / 5
```

## *Recording*
Recordings are plotted in real time on your screen. You can choose which channels you want displayed while recording. Hiding a channel does not remove it from the file. You can also change the scale at which the the plot is shown. The X axis is for time, and the Y axis is the voltage amplitude.

## *Saving*

### **Recording (.acq)**