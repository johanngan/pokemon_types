% Like PageRank with weighted linking factors.
% Models "damage accumulation" rather than "rank accumulation".

d = 0.85;  % Damping factor. 1 for the simplified version (no damping).



load('type_matchups.mat');

% Filter out self-loops.
% type_matchups = filter_graph(type_matchups, [2, 0.5, 0, 1], false);

% Construct the "damage" matrix (weighted linking factors)
A = weighted_adjacency(type_matchups);
Damage = A ./ sum(A);

% Damping vector
damping = (1-d)/type_matchups.numnodes * ones(type_matchups.numnodes, 1);

% Solve the equation r = damping + d*Damage*r.
r = (eye(size(Damage)) - d*Damage) \ damping;

%% Display the rank vector results.
types = type_matchups.Nodes.Name;

[r, idx] = sort(r);
types = types(idx);

fprintf('\nDefensive Rankings:');
fprintf('\n--------------------\n');
for i = 1:length(types)
    fprintf('%3i. %-12s%f\n', i, types{i}, r(i));
end

figure(1); clf;
x = categorical(types);
x = reordercats(x, types);
bar(x, r);
title('DamageRank Values');