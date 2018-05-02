% Returns weighted adjacency matrix of a directed graph, where each row
% represents the ingoing edge weights to the corresponding node.

function A = weighted_adjacency(G)
    A = zeros(G.numnodes);
    
    s = G.findnode(G.Edges.EndNodes(:, 1));
    t = G.findnode(G.Edges.EndNodes(:, 2));
    
    A(sub2ind(size(A), t, s)) = G.Edges.Weight;
end