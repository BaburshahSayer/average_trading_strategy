%% CF963 Task 2: Decision Tree Classifier
% Define dataset
attributes = {'StockPrice', 'Market', 'Volatility', 'News'};
decision = {'Buy', 'Sell', 'Buy', 'Buy', 'Buy', 'Sell', 'Sell', 'Buy', 'Sell'};
data = ["Up", "Down", "Low", "Impartial";
        "Down", "Stable", "High", "Negative";
        "Up", "Stable", "High", "Positive";
        "Down", "Stable", "Low", "Positive";
        "Stable", "Stable", "Low", "Negative";
        "Down", "Down", "Low", "Impartial";
        "Stable", "Up", "High", "Negative";
        "Up", "Up", "Low", "Negative";
        "Down", "Down", "High", "Positive"];

% Convert categorical data
T = table(categorical(data(:,1)), categorical(data(:,2)), categorical(data(:,3)), ...
    categorical(data(:,4)), categorical(decision)', 'VariableNames', [attributes, {'Decision'}]);

% Train decision tree
tree1 = fitctree(T, 'Decision');
view(tree1, 'Mode', 'text'); % Output tree description

% Optimize MinParentSize to minimize classification loss
minLoss = inf;
bestSize = 1;
for minSize = 1:10
    tempTree = fitctree(T, 'Decision', 'MinParentSize', minSize);
    loss = resubLoss(tempTree);
    if loss == 0
        bestSize = minSize;
        break;
    end
end

tree2 = fitctree(T, 'Decision', 'MinParentSize', bestSize);
view(tree2, 'Mode', 'graph'); % Display optimized tree

% Output best MinParentSize value
fprintf('Optimal MinParentSize: %d\n', bestSize);
