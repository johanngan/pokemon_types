function unique_cycles = remove_duplicate_cycles(cycles)
    % Removes duplicate cycles from <cycles> (mxn string array where
    % m is the number of cycles and n is the number of nodes per cycle)
    % Use to clean the output from find_perfect_5cycles because it finds
    % duplicates
    [~, unique_row_idxs] = unique(sort(cycles, 2), 'rows');
    unique_cycles = cycles(unique_row_idxs, :);
end