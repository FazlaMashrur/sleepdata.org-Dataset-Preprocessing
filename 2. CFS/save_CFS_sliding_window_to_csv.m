function save_CFS_sliding_window_to_csv(file_range, signal_you_have_chosen, window_time, window_step)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Function: save_CFS_sliding_window_to_csv
    % Author: Fazla Rabbi Mashrur
    % Email: rabbi.mashrur@gmail.com
    % Institution: University of Rochester
    % Last Update: October 2024
    % Version: 1.1
    %
    % Description:
    % This function processes EDF files and extracts signal data based on 
    % specific events. It applies a sliding window to the data and saves 
    % each window with a corresponding label to a CSV file. 
    %
    % Inputs:
    %   - file_range: Vector of file indices (e.g., [77, 78, 79])
    %   - signal_you_have_chosen: The signal to process (e.g., 'EEG1')
    %   - window_time: The size of the window in seconds (e.g., 10)
    %   - window_step: The step size of the sliding window in seconds (e.g., 2)
    % Example: 
    %   save_CFS_sliding_window_to_csv(77:79, 'EEG1', 10, 2);
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   


    % Loop through all files in the given file range
    for i = file_range  
        % Dynamically adjust the file names based on the current file index
        fprintf('Processing file index %d...\n', i);
        if i <= 9
            try
                [signals, header] = readEDF(sprintf('cfs-visit5-80000%d.edf', i)); % For i=1 to 9
                annot_filename = sprintf('cfs-visit5-80000%d-nsrr.xml', i);
                fprintf('Successfully loaded EDF and annotation files for index %d.\n', i);
            catch
                fprintf('Error loading files for index %d. Skipping this file.\n', i);
                continue;
            end
        elseif i <= 99 && i>=10
            try
                [signals, header] = readEDF(sprintf('cfs-visit5-8000%d.edf', i)); % For i=10 to 99
                annot_filename = sprintf('cfs-visit5-8000%d-nsrr.xml', i);
                fprintf('Successfully loaded EDF and annotation files for index %d.\n', i);
            catch
                fprintf('Error loading files for index %d. Skipping this file.\n', i);
                continue;
            end
        elseif i <= 999 && i>=100
            try
                [signals, header] = readEDF(sprintf('cfs-visit5-800%d_ecg.edf', i));  % For i=100 to 999
                annot_filename = sprintf('cfs-visit5-800%d-nsrr.xml', i);
                fprintf('Successfully loaded EDF and annotation files for index %d.\n', i);
            catch
                fprintf('Error loading files for index %d. Skipping this file.\n', i);
                continue;
            end
        else
            try
                [signals, header] = readEDF(sprintf('cfs-visit5-80%d_ecg.edf', i));   % For i=1000 to 1289
                annot_filename = sprintf('cfs-visit5-80%d-nsrr.xml', i);
                fprintf('Successfully loaded EDF and annotation files for index %d.\n', i);
            catch
                fprintf('Error loading files for index %d. Skipping this file.\n', i);
                continue;
            end
        end

        % Load annotations
        try
            annot = sleep_xmlread(annot_filename);
            fprintf('Successfully loaded annotations for index %d.\n', i);
        catch
            fprintf('Error loading annotations for index %d. Skipping this file.\n', i);
            continue;
        end

        % Find the index for the signal you have chosen
        signal_to_collect = [];
        for kk = 1:14
            if isequal(char(header.labels(kk)), signal_you_have_chosen)
                signal_to_collect = kk;
                break;
            end
        end
        if isempty(signal_to_collect)
            fprintf('Signal "%s" not found in file index %d. Available signals: %s. \nSkipping this file.\n', ...
                    signal_you_have_chosen, i, strjoin(header.labels, ', '));
            continue;
        else
            fprintf('Signal "%s" found and selected for processing in file index %d.\n', signal_you_have_chosen, i);
        end

        Fs = header.samplerate(signal_to_collect);  % Sampling rate
        data = signals{signal_to_collect}';         % Transpose data to row vector

        % Initialize variables for storing extracted data
        row = 0;
        fulldata = {};

        % Process events in the annotations
        NN = length(annot.ScoredEvents.ScoredEvent);
        fprintf('Processing %d scored events for index %d...\n', NN, i);

        for j = 1:NN
            event = annot.ScoredEvents.ScoredEvent(j).EventConcept;
            try
                % Mark the label based on the event type
                if isequal(event, 'Obstructive apnea|Obstructive Apnea')
                    row = row + 1;
                    start_time = round((annot.ScoredEvents.ScoredEvent(j).Start) * Fs);
                    duration = round((annot.ScoredEvents.ScoredEvent(j).Duration) * Fs);
                    fulldata{row,1} = data(1, start_time + 1 : start_time + duration);
                    fulldata{row,2} = 'Obstructive apnea';

                elseif isequal(event, 'Central apnea|Central Apnea')
                    row = row + 1;
                    start_time = round((annot.ScoredEvents.ScoredEvent(j).Start) * Fs);
                    duration = round((annot.ScoredEvents.ScoredEvent(j).Duration) * Fs);
                    fulldata{row,1} = data(1, start_time + 1 : start_time + duration);
                    fulldata{row,2} = 'Central apnea';

                elseif isequal(event, 'Hypopnea|Hypopnea')
                    row = row + 1;
                    start_time = round((annot.ScoredEvents.ScoredEvent(j).Start) * Fs);
                    duration = round((annot.ScoredEvents.ScoredEvent(j).Duration) * Fs);
                    fulldata{row,1} = data(1, start_time + 1 : start_time + duration);
                    fulldata{row,2} = 'Hypopnea';

                elseif isequal(event, 'SpO2 artifact|SpO2 artifact')
                    row = row + 1;
                    start_time = round((annot.ScoredEvents.ScoredEvent(j).Start) * Fs);
                    duration = round((annot.ScoredEvents.ScoredEvent(j).Duration) * Fs);
                    fulldata{row,1} = data(1, start_time + 1 : start_time + duration);
                    fulldata{row,2} = 'SpO2 artifact';

                elseif isequal(event, 'Arousal|Arousal ()')
                    row = row + 1;
                    start_time = round((annot.ScoredEvents.ScoredEvent(j).Start) * Fs);
                    duration = round((annot.ScoredEvents.ScoredEvent(j).Duration) * Fs);
                    fulldata{row,1} = data(1, start_time + 1 : start_time + duration);
                    fulldata{row,2} = 'Arousal';

                elseif isequal(event, 'SpO2 desaturation|SpO2 desaturation')
                    row = row + 1;
                    start_time = round((annot.ScoredEvents.ScoredEvent(j).Start) * Fs);
                    duration = round((annot.ScoredEvents.ScoredEvent(j).Duration) * Fs);
                    fulldata{row,1} = data(1, start_time + 1 : start_time + duration);
                    fulldata{row,2} = 'SpO2 desaturation';
                end
            catch
                fprintf('Error processing event %s in index %d. Skipping this event.\n', event, i);
            end
        end

        if isempty(fulldata)
            fprintf('No relevant events found in index %d. Skipping this file.\n', i);
            continue;
        else
            fprintf('Finished processing events for index %d.\n', i);
        end

        % Initialize matrix to store the segmented data
        sliding_window_matrix = {};
        label_matrix = {};
        % Parameters for sliding window
        window_size = window_time * Fs;  % Window size in samples (seconds to samples)
        window_step = window_step * Fs;   % Step size in samples (seconds to samples)

        % Loop through each row of fulldata
        for row_idx = 1:size(fulldata, 1)
            signal_data = fulldata{row_idx, 1};  % The signal data
            label = fulldata{row_idx, 2};        % The label

            % Number of windows that can be extracted from the signal
            num_windows = floor((length(signal_data) - window_size) / window_step) + 1;

            for win_idx = 1:num_windows
                win_start = (win_idx - 1) * window_step + 1;
                win_end = win_start + window_size - 1;

                if win_end <= length(signal_data)
                    % Extract the window
                    sliding_window_matrix{end+1, 1} = signal_data(win_start:win_end);
                    label_matrix{end+1, 1} = label;  % Store the corresponding label
                end
            end
        end

        if isempty(sliding_window_matrix)
            fprintf('No sliding windows were generated for index %d. Skipping this file.\n', i);
            continue;
        end

        % Convert sliding_window_matrix to a numeric matrix and keep labels as a separate column
        num_windows_total = length(sliding_window_matrix);
        data_to_save = [];

        % Construct the data for saving, one row per window
        for row = 1:num_windows_total
            window_data = sliding_window_matrix{row};  % Numeric data for this window
            label = label_matrix{row};                 % Label for this window

            % Append each row of data with its corresponding label at the end
            data_to_save = [data_to_save; {window_data, label}];
        end

        % Convert the data to a table
        T = cell2table(data_to_save, 'VariableNames', {'WindowData', 'Label'});

        % Define the output filename based on the EDF file name and parameters
        output_filename = sprintf('shhs2-%d_%s_window%d_step%d.csv', i, signal_you_have_chosen, window_time, window_step/Fs);

        % Write the table to a CSV file
        try
            writetable(T, output_filename);
            fprintf('Data successfully saved to %s.\n', output_filename);
        catch
            fprintf('Error saving data for file index %d. Skipping this file.\n', i);
        end
    end
end
