% Plots type-advantages in a nice directed graph

load('type_matchups.mat');
type_matchups = filter_graph(type_matchups, [2, 0.5, 0]);   % No neutral relationships

set(0, 'defaultfigureposition', [400, 400, 1920, 1080])
set(0, 'defaultAxesFontSize', 16)
h = plot(type_matchups, 'layout', 'circle', 'arrowsize', 10, ...
    'nodelabel', [], 'markersize', 16, 'linewidth', 2);
for i = 1:length(type_matchups.Nodes.Name)
    highlight(h, type_matchups.Nodes.Name{i}, 'NodeColor', type_colors{i});
end

[s, t] = mult_edges(type_matchups, 2);
highlight(h, s, t, 'EdgeColor', 'g');

[s, t] = mult_edges(type_matchups, 0.5);
highlight(h, s, t, 'EdgeColor', 'r');

[s, t] = mult_edges(type_matchups, 0);
highlight(h, s, t, 'EdgeColor', 'k');

axis tight;
axis off;
title('Pokémon Type Advantages');
center = mean([h.XData; h.YData], 2);
radius = mean(sqrt(sum(([h.XData; h.YData] - center).^2)));
perturb = 0.075;
Xoffset = -perturb/9;
for i=1:type_matchups.numnodes
    name = type_matchups.Nodes.Name{i};
    text(h.XData(i)*(1+perturb)+Xoffset*length(name), h.YData(i)*(1+perturb), ...
       name, 'fontsize', 16);
end



% Legend
hold on;
l = zeros(3, 1);
h(1) = plot(nan, nan, 'g', 'linewidth', 2);
h(2) = plot(nan, nan, 'r', 'linewidth', 2);
h(3) = plot(nan, nan, 'k', 'linewidth', 2);
legend(h, '2x Damage', '0.5x Damage', '0x Damage');

function [s, t] = mult_edges(type_matchups, mult)
    sub = filter_graph(type_matchups, mult);
    s = sub.Edges.EndNodes(:, 1);
    t = sub.Edges.EndNodes(:, 2);
end