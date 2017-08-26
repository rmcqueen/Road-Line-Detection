function drawBoxes(f2match, frame, type)
% drawBoxes: depending on the given type, it will draw the appropriate box,
% and indicate whether or not the sign is of the type one_way or speed_limit.
    if (strcmp('one_way', type) && size(f2match, 2) > 0)
        x = zeros(size(f2match, 2), 1);
        y = zeros(size(f2match, 2), 1);
        for j = 1:size(f2match, 2)
            x(j) = f2match(1, j);
            y(j) = f2match(2, j);
        end

        % Handle the scenario that we have two minimums.
        x0 = x(y==min(y));
        if (size(x0, 1) > 1)
            x0 = x0(1);
        end
        
       rectangle('Position', [x0, min(y(:)), 50, 50], 'LineWidth', 2, 'EdgeColor', 'r');
       text((size(frame, 1)/2), size(frame, 2)/2, 'One way street approaching!', 'FontSize', 30, 'FontWeight', 'bold', 'Color', 'b');
       
    elseif (strcmp('speed_limit', type) && size(f2match, 2) > 0)
        x = zeros(size(f2match, 2), 1);
        y = zeros(size(f2match, 2), 1);
        for j = 1:size(f2match, 2)
            x(j) = f2match(1, j);
            y(j) = f2match(2, j);
        end

        % Handle the scenario that we have two minimums.
        x0 = x(y==min(y));
        if (size(x0, 1) > 1)
            x0 = x0(1);
        end
        
       rectangle('Position', [x0, min(y(:)), 50, 50], 'LineWidth', 2, 'EdgeColor', 'r');
       text((size(frame, 1)/2), size(frame, 2)/2, 'Speed limit change! 25mph!', 'FontSize', 30, 'FontWeight', 'bold', 'Color', 'b');
    end
end