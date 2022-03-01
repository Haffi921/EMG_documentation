# Data Analysis

## Data overview

The data that we get from BrainVision Analyzer is in this long format:

| File        | Count | Channel      | Segment | Bin | Value    |
| ----------- | ----- | ------------ | ------- | --- | -------- |
| Feedback001 | 1     | EMG_Corr_RMS | 1       | 1   | 3.1e-04  |
| Feedback001 | 1     | EMG_Corr_RMS | 1       | 2   | 6.2e-04  |
| ...         | ...   | ...          | ...     | ... | ...      |
| Feedback001 | 1     | EMG_Zygo_RMS | 1       | 14  | 1.5e-04  |
| Feedback001 | 1     | EMG_Corr_RMS | 2       | 1   | -1.3e-04 |
| ...         | ...   | ...          | ...     | ... | ...      |
| Feedback001 | 1     | EMG_Corr_RMS | 800     | 14  | 3.7e-04  |
| Feedback002 | 2     | EMG_Corr_RMS | 1       | 1   | 6.6e-04  |
| ...         | ...   | ...          | ...     | ... | ...      |

You can see that the column `File` and `Count` both indicate subject number, although `File` is safer as it definitively marks the exact filename that the data comes from. `Count` on the other hand only indicates the sequential order this data was exported from BrainVision Analyzer. So, when you can use `File` or at the very least verify the variable `Count`.

Then you can see the variables `Channel`, `Segment` and `Bin`. Within each `File`, `Segment` comes sequentially from 1 to 800. Within each `Segment`, `Channel` alternates between Corrugator and Zygomaticus with the 14 bins of each channel running sequentially before the next channel.

Lastly, we have `Value` which is the mV reading from the BioPac equipment.

### Data wrangling

Our objective in wrangling the data is to bring it to like this wide format:

| Participant | Block | Trial | Corr_1   | ... | Corr_10 | Zygo_1   | ... | Zygo_10  |
| ----------- | ----- | ----- | -------- | --- | ------- | -------- | --- | -------- |
| 1           | 1     | 1     | 9.9e-04  | ... | 1.4e-03 | -7.3e-04 | ... | 5.0e-04  |
| 1           | 1     | 2     | -3.3e-04 | ... | 9.5e-03 | 1.9e-02  | ... | -4.0e-05 |
| ...         | ...   | ...   | ...      | ... | ...     | ...      | ... | ...      |
| 1           | 1     | 97    | -4.6e-04 | ... | 5.4e-03 | 3.3e-03  | ... | -1.2e-04 |
| 1           | 2     | 1     | 2.5e-04  | ... | 3.5e-03 | -7.3e-04 | ... | 9.0e-04  |
| ...         | ...   | ...   | ...      | ... | ...     | ...      | ... | ...      |
| 1           | 8     | 97    | -4.4e-04 | ... | 2.2e-03 | 2.7e-03  | ... | 3.3e-03  |
| 2           | 1     | 1     | 5.3e-04  | ... | 5.5e-03 | 7.5e-04  | ... | -9.2e-04 |
| ...         | ...   | ...   | ...      | ... | ...     | ...      | ... | ...      |

As you can see, we transform the channel and time bin variables to separate columns, starting at `Corr_1` and ending at `Zygo_10` (meaning Corrugator time bin 1 and Zygomaticus time bin 10). Notice how we went from 14 time bins to 10? Well, remember that we made the segments start at -400 ms before response and end at 1000 ms after response. We are only interested in the 1000 ms _after_ response. Therefore we drop time bins 1-4 and rename time bins 5-14 to 1-10.

Additionally, notice that we have extrapolated the Block and Trial information. We do this from the variable `Segment` which was the sequentially numbered indicator of each trial that the participant took. In this experiment, we have 24 practice trials followed by 8 blocks of 97 trials. This can easily be calculated from the variable `Segment`.

> I leave it up to you wrangle the data to state, as there are many different ways and many different decisions you can take.

When you finally get this format, the final step is to merge it with the rest of the behavioral data in order to get variables such as `Correct Response`, etc.

## Outlier detection

There are two _types_ of data with which we look for outliers:

1. The data point itself
2. the difference between two data points

Of course we want to detect outliers data points, but we also want to identify outlier spikes (changes from one data point to another).

There are also two _domains_ within which we look for outliers:

1. Within each trial (Time bin 1..10)
2. Across trials, for each time bin index (Time bin 1 for block 1..8 and trial 1..97)

The first domain is straight-forward. The second one requires a bit of explanation. We want to look at all time bins nr. 1 (e.g. 0-99 ms) across all trials. Then we look at all time bins nr. 2, etc. We do this for all time bin indexes.

## Data Analysis

At this stage, there is much freedom to analyze the data how you want.

The standard, and for this study, is to do Repeated Measures Anova with:

- Dependent variable: Corrugator/Zygomaticus activation
- Within-subject variables: Feedback, Congruency, Congruency^N-1^ and Time bins

## Complete R script

Data wrangling:

```R
library("tidyverse")

emg <- read_csv("data/raw/emg_data/Feedback_EMG.csv") %>%

  # Get subject number simply; in real life you want to verify this
  rename(participant = Count) %>%
  select(-c("File")) %>%

  # Rename channels
  mutate(
    Channel = recode(Channel, "EMG_Corr_RMS" = "Corr", "EMG_Zygo_RMS" = "Zygo")
  ) %>%

  # Remove bins 1-4
  filter(Bin > 4) %>%
  mutate(Bin = Bin - 4) %>%

  # Change from long to wide data
  pivot_wider(
    names_from = c(Channel, Bin),
    values_from = Value
  ) %>%

  # Get block numbers
  mutate(block = ceiling((Segment - 24) / 97)) %>%
  relocate(block, .before = Segment) %>%

  # Get trial numbers
  group_by(participant, block) %>%
  mutate(trial = row_number(participant)) %>%
  relocate(trial, .after = block) %>%

  # Reorganize
  mutate(
    trial_block = ifelse(block == 0, "practice", "trial"),
    block = ifelse(block == 0, 1, block)
  ) %>%
  ungroup()

# Read in behavioral data
bhv <- read_csv("data/feedback_bhv_data.csv")

emg <- bhv %>%
  select(
    # Session data
    experiment_name:gender,

    # Trial data
    trial_block:congruency, feedback,

    # Response data
    made, correct
  ) %>%

  # Merge Behavioral data with EMG
  inner_join(emg)
```
