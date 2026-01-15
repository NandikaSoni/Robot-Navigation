clc; clear; close all;

% Define the graph edges
edges = [
    1 2; 3 4; 3 5; 5 4; 5 6; 5 7; 7 1; 7 8;
    8 9; 9 10; 10 6; 10 5; 3 11; 11 12; 11 13; 13 12;
    7 9; 7 2; 6 11; 12 14; 13 15; 15 16; 6 16; 15 17;
    17 18; 16 18; 6 18; 15 19; 19 20; 20 21; 15 22; 22 23;
    23 21; 6 21; 15 24; 24 25; 25 26; 15 27; 27 28; 27 26;
    28 26; 25 29; 29 30; 31 30; 31 29; 32 31; 32 30; 32 29;
    26 30; 26 29; 18 33; 33 31; 18 31; 15 34; 34 28; 34 27;
    34 35; 34 36; 36 37; 38 39; 37 38; 39 27; 39 26; 39 28;
    30 39; 39 34; 14 15
];

% Assign uniform weight
weights = 5 * ones(size(edges, 1), 1);

% Create the graph
G = graph(edges(:,1), edges(:,2), weights);

% Start and destination
startNode = 1;
endNode = 28;

% Start timer
tic;

% Coordinates for heuristic (Euclidean layout on a unit circle)
nNodes = max(max(edges));
theta = linspace(0, 2*pi, nNodes+1);
nodeCoords = [cos(theta(1:nNodes)); sin(theta(1:nNodes))]';

% Heuristic function for A* (Euclidean distance)
heuristic = @(u,v) norm(nodeCoords(u,:) - nodeCoords(v,:));

% Prepare graph for A* search
G_Astar = G;
G_Astar.Edges.Weight = weights;

% Initial shortest path using A*
[initialPath, ~] = shortestpath(G_Astar, startNode, endNode);
if isempty(initialPath)
    disp('No initial path found.');
    return;
end

% Initialize for traversal
path = initialPath;
blockedEdges = [];
maxBlocks = 7;
blockCount = 0;
currentIndex = 1;

% Plot the graph
figure;
p = plot(G, 'Layout', 'force');
title('A* Navigation with Seven Dynamic Blockages');
hold on;
pause(2);
highlight(p, path, 'EdgeColor', 'b', 'LineWidth', 2);  % Blue = initial path

% Traverse the path
while currentIndex < length(path)
    currentNode = path(currentIndex);
    nextNode = path(currentIndex + 1);

    pause(1);
    highlight(p, [currentNode nextNode], 'EdgeColor', 'g', 'LineWidth', 2);  % Green = traversed path

    if blockCount < maxBlocks && rand() < 0.3
        Gtemp = rmedge(G_Astar, currentNode, nextNode);
        newPath = shortestpath(Gtemp, currentNode, endNode);

        if ~isempty(newPath)
            G_Astar = Gtemp;
            blockCount = blockCount + 1;
            blockedEdges(end+1, :) = [currentNode nextNode];
            pause(1);
            highlight(p, [currentNode nextNode], 'EdgeColor', 'r', 'LineWidth', 2, 'LineStyle', '--');  % Red dashed = blocked
            path = [path(1:currentIndex), newPath(2:end)];
        else
            disp('No alternative path found after blockage.');
            break;
        end
    else
        currentIndex = currentIndex + 1;
    end
end

% Stop timer
elapsedTime = toc;

% Legend
legend({'Initial Path (Blue)', 'Updated Path (Green)', 'Blocked Edges (Red Dotted)'}, 'Location', 'Best');

% Display summary
fprintf('\n--- Summary of A* Navigation (7 Edges Blocked) ---\n');
fprintf('Initial Path:      %s\n', mat2str(initialPath));
fprintf('Final Path Taken:  %s\n', mat2str(path));
if ~isempty(blockedEdges)
    for i = 1:size(blockedEdges, 1)
        fprintf('Blocked Edge %d:    [%d %d]\n', i, blockedEdges(i,1), blockedEdges(i,2));
    end
else
    fprintf('No edge was blocked during traversal.\n');
end
fprintf('Total Time Taken:  %.2f seconds\n', elapsedTime);

% Keep figure open
uiwait(gcf);
