function plot_cycle(cycle)
    % Plot a cycle (1xn string array) nicely, with proper colors,
    % color-coded type matchups, labels, etc.
    addpath('..');
    load('combo_matchups.mat');
    % Plots type-advantages of a cycle in a nice directed graph
    cycle_graph = subgraph(combo_matchups, cycle);

    set(0, 'defaultfigureposition', [400, 400, 1920, 1080])
    set(0, 'defaultAxesFontSize', 16)
    h = plot(cycle_graph, 'layout', 'circle', 'arrowsize', 10, ...
        'nodelabel', [], 'markersize', 16, 'linewidth', 2);
    axis square;
    
    % Adjust margins
    margin_stretch = 0.2;
    pos = get(gca, 'Position');
    pos(1:2) = pos(1:2) - margin_stretch/2;
    pos(3:4) = pos(3:4) * (1+margin_stretch);
    set(gca, 'Position', pos)

    for i = 1:length(cycle_graph.Nodes.Name)
        highlight(h, cycle_graph.Nodes.Name{i}, 'NodeColor', ...
            combo_colors{findnode(combo_matchups, cycle_graph.Nodes.Name(i))});
    end
    
    initial_color_order = get(gca, 'ColorOrder');
    defaultblue = initial_color_order(1, :);
    multiplier_colors = containers.Map(...
        [4, 2, 1, 0.5, 0], ...
        {'c', 'g', defaultblue, 'r', 'k'});

    for m = [4, 2, 1, 0.5, 0]
        [s, t] = mult_edges(cycle_graph, m);
        highlight(h, s, t, 'EdgeColor', multiplier_colors(m));
    end

    axis tight;
    axis off;
%     title(sprintf('Pokémon Type %i-Cycle', length(cycle)));
    center = mean([h.XData; h.YData], 2);
    radius = mean(sqrt(sum(([h.XData; h.YData] - center).^2)));
    stretchX = 0.35;
    stretchY = 0.18;
    Xoffset = -stretchX/16;
    for i=1:cycle_graph.numnodes
        name = cycle_graph.Nodes.Name{i};
        text(h.XData(i)*(1+stretchX)+Xoffset*length(name), h.YData(i)*(1+stretchY), ...
           name, 'fontsize', 16);
    end


    % Legend
    hold on;
    multipliers = sort(unique(cycle_graph.Edges.Weight), 'descend');
    for i = 1:length(multipliers)
        h(i) = plot(nan, nan, 'color', multiplier_colors(multipliers(i)), 'linewidth', 2);
    end
    legend(h, arrayfun(@(m) sprintf('%gx Damage', m), multipliers, ...
        'UniformOutput', false));
end

function [s, t] = mult_edges(cycle_graph, mult)
    sub = filter_graph(cycle_graph, mult);
    s = sub.Edges.EndNodes(:, 1);
    t = sub.Edges.EndNodes(:, 2);
end