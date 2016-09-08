clear all
clc

addpath(genpath('../analyse_urban/functions'))

labels={'AD','FSD','PSD'};
markersize_1=10;
markersize_2=6;
linewidth_1=3;
linewidth_2=1.8;
linewidthFig=1.75;
fontsize=10;

load('data/urban.mat');
load('data/music.mat');

figure(1)
subplot 321
errorbar((1:3),stats_totalSearchDuration_urban(1,:), ...
    stats_totalSearchDuration_urban(2,:),'d','markersize',markersize_1,'linewidth',linewidth_1)
set(gca,'xtick',1:3,'xticklabel',labels,'box','off','ytick',200:200:1200,'linewidth',linewidthFig,'fontsize',fontsize)
title('a')
ylabel('Duration (sec)')
ylim([100 1300])

subplot 323
errorbar((1:3),stats_totalClicST_urban(1,:), ...
    stats_totalClicST_urban(2,:),'d','markersize',markersize_1,'linewidth',linewidth_1)
set(gca,'xtick',1:3,'xticklabel',labels,'box','off','ytick',200:100:800,'linewidth',linewidthFig,'fontsize',fontsize)
ylabel('Heard sounds')
title('b')
ylim([150 850])

subplot 325
errorbar((1:3),stats_totalClicSTSD_urban(1,:), ...
    stats_totalClicSTSD_urban(2,:),'d','markersize',markersize_1,'linewidth',linewidth_1)
set(gca,'xtick',1:3,'xticklabel',labels,'box','off','ytick',100:10:150,'linewidth',linewidthFig,'fontsize',fontsize)
title('c')
ylabel('Unique heard sounds')
ylim([95 155])

subplot 322
errorbar((1:3),stats_totalSearchDuration_music(1,:), ...
    stats_totalSearchDuration_music(2,:),'d','markersize',markersize_1,'linewidth',linewidth_1)
set(gca,'xtick',1:3,'xticklabel',labels,'box','off','ytick',200:200:1200,'linewidth',linewidthFig,'fontsize',fontsize)
title('d')
ylabel('Duration (sec)')
ylim([100 1300])

subplot 324
errorbar((1:3),stats_totalClicST_music(1,:), ...
    stats_totalClicST_music(2,:),'d','markersize',markersize_1,'linewidth',linewidth_1)
set(gca,'xtick',1:3,'xticklabel',labels,'box','off','ytick',200:100:800,'linewidth',linewidthFig,'fontsize',fontsize)
ylabel('Heard sounds')
title('e')
ylim([150 850])

subplot 326
errorbar((1:3),stats_totalClicSTSD_music(1,:), ...
    stats_totalClicSTSD_music(2,:),'d','markersize',markersize_1,'linewidth',linewidth_1)
set(gca,'xtick',1:3,'xticklabel',labels,'box','off','ytick',100:10:150,'linewidth',linewidthFig,'fontsize',fontsize)
title('f')
ylabel('Unique heard sounds')
ylim([95 155])
disp('')

%%

figOpt.fontsize=fontsize;
figOpt.height=40;
figOpt.width=20;

printFigures(1,'~/papers/paperSpeedSoundFinding2016/gfx/urbanMusic',figOpt)