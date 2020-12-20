%Main Script%

%Data Load-In
file1 = 'tests/Drif correct actin final 25255-50255.csv'; %enter file name at 'fileName'
file2 = 'tests/Drif correct cav1 and grouped final 6500-25255.csv'; %enter file name at 'fileName'
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

xmin = 0;

    if (min(x1) < min(x2))
            xmin = min(x1);
    else
            xmin = min(x2);
    end   
    
ymin = 0; 

    if (min(y1) < min(y2))
            ymin = min(y1);
    else
            ymin = min(y2);
    end 
    
xmax = 0;

    if (max(x1) > max(x2))
            xmax = max(x1);
    else
            xmax = max(x2);
    end 
    
ymax = 0;

    if (max(y1) > max(y2))
            ymax = max(y1);
    else
            xmax = max(y2);
    end 
    
area = (xmax-xmin)*(ymax-ymin);

%looping

t_incr = 0;
i = 1;

%Edge Correction or nah?

method = ChooseEdgeCorrection();

while(i <= bins)
    
    if (method == 1) %1 is with edge corrections
        biEstimateGFyesEC12(x1, y1, x2, y2, t_incr, last_t, n, n2, i, xmin, ymin, xmax, ymax, area);
        biEstimateGFyesEC21(x1, y1, x2, y2, t_incr, last_t, n, n2, i, xmin, ymin, xmax, ymax, area);
    else %without edge corrections
        biEstimateGFnoEC12(x1, y1, x2, y2, t_incr, i, n, n2, area);
        biEstimateGFnoEC21(x1, y1, x2, y2, t_incr, i, n, n2, area);
    end
    
    i = i + 1;
    t_incr = t_incr + t;
    
end 

%DISPLAY 
contourf(gfl_12);
countourf(gfl_21);
