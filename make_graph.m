% Makes the directed graph of Pokémon type relationships.

edges = readtable('type_chart.txt', 'ReadVariableNames', true);
type_matchups = digraph(edges.AttackType, edges.DefendType, edges.Multiplier);

% Type colors
type_colors = {[168, 168, 120]   % Normal
          [240, 128, 48],   % Fire
          [104, 144, 240],  % Water
          [248, 208, 48],   % Electric
          [120, 200, 80],   % Grass
          [152, 216, 216],  % Ice
          [192, 48, 40],    % Fighting
          [160, 64, 160],   % Poison
          [224, 192, 104],  % Ground
          [168, 144, 240],  % Flying
          [248, 88, 136],   % Psychic
          [168, 184, 32],   % Bug
          [184, 160, 56],   % Rock
          [112, 88, 152],   % Ghost
          [112, 56, 248],   % Dragon
          [112, 88, 72],    % Dark
          [184, 184, 208],  % Steel
          [238, 153, 172]}; % Fairy
% 0-255 to 0-1
for i = 1:length(type_colors)
    type_colors{i} = type_colors{i} / 255;
end

save('type_matchups.mat', 'type_matchups', 'type_colors');