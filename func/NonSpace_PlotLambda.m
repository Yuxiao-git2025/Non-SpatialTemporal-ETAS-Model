function NonSpace_PlotLambda(time,mag,lon,lat,R,T0,T1,Result,PlotDir,IsSave)
in=Result.In;
ht=Result.ht;
hs=Result.hs;
dark=[0.18 0.20 0.22];

% ======================== Regional Rates ========================
edges=linspace(T0,T1,801).';
tt=(edges(1:end-1)+edges(2:end))/2;
c=Result.paramNew(3); p=Result.paramNew(4);
geom=struct('time',time,'in',in,'T0',T0,'ht',ht,'bMass',Result.BackMass);
[cumRate,cumBack]=NonSpace_CIntLam(edges,geom,Result.Weights,Result.TrigMass,Result.Kapam,c,p);
BackRate=diff(cumBack)./diff(edges);
TotalRate=diff(cumRate)./diff(edges);

fig=figure('Color','w','Visible','on','Position',[0 0 920 570]);
tiledlayout(2,1,'TileSpacing','compact','Padding','compact');
nexttile;
plot(tt,TotalRate,'Color',dark,'LineWidth',1.2); hold on;
plot(tt,BackRate,'Color',[   0.2196    0.7333    0.9882],'LineWidth',1.6);
ylabel('Events per day'); xlim([T0 T1]); box on;
legend('Total rate','Background rate','Location','best');
Fun_defaultAxes;ax=gca;ax.FontSize=16;
nexttile;
scatter(time(in),mag(in),30,Result.Fai,'filled');
clim([0 1]);
colormap(flip(slanCM('bwr',15)));
cb=colorbar;
cb.Label.String='Background Prob';
xlim([T0 T1]); xlabel('Time (day)'); ylabel('Magnitude'); box on;
ylim([min(mag) +inf]);
Fun_defaultAxes;ax=gca;ax.FontSize=16;
if IsSave
    exportgraphics(fig,fullfile(PlotDir,'Fig-1.png'),'Resolution',300);
end
% close(fig);

