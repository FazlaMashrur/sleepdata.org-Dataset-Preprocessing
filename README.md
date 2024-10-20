
# Sleep Dataset Preprocessing in MATLAB for MESA, CFS, SHHS, MROS

## Description
This MATLAB project processes EDF files from the MESA, CFS, SHHS, and MROS datasets. The main functionality includes extracting signal data based on specific events (e.g., sleep stages, apnea events), applying a sliding window to segment the data, and saving each segment to a CSV file with corresponding labels for further analysis.

## Datasets
The datasets being processed include:
- **MESA**: Multi-Ethnic Study of Atherosclerosis
- **CFS**: Cleveland Family Study
- **SHHS**: Sleep Heart Health Study
- **MROS**: MrOS Sleep Study

These datasets include polysomnography (PSG) and actigraphy data, collected in large-scale sleep studies aimed at investigating sleep-disordered breathing and other sleep-related health conditions.

## Preprocessing Steps
- **EDF File Loading**: The EDF files are loaded and processed using MATLAB functions.
- **Sliding Window**: A sliding window is applied to segment the signal data into smaller windows. The size of the window and overlap (if any) can be configured.
- **Event-Based Signal Extraction**: Signals are extracted around specific events (e.g., apnea, sleep stage transitions) based on annotations in the EDF files.
- **Label Assignment**: Each windowed segment is assigned a corresponding label, which could include sleep stages, apnea events, or other relevant annotations.
- **Saving to CSV**: The processed data and labels are saved in CSV format for further analysis or machine learning tasks.

## Installation
List the necessary toolboxes or MATLAB dependencies (e.g., Signal Processing Toolbox, Bioinformatics Toolbox).
Instructions for setting up the environment:
```bash
Add the following directories to your MATLAB path:
addpath(genpath('path_to_your_functions'))
```

## License
Add the license details if applicable (e.g., MIT License).
