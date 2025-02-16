%% CF963 Task 1: Moving Average Trading Strategy
% Load stock price data
ABNB_data = readtable('ABNB.csv');
disp(head(ABNB_data)); % Display first few rows to check column names
prices = ABNB_data{:, end}; % Extract last column as a workaround if unsure
n = length(prices);

% Parameters
budget = 1.5e6; % Initial budget in GBP
shares = 0;

% Compute Moving Averages
MA9 = movmean(prices, 9);
MA18 = movmean(prices, 18);

% Identify Buy and Sell Signals
buy_days = [];
sell_days = [];
profits = [];

for i = 2:n
    if MA9(i) > MA18(i) && MA9(i-1) <= MA18(i-1)
        shares = floor(budget / prices(i));
        cost = shares * prices(i);
        budget = budget - cost;
        buy_days = [buy_days; i];
    elseif MA9(i) < MA18(i) && MA9(i-1) >= MA18(i-1)
        revenue = shares * prices(i);
        profit = revenue - (shares * prices(find(buy_days == i-1, 1, 'last')));
        profits = [profits; profit];
        budget = budget + revenue;
        shares = 0;
        sell_days = [sell_days; i];
    end
end

total_profit = sum(profits);

% Display Results
fprintf('Buy Days: %s\n', mat2str(buy_days));
fprintf('Sell Days: %s\n', mat2str(sell_days));
fprintf('Total Profit: £%.2f\n', total_profit);

% Plot Results
figure;
plot(prices, 'k'); hold on;
plot(MA9, 'b');
plot(MA18, 'r');
scatter(buy_days, prices(buy_days), 'g', 'filled');
scatter(sell_days, prices(sell_days), 'r', 'filled');
legend('Price', '9MA', '18MA', 'Buy', 'Sell');
title('Moving Average Trading Strategy');
