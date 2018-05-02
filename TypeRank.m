% Like PageRank with weighted linking factors.
% Combines both "Danger" and "Resistance" ranking factors.
% System:
%   attack = damping + d*Danger*defense
%   defense = damping + d*(base - Resistance*attack)

function TypeRank(matchups, colors)

    nTop = 20;      % Number of top scorers to show
    nBottom = 20;   % Number of bottom scorers to show
    compress_types = false;  % Compress dual-type scores into mono-type scores
    d = 1;  % Damping factor. 1 for the simplified version (no damping).

    %% Attack score
    % Solve for the <attack> vector in the system steady-state.
    A = weighted_adjacency(matchups);
    Resistance = A ./ sum(A);

    matchups = flipedge(matchups);

    A = weighted_adjacency(matchups);
    Danger = A ./ sum(A);

    % Damping vector and base damage vector
    damping = (1-d)/matchups.numnodes * ones(matchups.numnodes, 1);
    base = 2/matchups.numnodes * ones(matchups.numnodes, 1);

    attack = (eye(size(Danger)) + d^2*Danger*Resistance) \ ...
        ((eye(size(Danger)) + d*Danger)*damping + d^2*Danger*base);

    %% Defense score
    defense = damping + d*(base - Resistance*attack);

    %% Test score
    % A test ranking system that's more symmetric than the main system.
    % Follows the equations:
    %   attack = damping + d*Danger*(attack+defense)/2
    %   defense = damping + d*(base - Resistance*(attack+defense)/2)
    % which reduces to a single equation in R = (attack + defense)/2:
    %   R = damp + d/2 * (Base + (Danger-Resistance)*R)
    test = (eye(size(Danger)) + d/2*(Resistance - Danger)) \ (damping + d/2*base);

    %% Display the ranking results.
    clc;
    close all;
    types = matchups.Nodes.Name;

    attack_weight = 1;
    defense_weight = 1;
    % Overall score is a weighted average of offensive and defensive score
    overall = (attack_weight*attack + defense_weight*defense) ...
        / (attack_weight + defense_weight);

    
    if compress_types
        load('type_matchups.mat');
        mono_types = type_matchups.Nodes.Name;
        attack = compress_scores(attack, types, mono_types);
        defense = compress_scores(defense, types, mono_types);
        test = compress_scores(test, types, mono_types);
        overall = compress_scores(overall, types, mono_types);
        types = mono_types;
        colors = type_colors;
    end
    
    nTop = min(nTop, length(types));
    nBottom = min(nBottom, length(types));
    
    if nBottom == 0
        set(0, 'defaultfigureposition', [400, 400, 800, 600])
    else
        set(0, 'defaultfigureposition', [400, 400, 1920, 600])
    end
    set(0, 'defaultAxesFontSize', 16)
    disp_rankings(attack, nTop, nBottom, 'Offensive Typings', types, colors);
    disp_rankings(defense, nTop, nBottom, 'Defensive Typings', types, colors);
    disp_rankings(test, nTop, nBottom, 'Typings (Symmetric Overall)', types, colors);
    disp_rankings(overall, nTop, nBottom, 'Typings (Overall)', types, colors);
end

function compressed = compress_scores(scores, type_combos, mono_types)
    % Reduce the dual-type scores to mono-type scores
    compressed = zeros(length(mono_types), 1);
    
    for t = 1:length(mono_types)
        compressed(t) = mean(scores(contains(type_combos, mono_types{t})));
    end
    
    compressed = compressed / sum(compressed);
end

function disp_rankings(scores, nTop, nBottom, name, types, colors)
    % Display and plot the best/worst few scorers for a given score set
    [top, idx] = sort(scores, 'Descend');
    top = top(1:nTop);
    top_types = types(idx(1:nTop));
    top_colors = colors(idx(1:nTop));

    [bot, idx] = sort(scores, 'Ascend');
    bot = flip(bot(1:nBottom));
    bot_types = types(flip(idx(1:nBottom)));
    bot_colors = colors(flip(idx(1:nTop)));

    % List the scores
    fprintf(['\n', name, ':']);
    fprintf('\n--------------------\n');
    for i = 1:length(top_types)
        fprintf('%3i. %-20s%f\n', i, top_types{i}, top(i));
    end

    if nBottom > 0
        fprintf('%20s\n', '.....');
        for i = 1:length(bot_types)
            fprintf('%3i. %-20s%f\n', length(types)-nBottom+i, ...
                bot_types{i}, bot(i));
        end
    end
    
    % Plot the best
    figure; clf;
    
    if nBottom > 0
        subplot(1, 2, 1);
    end
    
    x = categorical(top_types);
    x = reordercats(x, top_types);
    top_graph = bar(x, top);
    top_graph.FaceColor = 'flat';
    for i = 1:length(top_types)
        top_graph.CData(i, :) = top_colors{i};
    end
    
    
    title([sprintf('Top %i ', nTop), name]);
    y = ylabel('Rank Value');
    y.Position = y.Position - [0.5, 0, 0];
    
    % Plot the worst
    if nBottom > 0
        subplot(1, 2, 2);
        x = categorical(bot_types);
        x = reordercats(x, bot_types);
        bot_graph = bar(x, bot);
        bot_graph.FaceColor = 'flat';
        for i = 1:length(top_types)
            bot_graph.CData(i, :) = bot_colors{i};
        end
        title([sprintf('Bottom %i ', nBottom), name]);
        y = ylabel('Rank Value');
        y.Position = y.Position - [0.5, 0, 0];
    end
end