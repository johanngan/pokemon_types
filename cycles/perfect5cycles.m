% Run the search function on the directed graph of dual-type matchups to
% find rock-paper-scissors-lizard-Spock groups
%
% Note: there exist NO perfect 5-cycles with only super-effective +
% not-very-effective relations

addpath('..');
load('combo_matchups.mat');

cycles = find_perfect_5cycles(combo_matchups);
