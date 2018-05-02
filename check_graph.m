% For manually checking the graph on a type-by-type basis.

type = "Normal";
check_connectivity = false;  % Flag for doing automatic connectivity checks.



clc;

if ~exist('type_matchups', 'var')
    load('type_matchups.mat');
end

% Print damage multipliers for an attacker of the specified type
fprintf('\n');
multipliers = [2, 0.5, 0, 1];
for mult = multipliers
    disp(type_matchups.Edges(...
        type_matchups.Edges.EndNodes(:, 1) == string(type) & ...
        type_matchups.Edges.Weight == mult, ...
        :))
end
% Stragglers that shouldn't be there
disp(type_matchups.Edges(...
        type_matchups.Edges.EndNodes(:, 1) == string(type) & ...
        all(type_matchups.Edges.Weight ~= multipliers, 2), ...
        :))


if check_connectivity
    fprintf('\nConnectivity:\n\n');
    degrees = cell2table(...
        [type_matchups.Nodes.Name, ...
         mat2cell(type_matchups.outdegree(type_matchups.Nodes.Name), ...
                  repelem(1, type_matchups.numnodes), 1), ...
         mat2cell(type_matchups.indegree(type_matchups.Nodes.Name), ...
                  repelem(1, type_matchups.numnodes), 1)], ...
         'VariableNames', {'Type', 'Outdegree', 'Indegree'});
    disp(degrees);
end