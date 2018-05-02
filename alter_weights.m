% Alters weight values in a directed graph.

function altered = alter_weights(type_matchups, old_multiplier, new_multiplier)
    EdgeTable = type_matchups.Edges;
    
    EdgeTable.Weight(EdgeTable.Weight == old_multiplier) = new_multiplier;
    
    altered = digraph(EdgeTable);
end