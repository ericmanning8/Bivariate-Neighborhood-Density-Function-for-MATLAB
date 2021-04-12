%Main Script%

%Data Load-In
file1 = 'tests/actin truncated 4.csv'; %enter file name
file2 = 'tests/cav1 truncated 4.csv'; %enter file name
data1 = readmatrix(file1);
data2 = readmatrix(file2);

%Variable intialization: adjust column indices accordingly for x1,x2,y1,y2
x1 = data1(:,6);
y1 = data1(:,7);
x2 = data2(:,9);
y2 = data2(:,10);
t = 10;
n = length(x1);
n2 = length(x2);
max_step = 1000;

bins = ceil(max_step / t);
    
if ((bins * t) > (max_step + t))
    bins = bins - 1;
end

%Boundary variables 
xmin = min(min(x1), min(x2));
ymin = min(min(y1), min(y2));
xmax = max(max(x1), max(x2));
ymax = max(max(y1), max(y2));
area = (xmax-xmin)*(ymax-ymin);

%Initialize GFL data structures 
gfl_12 = zeros(n + 1, bins + 1);
gfl_21 = zeros(n + 1, bins + 1);

%Looping counters
t_incr = 0;
i = 1;

%Edge Correction?
method = ChooseEdgeCorrection();
method2 = chooseFOR();

wb = waitbar(0, 'Computing Cross-Clustering Function...');
while(i <= bins)
    
    percentDone = (t_incr / max_step);
    waitbar(percentDone, wb);
    
    if (method == 1) %1 is with edge corrections
        if(method2 == 1)
            gfl_12 = biEstimateGFyesEC12(gfl_12, x1, y1, x2, y2, t_incr, (t_incr-t), n, n2, i, 0, ymin, xmax, ymax, area);
        elseif(method2 == 0)
            gfl_21 = biEstimateGFyesEC21(gfl_21, x1, y1, x2, y2, t_incr, (t_incr-t), n, n2, i, 0, ymin, xmax, ymax, area);
        elseif(method2 == -1)
            return;
        end
    elseif (method == 0) %Without edge corrections
        if(method2 == 1)
            gfl_12 = biEstimateGFnoEC12(gfl_12, x1, y1, x2, y2, t_incr, i, n, n2, area);
        elseif(method2 == 0)
            gfl_21 = biEstimateGFnoEC21(gfl_21, x1, y1, x2, y2, t_incr, i, n, n2, area);
        elseif(method2 == -1)
            return;
        end
    elseif (method == -1)
        return;
    end
    
    i = i + 1;
    t_incr = t_incr + t;
    
end 
close(wb);

%Correct so that L(d) = d under CSR

for i = 1:n
    for j = 1:bins
        gfl_12(i, j) = sqrt(gfl_12(i,j) / pi);
    end
end

for i = 1:n2
    for j = 1:bins
        gfl_21(i,j) = sqrt(gfl_21(i,j) / pi);
    end
end

%DISPLAY

%   Initiate matrix with X position, Y position, and L(d) values
    gflTOTAL = zeros(0,0);
    
%   X position is in column 1 of gflTOTAL        
    gflTOTAL(:,1) = x1;
%   Y position is in column 2 of gflTOTAL
    gflTOTAL(:,2) = y1;
        
    %If we are given a specific d value... Input desired d in cmd window!
    
    dchecker = true;
    while dchecker == true
        prompt = "What d-value would you like to use? Please input an integer from d=1 to d=100.";
        
        d = input(prompt);
        
        if d >= 1 && d <= 100
            dchecker = false;
        else
            dchecker = true;
        end
    end
    
    if(method2 == 1)
        gflshadow = gfl_12(:,d);
    else
        gflshadow = gfl_21(:,d);
    end
    
    for i = 1:n
        gflTOTAL(i,3) = gflshadow(i,1);
    end
  
%  scatter3(gflTOTAL(:,1),gflTOTAL(:,2),gflTOTAL(:,3),5);
%  scatter(x1,y1);
    
    [xq,yq] = meshgrid(xmin:1000:xmax, ymin:1000:ymax);
    vq = griddata(gflTOTAL(:,1),gflTOTAL(:,2),gflTOTAL(:,3),xq,yq);
    mesh(xq,yq,vq);
    hold on;
    plot3(gflTOTAL(:,1),gflTOTAL(:,2),gflTOTAL(:,3),'.');
    xlim([xmin xmax]);
    ylim([ymin ymax]);
