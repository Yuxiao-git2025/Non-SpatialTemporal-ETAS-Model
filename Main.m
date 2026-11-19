%%                              || Data loading ||
clc;
PATH='C:\MATLAB\MyStatisticFunc\NonSpaceETAS\'; % Main-PATH
[time,mag,depth,lon,lat,Mmin,R,T0,T1]=NonSpace_LoadingData('Input\JMA500.mat');


%%                             || Loops for params ||
% Params Order: [A,alpha,c,p,D,q,gamma]
param0=[0.04   1.8   0.1   1.2   0.015   2.2   0.8];
[Result]=NonSpace_ETASModel(time,mag,lon,lat,Mmin,R,T0,T1,param0);


%%                            || Plotting and Save ||
Dirplot=[PATH,'plot'];
Diroutput=[PATH,'Output'];
IsSave=false;

% 1. Save-Picture
% NonSpace_PlotLambda(time,mag,lon,lat,R,T0,T1,Result,Dirplot,IsSave);
NonSpace_PlotSnap(time,mag,lon,lat,R,T0,T1,Result,Dirplot,IsSave);
% NonSpace_PlotResidual(time,mag,lon,lat,R,T0,T1,Result,Dirplot,IsSave);

% 2. Save-Data
% save(fullfile(Diroutput,'Results.mat'), 'Result','time','mag','depth','lon','lat','Mmin','R','T0','T1','param0');
