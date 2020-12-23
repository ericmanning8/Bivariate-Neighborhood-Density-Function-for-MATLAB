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
max_step = 10000;

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

while(i <= bins)
    
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

%DISPLAY 
contourf(gfl_12);
contourf(gfl_21);
