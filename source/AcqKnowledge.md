# AcqKnowledge

BioPac's AcqKnowledge is used to conduct the actual recording of EMG data (or EEG, ECG, etc).

![AcqKnowledge window](./images/AcqKnowledge/AcqKnowledge.png){width=10cm}

AcqKnowledge can also be used for analysis and has a lot to explore. You can, for example, perform a wide array of transformations on the recordings, as running some analysis functions. The interface is highly customizable, and can be set up to display any number of descriptive statistics.

However, in this documentation we will only discuss the necessary steps to 1) setup, 2) record and 3) save EMG data. We leave learning any more advanced functions and use cases of AcqKnowledge to you the reader (visit Biopac's own [Knowledge Base](https://www.biopac.com/knowledge-base/) for more information)

## *Settings*
### **MP160**
In order to open AcqKnowledge, a USB lincese dongle needs to be connected to the computer. In order to effectively setup AcqKnowledge for recordings, a data acquisition unit (such as BioPac's MP160) you want to set up needs to be connected to the computer and turned on. The MP160 unit is connected to a computer with a ethernet-to-USB connection, via a ethernet-USB adapter. The MP160 must also be connected to electricity and turned on.

When the MP160 unit (or any other data acquisition unit) is connected, the main AcqKnowledge window will present you with a new menu item in the top bar: `MP160` (see Figure \ref{MP160_menu}). From there you can select `Set Up Data Acquisition` in the drop down menu. The window that will pop up has all the main settings to configure before an experiment. In the default section named `Channels` (seen in the left sidebar) you have three important tabs.

![MP160 drop down menu \label{MP160_menu}](./images/AcqKnowledge/MP160_Setup.png){width=10cm}

- The first one, named `Smart Amps` (see Figure \ref{MP160_setup}), you can see the physical amplifiers connected to the MP160 unit and what channels they are assigned to. By clicking the arrow next to each channel, you can explore what specific settings relevant to the amps.

- Next you have `Digital` (see Figure \ref{digital}). These channels are reserved for data coming from an **Isolated Digital Interface** (see **Event Markers** below). You may notice that half of the channels are for input, and half are for output. Specifically, it should be noted that channel `D15` is reserved for the smart amplifiers, and cannot be used.

- Lastly, you have `Caclulation` (see Figure \ref{calculation}). These channels can perform any number of calculations or transformations on input from other channels in real time. For example, we use a calculation channel to calculate **Event Markers** (see below).

![MP160 Setup \label{MP160_setup}](./images/AcqKnowledge/MP160_Setup2.png){width=10cm}

![Digital Channels \label{digital}](./images/AcqKnowledge/DigitalChannels.png){width=10cm}

![Calculation Channels \label{calculation}](./images/AcqKnowledge/CalculationChannels.png){width=10cm}

In the sidebar on the left (where we have `Channels` selected), there are more sections to explore. However, most of these are less important for our purposes. The only exception is perhaps `Length/Rate`. There you can select the overall sample rate and how recordings are saved (manually or directly to disk; see Figure \ref{sample_rate}).

![Length/Rate \label{sample_rate}](./images/AcqKnowledge/SampleRate.png){width=10cm}

### **New file**
Opening AcqKnowledge, you will have to choice to create a new recording or open up an existing one. A new recording can be created with a template file (see below), or without any prior configurations. By default, a recording is not saved to a disk until you manually press `ctrl-s`, or do `File > Save As`. Therefore, it is wise to habitually save the recording manually, and never forget to save immediately after recording has stopped.

### **Template files (.gtl)**
You are able to save a configuration of AcqKnowledge to a `.gtl` file. The configurations include settings on the data acquisition unit, any custom channels (such as for the event markers), and which channels are plotted during recording, the X and Y scales of the plot, etc. It is recommended to configure and standardize `.gtl` file before any experiment. This allows the experimenters to spend the minimum amount of time configuring before pressing `Record`.

> **Note:** When opening a template file, you need to start by manually saving the recording as a new file. The template file only opens up AcqKnowledge with the right configurations but the recording is still an "Untitled" recording.

### **Event Markers**
Event markers are signals sent from the experiment program to AcqKnowledge via a 25-pin parallel port cable. The cable is connected to the computer on which the experiment is being run, and to a **Isolated Digital Interface** like BioPac's STP100D (see Figure \ref{STP100D}).

![STP100D \label{STP100D}](./images/STP100D.jpg){width=10cm}

The experiment program sends 7-bit number to the STP100D device. AcqKnowledge is able to record these bits as digital input of either 0V or 5V. We need to set up a calculation channel that takes this data and processes it back into a 7-bit number.

In order to do that we need to first select the digital channels for acquisition. We select `Acquire` on channels  D8 to D14 (see Figure \ref{digital2}). These are input channels from our STP100D device. Next we need to create a new calculation channel under the "Calculation" tab. Select `Acquire` to create a channel. Then select `Setup` in the top right corner (see Figure \ref{calculation2}). From there you select `Expression`.

![Digital Channels selected \label{digital2}](./images/AcqKnowledge/DigitalChannels2.png){width=10cm}

![Calculation Channels selected \label{calculation2}](./images/AcqKnowledge/CalculationChannels2.png){width=10cm}

We need to create an expression that calculates input from the D8-14 digital channels and converts that into an event marker. Each digital channel gives values of either 0V or 5V. The formula for this calculation channel is therefore as follows (see also figure \ref{calculation3}):

```C
( D8 + (D9 * 2) + (D10 * 4) + (D11 * 8) + (D12 * 16) + (D13 * 32) + (D14 * 64) ) / 5
```

We start by multiplying each channel by the increasing power of 2 (i.e. 2^0^, 2^1^, ..., 2^6^). Next we add all these values together. Finally, because each channel is of value 5V when turned on, we need to divide this sum by 5.

![Calculation Channel Expression \label{calculation3}](./images/AcqKnowledge/CalculationChannels3.png){width=10cm}

## *Recording*
Recordings are plotted in real time on your screen. You can choose which channels you want displayed while recording. Hiding a channel does not remove it from the file. You can also change the scale at which the the plot is shown. The X axis is for time, and the Y axis is the voltage amplitude. Starting and stopping can be done simply with the corresponding button at the top-left corner (see Figures \ref{start} and \ref{stop})

![Starting Recording \label{start}](./images/AcqKnowledge/AcqKnowledgeStart.png){width=10cm}

![Stopping Recording \label{stop}](./images/AcqKnowledge/AcqKnowledgeStop.png){width=10cm}

## *Saving*

### **Recording (.acq)**