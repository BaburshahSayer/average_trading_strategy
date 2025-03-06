%% CF963 Task 1: moving avg trading strat

% Load data
ABNB_data = readtable('ABNB.csv');
disp(head(ABNB_data)); % show first few rows
prices = ABNB_data{:, end}; % getting last coloumn (assuming its prices)
n = length(prices); %

% Setup money and shares
budget = 1.5e6; % 1.5 mil cash
shares = 0; % no shares yet

% MOVING AVERAGE THING
MA9 = movmean(prices, 9);  % avg of 9 days
MA18 = movmean(prices, 18); % avg of 18 days

% Arrays to keep track of what we do
buy_days = []; % buy time
sell_days = [];
profitss = [];

random_var = 0; %  maybe we need this later

% LOOPY LOOP to check every day's price
for i = 2:n
    fprintf('Checking day %d ...\n', i);

    if MA9(i) > MA18(i) && MA9(i-1) <= MA18(i-1) % if 9-day avg crosses above 18-day, buy?
        fprintf('BUY!!! at price %f\n', prices(i));
        sharez = floor(budget / prices(i)); % how many stocks can we afford?
        costz = sharez * prices(i); % money spent
        budget = budget - costz; % budget go down
        buy_days = [buy_days; i]; % save buy day
    elseif MA9(i) < MA18(i) && MA9(i-1) >= MA18(i-1) % if 9-day avg goes below 18-day, SELL!
        fprintf('SELLL at price %f\n', prices(i)); % panic sell alert

        if sharez == 0
            fprintf('Oops, no shares to sell... skipping this.\n');
            continue; %
        end
        
        revenue = sharez * prices(i); % selling money
        lastBuyIdx = find(buy_days == i-1, 1, 'last'); % last time we bought
        if isempty(lastBuyIdx) %
            fprintf('hmmm no buy found before sell? sus...\n');
            profitz = 0; % no profit
        else
            profitz = revenue - (sharez * prices(lastBuyIdx)); % profit calculation
        end
        profitss = [profitss; profitz]; % add to profits
        budget = budget + revenue; % money up!!!
        sharez = 0; % all gone
        sell_days = [sell_days; i]; % save when we sold
    else
        fprintf('Nothing happened today, just vibes...\n');
    end
end

total_profit = sum(profitss); % final money count

% PRINT EVERYTHING
fprintf('Buy Days: %s\n', mat2str(buy_days)); % show when we bought
fprintf('Sell Days: %s\n', mat2str(sell_days)); % show when we sold
fprintf('Total Profit: £%.2f\n', total_profit); % the money

% PLOTTING (very beautiful)
figure;
plot(prices, 'k'); hold on; % black line = stock price
plot(MA9, 'b'); % blue = 9-day MA
plot(MA18, 'r'); % red = 18-day MA
scatter(buy_days, prices(buy_days), 'g', 'filled'); % green dots = we buyed
scatter(sell_days, prices(sell_days), 'r', 'filled'); % red dots =  sell
legend('Price', '9MA', '18MA', 'Buy', 'Sell');
title('Moving Average Trading Strategy');
