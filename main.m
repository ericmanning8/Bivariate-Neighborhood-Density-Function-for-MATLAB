%Main Script%

%Data Load-In
file1 = 'tests/Drif correct actin final 25255-50255.csv'; %enter file name at 'fileName'
file2 = 'tests/Drif correct cav1 and grouped final 6500-25255.csv'; %enter file name at 'fileName'
data1 = fopen(file1);
data2 = fopen(file2);

%NOT SURE HOW TO DEFINE THE FOLLOWING VARIABLES

x1 = data1(:,6);
y1 = data1(:,7);
x2 = data2(:,9);
y2 = data2(:,10);
t_incr = 10;
n = length(x1);
n2 = length(x2);

bins = ceil(max_step / t) + 1;
    
if ((bins * t) > (max_step + t))
    bins = bins - 1;
end

% xmin =
% ymin = 
% xmax = 
% ymax = 
% area = 

%Edge Correction or nah?

method = ChooseEdgeCorrection();

if (method == 1) %1 is with edge corrections
    gfl_12 = biEstimateGFyesEC12(x1, y1, x2, y2, t_incr, last_t, n, n2, bin, xmin, ymin, xmax, ymax, area);
    gfl_21 = biEstimateGFyesEC21(x1, y1, x2, y2, t_incr, last_t, n, n2, bin, xmin, ymin, xmax, ymax, area);
else %without edge corrections
    gfl_12 = biEstimateGFnoEC12(x1, y1, x2, y2, t_incr, bin, n, n2, area);
    gfl_21 = biEstimateGFnoEC21(x1, y1, x2, y2, t_incr, bin, n, n2, area);
end

% NEED TO FIGURE OUT HOW TO DISPLAY 
contourf(gfl_12);
countourf(gfl_21);
