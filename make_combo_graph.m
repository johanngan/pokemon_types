% Makes the directed graph with Pokémon type combinations.

load('type_matchups.mat');
types = type_matchups.Nodes.Name;

combos = cell(length(types)*(length(types)+1)/2, 2);
combo_colors = cell(size(combos, 1), 1);
i = 0;
for t1 = 1:length(types)
    for t2 = t1:length(types)
        i = i + 1;
        combos(i, 1) = types(t1);
        combos(i, 2) = types(t2);
        combo_colors{i} = mean([type_colors{t1}; type_colors{t2}]);
    end
end

% Calculate type matchups based on optimal offensive choice
s = cell(length(combos)^2, 1);
t = cell(size(s));
w = zeros(size(s));

i = 0;
progress = 0;
for c1 = 1:length(combos)
    for c2 = 1:length(combos)
        i = i + 1;
        s{i} = combo_name(combos(c1, :));
        t{i} = combo_name(combos(c2, :));
        w(i) = optimal_mult(type_matchups, combos(c1, :), combos(c2, :));
        
        if floor(100*i/length(s)) > progress
            progress = floor(100*i/length(s));
            fprintf('%i%% complete.\n', progress);
        end
    end
end

combo_matchups = digraph(s, t, w);
save('combo_matchups.mat', 'combo_matchups', 'combo_colors');


function name = combo_name(combo)
    % Converts cell array into a nice string
    if string(combo{1}) == string(combo{2})
        name = combo{1};
    else
        name = [combo{1}, '/', combo{2}];
    end
end

function mult = optimal_mult(type_matchups, combo1, combo2)
    % Calculate the multiplier if combo1 attacks combo2 with the best
    % possible STAB choice.
    mult = calc_mult(type_matchups, combo1(1), combo2);
    if string(combo1{1}) ~= string(combo1{2})
        mult = max(mult, calc_mult(type_matchups, combo1(2), combo2));
    end
end

function mult = calc_mult(type_matchups, type, combo)
    % for <type> attacking <combo>
    
    mult = get_weight(type_matchups, type, combo(1));
    if string(combo{1}) ~= string(combo{2})
        mult = mult * get_weight(type_matchups, type, combo(2));
    end
end

function w = get_weight(type_matchups, node1, node2)
    w = type_matchups.Edges.Weight(type_matchups.findedge(node1, node2));
end