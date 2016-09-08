clear all
clc


addpath(genpath('functions'))

labels={'AD','FSD','PSD'};
markersize_1=10;
markersize_2=6;
linewidth_1=3;
linewidth_2=1.8;
linewidthFig=1.75;
fontsize=10;

colormap(parula(10))
cmap = colormap;
cmap1=1;
cmap2=6;
cmap3=8;

%% getData

load('extractedData/data');
load('extractedData/outliers')

data(outliers)=[];

xp=[data.xp];

searchDuration=dataCell2dataMat({data.searchDuration});
totalSearchDuration=sum(searchDuration,2);
absoluteDuration=dataCell2dataMat({data.xpDuration});

clic=dataCell2dataMat(cellfun(@(x) getClic(x,'all'),{data.sound},'UniformOutput',false));
clicST=dataCell2dataMat(cellfun(@(x) getClic(x,'all'),{data.soundST},'UniformOutput',false));
clicSD=dataCell2dataMat(cellfun(@(x) getClic(x,'SD'),{data.sound},'UniformOutput',false));
clicSTSD=dataCell2dataMat(cellfun(@(x) getClic(x,'SD'),{data.soundST},'UniformOutput',false));

clicT=dataCell2dataMat(cellfun(@(x) getClic(x,'T'),{data.soundST},'UniformOutput',false));

totalClic=sum(clic,2);
totalClicT=max(clicT,[],2);
totalClicST=sum(clicST,2);
totalClicSD=dataCell2dataMat(cellfun(@(x) getClic(x,'totalSD'),{data.sound},'UniformOutput',false));
totalClicSTSD=dataCell2dataMat(cellfun(@(x) getClic(x,'totalSD'),{data.soundST},'UniformOutput',false));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)
subplot 311
errorbar((1:3),[mean(totalSearchDuration(xp==3,:)) mean(totalSearchDuration(xp==2,:)) mean(totalSearchDuration(xp==1,:))], ...
    [std(totalSearchDuration(xp==3,:))  std(totalSearchDuration(xp==2,:)) std(totalSearchDuration(xp==1,:))],'d','markersize',markersize_1,'linewidth',linewidth_1)
set(gca,'xtick',1:3,'xticklabel',labels,'box','off','ytick',200:200:1400,'linewidth',linewidthFig,'fontsize',fontsize)
title('a')
ylabel('Duration (sec)')
ylim([190 1410])

subplot 312
errorbar((1:3),[mean(totalClicST(xp==3,:)) mean(totalClicST(xp==2,:)) mean(totalClicST(xp==1,:))], ...
    [std(totalClicST(xp==3,:)) std(totalClicST(xp==2,:)) std(totalClicST(xp==1,:))],'d','markersize',markersize_1,'linewidth',linewidth_1)
set(gca,'xtick',1:3,'xticklabel',labels,'box','off','ytick',200:100:700,'linewidth',linewidthFig,'fontsize',fontsize)
ylim([195 705])
ylabel('Heard sounds')
title('b')

subplot 313
errorbar((1:3),[mean(totalClicSTSD(xp==3))  mean(totalClicSTSD(xp==2)) mean(totalClicSTSD(xp==1))], ...
    [std(totalClicSTSD(xp==3)) std(totalClicSTSD(xp==2)) std(totalClicSTSD(xp==1))],'d','markersize',markersize_1,'linewidth',linewidth_1)
set(gca,'xtick',1:3,'xticklabel',labels,'box','off','ytick',100:10:150,'linewidth',linewidthFig,'fontsize',fontsize)
title('c')
ylabel('Unique heard sounds')
ylim([105 155])

xa=1:13;
xb=1:0.1:13;
indfit=1;

y1=mean(searchDuration(xp==1,:),1);y2=mean(searchDuration(xp==2,:),1);y3=mean(searchDuration(xp==3,:),1);

p1=polyfit(xa,y1,indfit); f1=polyval(p1,xb);
p2=polyfit(xa,y2,indfit); f2=polyval(p2,xb);
p3=polyfit(xa,y3,indfit); f3=polyval(p3,xb);

figure(2)
subplot 311
plot(xa,y3,'d','markersize',markersize_2,'linewidth',linewidth_2,'color',cmap(cmap3,:))
hold on
plot(xa,y2,'o','markersize',markersize_2,'linewidth',linewidth_2,'color',cmap(cmap2,:))
plot(xa,y1,'*','markersize',markersize_2,'color',cmap(cmap1,:))

plot(xb,f3,'--','markersize',markersize_2,'linewidth',linewidth_2,'color',cmap(cmap3,:))
plot(xb,f2,'-','markersize',markersize_2,'linewidth',linewidth_2,'color',cmap(cmap2,:))
plot(xb,f1,'-','markersize',markersize_2,'linewidth',linewidth_2,'color',cmap(cmap1,:))
hold off
disp('')
set(gca,'xtick',1:13,'ytick',0:25:150,'box','off','linewidth',linewidthFig,'fontsize',fontsize)
ylabel('Duration (sec)')
ylim([0 155])
xlim([0 14])
legend(labels); legend boxoff;
title('a')


xa=1:13;
xb=1:0.1:13;
indfit=1;

y1=mean(clicST(xp==1,:),1);y2=mean(clicST(xp==2,:),1);y3=mean(clicST(xp==3,:),1);

p1=polyfit(xa,y1,indfit); f1=polyval(p1,xb);
p2=polyfit(xa,y2,indfit); f2=polyval(p2,xb);
p3=polyfit(xa,y3,indfit); f3=polyval(p3,xb);

subplot 312
plot(xa,y3,'d','markersize',markersize_2,'linewidth',linewidth_2,'color',cmap(cmap3,:))
hold on
plot(xa,y2,'o','markersize',markersize_2,'linewidth',linewidth_2,'color',cmap(cmap2,:))
plot(xa,y1,'*','markersize',markersize_2,'color',cmap(cmap1,:))

plot(xb,f3,'--','markersize',markersize_2,'linewidth',linewidth_2,'color',cmap(cmap3,:))
plot(xb,f2,'-','markersize',markersize_2,'linewidth',linewidth_2,'color',cmap(cmap2,:))
plot(xb,f1,'-','markersize',markersize_2,'linewidth',linewidth_2,'color',cmap(cmap1,:))


hold off
set(gca,'xtick',1:13,'ytick',0:20:80,'box','off','linewidth',linewidthFig,'fontsize',fontsize)
ylim([0 85])
xlim([0 14])
ylabel('Heard sounds')
title('b')

xa=1:13;
xb=1:0.1:13;
indfit=1;

y1=mean(clicSTSD(xp==1,:),1);y2=mean(clicSTSD(xp==2,:),1);y3=mean(clicSTSD(xp==3,:),1);

p1=polyfit(xa,y1,indfit); f1=polyval(p1,xb);
p2=polyfit(xa,y2,indfit); f2=polyval(p2,xb);
p3=polyfit(xa,y3,indfit); f3=polyval(p3,xb);


subplot 313
plot(xa,y3,'d','markersize',markersize_2,'linewidth',linewidth_2,'color',cmap(cmap3,:))
hold on
plot(xa,y2,'o','markersize',markersize_2,'linewidth',linewidth_2,'color',cmap(cmap2,:))
plot(xa,y1,'*','markersize',markersize_2,'color',cmap(cmap1,:))

plot(xb,f3,'--','markersize',markersize_2,'linewidth',linewidth_2,'color',cmap(cmap3,:))
plot(xb,f2,'-','markersize',markersize_2,'linewidth',linewidth_2,'color',cmap(cmap2,:))
plot(xb,f1,'-','markersize',markersize_2,'linewidth',linewidth_2,'color',cmap(cmap1,:))

hold off
set(gca,'xtick',1:13,'ytick',0:20:60,'box','off','linewidth',linewidthFig,'fontsize',fontsize)
ylim([0 65])
xlim([0 14])
xlabel('search index')
ylabel('Unique heard sounds WD')
title('c')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% stat totalClicST totalClicSTSD
disp('Anova totalClicSTSD')
disp(' ')
[p,tb]=anova1(totalClicSTSD,xp,'off')
disp(' ')

disp('Anova totalClicST')
disp(' ')
[p,tb]=anova1(totalClicST,xp,'off')
disp(' ')

%% post hoc stats totalClicST totalClicSTSD
disp('ttest2')
[h,p]=ttest2(totalClicST(xp==1,:),totalClicST(xp==2,:));
disp(['totalClicST PD-FD, p=' num2str(p)])
[h,p]=ttest2(totalClicST(xp==1,:),totalClicST(xp==3,:));
disp(['totalClicST PD-AD, p=' num2str(p)])
[h,p]=ttest2(totalClicST(xp==2,:),totalClicST(xp==3,:));
disp(['totalClicST FD-AD, p=' num2str(p)])
disp(' ')
disp('ttest2')
[h,p]=ttest2(totalClicSTSD(xp==1,:),totalClicSTSD(xp==2,:));
disp(['totalClicSTSD PD-FD, p=' num2str(p)])
[h,p]=ttest2(totalClicSTSD(xp==1,:),totalClicSTSD(xp==3,:));
disp(['totalClicSTSD PD-AD, p=' num2str(p)])
[h,p]=ttest2(totalClicSTSD(xp==2,:),totalClicSTSD(xp==3,:));
disp(['totalClicSTSD FD-AD, p=' num2str(p)])

%% stat absoluteDuration searchDuration
disp('Anova absolute time')
disp(' ')
[p,tb]=anova1(absoluteDuration,xp,'off')
disp(' ')

disp('search Duration time')
disp(' ')
[p,tb]=anova1(sum(totalSearchDuration,2),xp,'off')
disp(' ')

%% post hoc stats absoluteDuration searchDuration
disp('ttest2')
[h,p]=ttest2(totalSearchDuration(xp==1,:),totalSearchDuration(xp==2,:));
disp(['search Duration PD-FD, p=' num2str(p)])
[h,p]=ttest2(totalSearchDuration(xp==1,:),totalSearchDuration(xp==3,:));
disp(['search Duration PD-AD, p=' num2str(p)])
[h,p]=ttest2(totalSearchDuration(xp==2,:),totalSearchDuration(xp==3,:));
disp(['search Duration FD-AD, p=' num2str(p)])
disp(' ')
disp('ttest2')
[h,p]=ttest2(absoluteDuration(xp==1,:),absoluteDuration(xp==2,:));
disp(['absolute Duration PD-FD, p=' num2str(p)])
[h,p]=ttest2(absoluteDuration(xp==1,:),absoluteDuration(xp==3,:));
disp(['absolute Duration PD-AD, p=' num2str(p)])
[h,p]=ttest2(absoluteDuration(xp==2,:),absoluteDuration(xp==3,:));
disp(['absolute Duration FD-AD, p=' num2str(p)])

figOpt.fontsize=fontsize;
figOpt.height=40;
figOpt.width=20;

printFigures([1 2],['~/papers/paperSpeedSoundFinding2016/gfx/' mfilename],figOpt)