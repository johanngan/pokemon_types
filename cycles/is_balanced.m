function b = is_balanced(cycle, g, include_self)
    % Check if all types in a cycle (1xn string array) have the same
    % distribution of matchups. Also input a directed graph with all the
    % possible type matchups. The <include_self> flag determines whether or
    % not to check if all the self-matchups of cycle nodes are the same.
    %
    % E.g. each node has 2x against two others and 0.5x against two others,
    % or something like that
    if nargin < 3
        include_self = false;
    end
    b = false;
    gcycle = subgraph(g, cycle);
    % Remove self loops
    gcycle = rmedge(gcycle, findedge(gcycle, cycle, cycle));

    matchups = sort(unique(gcycle.Edges.Weight));
    matchup_counts = zeros(size(matchups));
    for i = 1:length(matchups)
        matchup_counts(i) = sum(gcycle.Edges.Weight == matchups(i));
    end
    if any(mod(matchup_counts, length(cycle)) ~= 0)
        return;
    end
    matchups = repelem(matchups, matchup_counts/length(cycle));
    
    for t = cycle
        weights = gcycle.Edges.Weight(inedges(gcycle, t));
        weights = [weights, gcycle.Edges.Weight(outedges(gcycle, t))];
        if any(sort(weights) ~= matchups)
            return;
        end
    end
    if include_self
        gcycle = subgraph(g, cycle);
        if length(unique(gcycle.Edges.Weight(...
                findedge(gcycle, cycle, cycle)))) ~= 1
            return;
        end
    end
    
    b = true;
end