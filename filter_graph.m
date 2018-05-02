% Filter out the directed graph edges by multiplier
%   multipliers = vector of multipliers to filter for
%       2 for type advantages
%       0.5 for resistances
%       0 for immunities
%       1 for normal damage
%   self_loops = flag for keeping self loops

function filtered = filter_graph(type_matchups, multipliers, self_loops)
    if nargin < 3
        self_loops = true;
    end
    
    if iscolumn(multipliers)
        multipliers = multipliers';
    end
    
    EdgeTable = type_matchups.Edges(...
        any(type_matchups.Edges.Weight == multipliers, 2), :);
    
    if self_loops
        filtered = digraph(EdgeTable);
    else
        filtered = digraph(EdgeTable, 'OmitSelfLoops');
    end
    
    if isempty(setdiff(type_matchups.Nodes.Name, filtered.Nodes.Name))
        % Ensure the order in the output graph is the same as the input graph
        filtered = filtered.reordernodes(type_matchups.Nodes.Name);
    end
end