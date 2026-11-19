function NonSpace_PlotResidual(time,mag,lon,lat,R,T0,T1,Result,PlotDir,IsSave)
% ======================== Residual Process ========================
% Note that the fitted curve does not necessarily have to match the observations
% exactly. This discrepancy arises from the proportion of background events within
% the window: due to the choice of the spacetime window, some background events will
% inevitably be lost. When we perform the MLE calculation, we also use these actual
% background events, whereas when calculating the background probability, we use the
% number of background events that have not undergone Gaussian weighting. You need to
% distinguish between the two
in=Result.In;
ht=Result.ht;
hs=Result.hs;
dark=[0.18 0.20 0.22];
trig=[0 .2 .9];

n=length(in);
tObs=[T0;time(in);T1];
count=[0;(1:n).';n];
tFit=[0;Result.TransN;Result.IntEnd];
% Show the background kernel mass outside the window at the endpoint.
BackOutside=sum(Result.Weights)-Result.BackEnd; % Miss-events
fig=figure('Color','w','Visible','on','Position',[0 0 920 420]);
tiledlayout(1,2,'TileSpacing','compact','Padding','compact');
nexttile;
stairs(tObs,count,'Color',dark,'LineWidth',1.4);
hold on;
plot(tObs,tFit,'Color',trig,'LineWidth',1.6);
% plot(tObs,[0;cumsum(Result.Weights)+Result.TrigInt;sum(Result.Weights)+Result.TrigEnd],'Color', ...
%     base,'LineWidth',1.6); % not necessary, because it is always equal
xlabel('Relative time (days)'); ylabel('Cum.Count');
legend('Observed','Fitted', ...
    'Location','southeast'); box on;
Fun_defaultAxes;ax=gca;ax.FontSize=16;

nexttile;
limit=max(n,Result.IntEnd);
plot([0 limit],[0 limit],'--','Color',[0.50 0.50 0.50]); hold on;
stairs(tFit,count,'Color',trig,'LineWidth',1.6);
% stairs([0;cumsum(Result.Weights)+Result.TrigInt;sum(Result.Weights)+Result.TrigEnd],count,'Color', ...
%     base,'LineWidth',1.6);
xlim([0 limit]); ylim([0 limit]); box on;
xlabel('Transformed Time'); ylabel('Cum.Count');
Fun_defaultAxes;ax=gca;ax.FontSize=16;
set(gcf,'Position',[0 0 840 505])
if IsSave
    exportgraphics(fig,fullfile(PlotDir,'Fig-3.png'),'Resolution',300);
end
% close(fig);
end
