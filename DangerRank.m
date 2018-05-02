% Like PageRank with weighted linking factors.
% Models "rank accumulation", where each type cites its weaknesses to be
% more dangerous, and therefore, higher rank.

d = 0.85;  % Damping factor. 1 for the simplified version (no damping).



load('type_matchups.mat');

% Flip the edges to go from "damaging" to "citing danger".
type_matchups = flipedge(type_matchups);

% Filter out self-loops.
% type_matchups = filter_graph(type_matchups, [2, 0.5, 0, 1], false);

% Construct the "danger" matrix (weighted linking factors)
A = weighted_adjacency(type_matchups);
Danger = A ./ sum(A);

% Damping vector
damping = (1-d)/type_matchups.numnodes * ones(type_matchups.numnodes, 1);

% Solve the equation r = damping + d*Danger*r.
r = (eye(size(Danger)) - d*Danger) \ damping;

%% Display the rank vector results.
types = type_matchups.Nodes.Name;

[r, idx] = sort(r, 'Descend');
types = types(idx);

fprintf('\nOffensive Rankings:');
fprintf('\n--------------------\n');
for i = 1:length(types)
    fprintf('%3i. %-12s%f\n', i, types{i}, r(i));
end

figure(2); clf;
x = categorical(types);
x = reordercats(x, types);
bar(x, r);
title('DangerRank Values');