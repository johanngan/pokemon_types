% Like PageRank with weighted linking factors.
% Models "damage resistance" rather than "rank accumulation".
% Higher resistance decreases damage taken from a base rate, allowing the
% resistance score to accumulate.

d = 0.85;  % Damping factor. 1 for the simplified version (no damping).



load('type_matchups.mat');

% Filter out self-loops.
% type_matchups = filter_graph(type_matchups, [2, 0.5, 0, 1], false);

% Construct the "resistance" matrix (weighted linking factors)
A = weighted_adjacency(type_matchups);
Resistance = A ./ sum(A);

% Damping vector
damping = (1-d)/type_matchups.numnodes * ones(type_matchups.numnodes, 1);
base = 2/type_matchups.numnodes * ones(type_matchups.numnodes, 1);

% Solve the equation r = damping + d*(base - Resistance*r).
r = (eye(size(Resistance)) + d*Resistance) \ (damping + d*base);

%% Display the rank vector results.
types = type_matchups.Nodes.Name;

[r, idx] = sort(r, 'Descend');
types = types(idx);

fprintf('\nResistance Rankings:');
fprintf('\n--------------------\n');
for i = 1:length(types)
    fprintf('%3i. %-12s%f\n', i, types{i}, r(i));
end

figure(3); clf;
x = categorical(types);
x = reordercats(x, types);
bar(x, r);
title('ResistanceRank Values');