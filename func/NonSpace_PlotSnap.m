function NonSpace_PlotSnap(time,mag,lon,lat,R,T0,T1,Result,PlotDir,IsSave)
in=Result.In;
ht=Result.ht;
hs=Result.hs;
dark=[0.18 0.20 0.22];

% ======================== Background Snapshots ========================
gx=linspace(min(R(:,1)),max(R(:,1)),160);
gy=linspace(min(R(:,2)),max(R(:,2)),160);
[xx,yy]=meshgrid(gx,gy);
inside=inpolygon(xx,yy,R(:,1),R(:,2));
tSnap=T0+(T1-T0)*[0 .05 .1 .2 .3 .4 .5 .6 .7 .8 .9 1]; % Select the day you want to show
dt=tSnap(:)-time(in).';
w=exp(-0.5*(dt./ht.').^2)./(sqrt(2*pi)*ht.').*Result.Weights.';
snap=NaN(numel(xx),length(tSnap));
for i=1:300:numel(xx)
    j=i:min(i+299,numel(xx));
    r2=((xx(j).'-lon(in).')*Result.Ratio).^2+(yy(j).'-lat(in).').^2;
    Zs=exp(-0.5*r2./hs.'.^2)./(2*pi*hs.'.^2);
    snap(j,:)=Zs*w.';
end
snap(~inside(:),:)=NaN;
field=log10(max(snap,1e-10));
field(~inside(:),:)=NaN;
top=max(field(:),[],'omitnan');

fig=figure('Color','w','Visible','on');
tl=tiledlayout('flow','TileSpacing','compact','Padding','compact');
% tl=tiledlayout(2,3,'TileSpacing','compact','Padding','compact');
xlabel(tl,'Longitude','FontSize',18,'fontname','Times New Roman');
ylabel(tl,'Latitude','FontSize',18,'fontname','Times New Roman');
edge=[R;R(1,:)];
for k=1:length(tSnap)
    ax=nexttile;
    z=reshape(field(:,k),size(xx));
    h=imagesc(gx,gy,z);
    h.AlphaData=isfinite(z);
    set(ax,'YDir','normal','Color',[0.97 0.97 0.97]);
    hold on; 
    plot(edge(:,1),edge(:,2),'Color',dark,'LineWidth',0.9);
    axis tight; 
    daspect([1/Result.Ratio 1 1]);
    clim([top-4 top]);
    title(sprintf('[Day]-%.0f',tSnap(k)));
    Fun_Decorat;
    ax=gca;ax.FontSize=14;
    NonSpace_SetTickNumber(gca,3);
    yticklabels([]);
    xticklabels([]);
end
colormap(slanCM('bwr',20)); 
% colormap(flip(slanCM('rdbu',20))); 
cb=colorbar; 
cb.Layout.Tile='east';
cb.Label.String='Background Rate';
cb.FontSize=18;
cb.Ticks=-5:1:3;
set(gcf,'Position',[0 0 1200 805]);
if IsSave
    exportgraphics(fig,fullfile(PlotDir,'Fig-2.png'),'Resolution',300);
end
% close(fig);
