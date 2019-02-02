function b = is_dualtypes(cycle)
    % Check if a cycle (1xn string array) has only dual-typed nodes
    addpath('..');
    b = false;
    for t = cycle
        if length(split_types(t)) < 2
            return;
        end
    end
    b = true;
end