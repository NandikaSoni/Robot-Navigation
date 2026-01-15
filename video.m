clc; clear; close all;

% Define the graph edges (Nodes only, without Weights)
edges = [
    1 2; 3 4; 3 5; 5 4;
    5 6; 5 7; 7 1; 7 8;
    8 9; 9 10; 10 6; 10 5;
    3 11; 11 12; 11 13; 13 12;
    7 9; 7 2; 6 11; 12 14;
    13 15; 15 16; 6 16; 15 17;
    17 18; 16 18; 6 18; 15 19;
    19 20; 20 21; 15 22; 22 23;
    23 21; 6 21; 15 24; 24 25;
    25 26; 15 27; 27 28; 27 26;
    28 26; 25 29; 29 30; 31 30;
    31 29; 32 31; 32 30; 32 29;
    26 30; 26 29; 18 33; 33 31;
    18 31; 15 34; 34 28; 34 27;
    34 35; 34 36; 36 37; 38 39;
    37 38; 39 27; 39 26; 39 28;
    30 39; 39 34; 14 15
];

% Convert edges to graph object
G = graph(edges(:,1), edges(:,2));

% Get user input for start and end node
startNode = input('Enter Start Node: ');
endNode = input('Enter Destination Node: ');

% Find initial shortest path
[path, ~] = shortestpath(G, startNode, endNode);

% Create and plot the graph with layout
figHandle = figure;
p = plot(G, 'Layout', 'force');
title('Robot Navigation with Dynamic Blockages');
hold on;

% 🎥 Setup video writer
v = VideoWriter('DynamicRoutingDemo.avi');
v.FrameRate = 1.5;
open(v);
frame = getframe(figHandle); writeVideo(v, frame);

% Highlight initial path in blue
pause(1.5);
highlight(p, path, 'EdgeColor', 'b', 'LineWidth', 2);
frame = getframe(figHandle); writeVideo(v, frame);

% Initialize variables for dynamic blockages
maxBlocks = 5;
blockedEdges = zeros(maxBlocks, 2);
blockCount = 0;
currentIndex = 1;

% Traverse the path dynamically
while currentIndex < length(path)
    currentNode = path(currentIndex);
    nextNode = path(currentIndex + 1);

    % Highlight traversal in green
    pause(1.2);
    highlight(p, [currentNode, nextNode], 'EdgeColor', 'g', 'LineWidth', 2);
    frame = getframe(figHandle); writeVideo(v, frame);

    % Introduce random block with 30% chance
    if rand() < 0.3 && blockCount < maxBlocks
        Gtemp = rmedge(G, currentNode, nextNode);

        % Try finding alternate path from currentNode
        if ~isempty(shortestpath(Gtemp, currentNode, endNode))
            G = Gtemp;
            blockCount = blockCount + 1;
            blockedEdges(blockCount, :) = [currentNode, nextNode];

            % Highlight blocked edge
            pause(1);
            highlight(p, [currentNode, nextNode], 'EdgeColor', 'r', 'LineWidth', 2, 'LineStyle', '--');
            frame = getframe(figHandle); writeVideo(v, frame);

            % Attempt to re-route
            [pathNew, ~] = shortestpath(G, currentNode, endNode);

            if isempty(pathNew)
                % Backtrack if no path
                backtrackIndex = currentIndex - 1;
                found = false;

                while backtrackIndex >= 1
                    backNode = path(backtrackIndex);
                    [newPath, ~] = shortestpath(G, backNode, endNode);
                    if ~isempty(newPath)
                        path = [path(1:backtrackIndex), newPath(2:end)];
                        currentIndex = backtrackIndex;
                        found = true;
                        break;
                    end
                    backtrackIndex = backtrackIndex - 1;
                end

                if ~found
                    disp('No path found after backtracking.');
                    text(mean(xlim), mean(ylim), 'NO PATH FOUND', 'Color', 'r', 'FontSize', 14, 'HorizontalAlignment', 'center');
                    frame = getframe(figHandle); writeVideo(v, frame);
                    break;
                end
            else
                path = [currentNode, pathNew(2:end)];
                currentIndex = 1;
            end
        else
            currentIndex = currentIndex + 1;
        end
    else
        currentIndex = currentIndex + 1;
    end
end

% Add legend
legend({'Initial Path (Blue)', 'Updated Path (Green)', 'Blocked Edges (Red Dotted)'}, 'Location', 'Best');
frame = getframe(figHandle); writeVideo(v, frame);

% Finish recording
close(v);

% Keep figure open
uiwait(figHandle);
