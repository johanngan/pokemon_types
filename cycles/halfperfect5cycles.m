% Run the search function on the directed graph of dual-type matchups to
% find "half-perfect" rock-paper-scissors-lizard-Spock groups (see
% explanation in find_halfperfect_5cycles.

addpath('..');
load('combo_matchups.mat');

cycles = find_halfperfect_5cycles(combo_matchups);
