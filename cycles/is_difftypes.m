function b = is_difftypes(cycle)
    % Check if a cycle (1xn string array) involves no repeated types
    addpath('..');
    b = false;
    types = split_types(cycle(1));
    for i = 2:length(cycle)
        tlist = split_types(cycle(i));
        if ~isempty(types) && any(any(types == tlist'))
            return;
        end
        types = [types, tlist];
    end
    b = true;
end