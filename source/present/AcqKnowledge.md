# Setup

## AcqKnowledge

Throughout this experiment, our sample rate is 2000 Hz. Confusingly, AcqKnowledge reports this sample rate as 2000 kHz. But rest assured, data points are recorded every 0.5 ms, or 2000 Hz. You can take a look at this yourselves by zooming into the data in AcqKnowledge!

### Smart Amp Channels

In this study we are recording _two_ facial muscles, namely Corrugator Supercilii and Zygomaticus Major. The Smart Amplifier attached to the Corrugator is connected to channel 1, and the smart amplifier attached to the Zygomaticus is connect to channel 2. Both channels are selected for acquisition and plotting.

> **Note:** The electrode placement for many facial muscles can be found in the article "Facial EMG as a Tool for Inferring Affective States" by _Anton van Boxtel_ (2010).

<!-- Picture? -->

### Digital Channels

In this study we are recording _seven_ binary channels that make up marker identifiers. They are digital channels D8-D14. Channel D8 is for the least significant bit, and channel D14 is for the most significant bit (see [Calculation Channels]). All channels are selected for acquisition, but **not** for plotting.

> **Note:** These channels can be plotted but this is unnecessary and clutters up the screen while recording.

### Calculation Channels

In this study we have _one_ calculation channel. This channel has the responsibility to process the digital channels into a 7-bit number. This is done with the following formula:

```C
( D8 + (D9 * 2) + (D10 * 4) + (D11 * 8) + (D12 * 16) + (D13 * 32) + (D14 * 64) ) / 5
```

Note how D14 (the most significant bit) is multiplied by 64. Additionally, each digital channel is multiplied by a sequential multiple of 2. The only channel not multiplied is D8 (i.e. the least significant bit; effectively it is multiplied by 1).

This channel is selected for acquisition and plotting.

### Final words on channels

If everything is done correctly, you should see three channels: 1) Corrugator, 2) Zygomaticus, and 3) Event marker calculation channel.

For X and Y scales, we select a 10 sec/div (X) and 0.25 mV/div with 0 in the middle (Y).

### Template file

All of these settings are saved in the `FeedbackXXX.gtl` template file. Simply open up this file, save it as a new recording (`.acq` format) and you should be ready to start recording.

### Recording naming convention

In this study, we name the recording files like this: `FeedbackXXX.acq`. Here **XXX** stands for the subject number of the participant. So, participant number 1 will have the recording `Feedback001.acq`, and so on...
