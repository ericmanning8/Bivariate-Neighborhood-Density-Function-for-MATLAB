%Main Script%

%Data Load-In
fileName = 'fileName'; %enter file name at 'fileName'
data = fopen(fileName);

%NOT SURE HOW TO DEFINE THE FOLLOWING VARIABLES

% x1 = data(:,1);
% y1 = data(:,2);
% x2 =
% y2 =
% t_incr = 
% last_t = 
% n = 
% n2 = 
% bin = 
% xmin = 
% ymin = 
% xmax = 
% ymax = 
% area = 

%Edge Correction or nah?

method = ChooseEdgeCorrection();

if(method == 1) %1 is with edge corrections
    gfl_12 = biEstimateGFyesEC12(x1, y1, x2, y2, t_incr, last_t, n, n2, bin, xmin, ymin, xmax, ymax, area);
    gfl_21 = biEstimateGFyesEC21(x1, y1, x2, y2, t_incr, last_t, n, n2, bin, xmin, ymin, xmax, ymax, area);
else %without edge corrections
    gfl_12 = biEstimateGFnoEC12(x1, y1, x2, y2, t_incr, bin, n, n2, area);
    gfl_21 = biEstimateGFnoEC21(x1, y1, x2, y2, t_incr, bin, n, n2, area);
end

% NEED TO FIGURE OUT HOW TO DISPLAY 
% contour();

