function cycles = find_perfect_5cycles(g)
    % Find all groups of 5 dual-types that have a
    % rock-paper-scissors-lizard-Spock relationship. Input a directed graph
    % containing all the matchups.
    beats_fn = @neutrally_beats;
    cycles = [];    % All perfect 5-cycles, 1 per row
    all_nodes = string(g.Nodes.Name)';
    for i = 1:length(all_nodes)
        fprintf('%s %s\n', sprintf('(%i)', i), all_nodes(i));
        for j = setdiff(1:length(all_nodes), i)
            if ~beats_fn(all_nodes(i), all_nodes(j), g)
                continue;
            end
            fprintf('%s %s\n', sprintf('(%i, %i)', i, j), all_nodes(j));
            for k = setdiff(1:length(all_nodes), [i, j])
                if ~beats_fn(all_nodes(j), all_nodes(k), g) || ...
                   ~beats_fn(all_nodes(k), all_nodes(i), g)
                    continue;
                end
                fprintf('%s %s\n', sprintf('(%i, %i, %i)', i, j, k), ...
                    all_nodes(k));
                for l = setdiff(1:length(all_nodes), [i, j, k])
                    if ~beats_fn(all_nodes(l), all_nodes(j), g) || ...
                       ~beats_fn(all_nodes(i), all_nodes(l), g) || ...
                       ~beats_fn(all_nodes(k), all_nodes(l), g)
                        continue;
                    end
                    fprintf('%s %s\n', sprintf('(%i, %i, %i, %i)', i, j, k, l), ...
                        all_nodes(l));
                    for m = setdiff(1:length(all_nodes), [i, j, k, l])
                        if ~beats_fn(all_nodes(m), all_nodes(i), g) || ...
                           ~beats_fn(all_nodes(m), all_nodes(k), g) || ...
                           ~beats_fn(all_nodes(j), all_nodes(m), g) || ...
                           ~beats_fn(all_nodes(l), all_nodes(m), g)
                            continue;
                        end
                        fprintf('!!!%s %s!!!\n', sprintf('(%i, %i, %i, %i, %i)', ...
                            i, j, k, l, m), all_nodes(m));
                        cycles = [cycles; all_nodes([i, j, k, l, m])];
                    end
                end
            end
        end
    end
end

function w = edge_weight(atk, def, g)
    w = g.Edges.Weight(findedge(g, atk, def));
end

% function beats(atk, def, g)
%     b = edge_weight(atk, def, g) > 1;
% end

function b = fully_beats(atk, def, g)
    b = (edge_weight(atk, def, g) > 1) && (edge_weight(def, atk, g) < 1);
end

function b = neutrally_beats(atk, def, g)
    b = (edge_weight(atk, def, g) > 1) && (edge_weight(def, atk, g) == 1);
end