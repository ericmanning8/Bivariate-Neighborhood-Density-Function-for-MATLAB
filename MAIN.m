%%% Main Script

% load data 
fileName = 'FullStackDriftOvercountCorrectedSieved.xlsx'; % Enter file name here 
data = open(fileName);

x1 = data(:,1);
y1 = data(:,2);
st = 10;
max_step = 1000;
points = length(x1);

% choose method of edge correction
method = ChooseEdgeCorrection();

% perform GFL analysis 
if (method == 1) % NDF with edge corrections 
    bgf12 = biEstimateGFyesEC12(x1, y1, st, max_step, points, points);
	bgf21 = biEstimateGFyesEC21(x1, y1, st, max_step, points, points);
else % without edge corrections 
    bgf12 = biEstimateGFnoEC12(x1, y1, st, max_step, points, points);
	bgf21 = biEstimateGFnoEC21(x1, y1, st, max_step, points, points);
end

% display the NDF vector 
disp('Vectors:');
disp(bgf12(1,:));
disp(bgf21(1,:));

% create a contour plot: needs to be done 
figure(1);