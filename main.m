%Main Script%

%Data Load-In
file1 = 'tests/actin truncated.csv'; %enter file name at 'fileName'
file2 = 'tests/cav1 truncated.csv'; %enter file name at 'fileName'
data1 = readmatrix(file1);
data2 = readmatrix(file2);

x1 = data1(:,6);
y1 = data1(:,7);
x2 = data2(:,9);
y2 = data2(:,10);
t = 10;
n = length(x1);
n2 = length(x2);
max_step = 1000;

bins = ceil(max_step / t) + 1;
    
if ((bins * t) > (max_step + t))
    bins = bins - 1;
end

xmin = min(min(x1), min(x2));
ymin = min(min(y1), min(y2));
xmax = max(max(x1), max(x2));
ymax = max(max(y1), max(y2));
    
area = (xmax-xmin)*(ymax-ymin);

gfl_12 = zeros(n + 1, bins + 1);
gfl_21 = zeros(n + 1, bins + 1);

%looping

t_incr = 0;
i = 1;

%Edge Correction

method = ChooseEdgeCorrection();

wb = waitbar(0, 'Computing Cross-Clustering Function...');
while(i <= bins)
    percentDone = (t_incr / max_step);
    waitbar(percentDone, wb);
    
    if (method == 1) %1 is with edge corrections
        gfl_12 = biEstimateGFyesEC12(x1, y1, x2, y2, t_incr, last_t, n, n2, i, xmin, ymin, xmax, ymax, area);
        gfl_21 = biEstimateGFyesEC21(x1, y1, x2, y2, t_incr, last_t, n, n2, i, xmin, ymin, xmax, ymax, area);
    else %without edge corrections
        gfl_12 = biEstimateGFnoEC12(gfl_12, x1, y1, x2, y2, t_incr, i, n, n2, area);
        gfl_21 = biEstimateGFnoEC21(gfl_21, x1, y1, x2, y2, t_incr, i, n, n2, area);
    end
    
    i = i + 1;
    t_incr = t_incr + t;
    
end 
close(wb);

%DISPLAY 
contourf(gfl_12);
contourf(gfl_21);

% simulation 
for i = 1:n2        % Loop through 2 -> 1 (2 = focal, 1 = assessed)
    for j = 1:n
        if ((abs(x2(i) - x1(j)) < t_incr) && (abs(y2(i) - y1(j)) < t_incr))  % Skip points outside bounding box (Fisher, 1990)

            dij = EuclDistance(x2(i), y2(i), x1(j), y1(j)); % Distance between points

            if (dij <= t_incr && dij > last_t) % If the point's in the circle ...

                dx = dist_x(x2(i), xmin, xmax);
                dy = dist_y(y2(i), ymin, ymax); % Distance to boundaries
                dx2 = max(xmax - x2(i), x2(i) - xmin); 
                dy2 = max(ymax - y2(i), y2(i) - ymin);

                method = assess_edge(dij, dx, dy, dx2, dy2);

                if method == 0 
                    edge_wgt = 1;
                elseif method == 1 
                    edge_wgt = edge_corr1(min(dx, dy), dij);
                elseif method == 2
                    edge_wgt = edge_corr2(dx, dy, dx2, dy2, dij);
                elseif method == 3 
                    edge_wgt = edge_corr3(dx, dy, dx2, dy2, dij);
                end
                
                gfl_21(i, bin) = gfl_21(i, bin) + edge_wgt; % Update value of GF l(d)
            end
        end
    end

    if bin == 1
        gfl_21(i, bin) = area * (gfl_21(i, bin) / ((n - 1))); % Final GF L value for i at bin
    else
        gfl_21(i, bin) = gfl_21(i, bin - 1) + area * (gfl_21(i, bin) / ((n - 1))); % Final GF L value for i at bin
    end
    
end