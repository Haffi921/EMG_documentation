# AcqKnowledge

BioPac's AcqKnowledge is used to conduct the actual recording of EMG data (or EEG, ECG, etc).

AcqKnowledge can also be used for analysis and has a lot to explore. You can, for example, perform a wide array of transformations on the recordings, as running some analysis functions. The interface is highly customizable, and can be set up to display any number of descriptive statistics.

However, in this documentation we will only discuss the necessary steps to 1) setup, 2) record and 3) save EMG data. We leave learning any more advanced functions and use cases of AcqKnowledge to you the reader (visit Biopac's own [Knowledge Base](https://www.biopac.com/knowledge-base/) for more information)

## *Settings*

### **MP160**
### **Event Markers**
Event markers are signals sent from the experiment program to AcqKnowledge via a 25-pin parallel port cable. The cable is connected to the computer on which the experiment is being run, and to a **Isolated Digital Interface** like BioPac's STP100D (see image 1).

![STP100D](./images/STP100D.jpg){width=10cm}

The experiment program sends 7-bit number to the STP100D device. AcqKnowledge is able to record these bits as digital input of either 0V or 5V. We need to set up a calculation channel that takes this data and processes it back into a 7-bit number.

In order to do that we need to first select the digital channels for acquisition (see image 2). Next we need to create a new calculation channel under the "Calculation" tab.

[Set up]

The formula for this calculation channel is as follows:
```
(D8 + D9 * 2 + D10 * 4 + D11 * 8 + D12 * 16 + D13 * 32 + D14 * 64) / 5
```

## *Recording*

## *Saving*

### **Template file (.gtl)**

### **Recording (.acq)**