clear all
clc

addpath(genpath('functions'))
load('extractedData/data');
labels={'PD','FD','AD'};
tresh=3;

vec2check={'absoluteDuration','totalSearchDuration','totalClicST','totalClicT'};

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
meanClicST=mean(clicST,2);
totalClicSD=dataCell2dataMat(cellfun(@(x) getClic(x,'totalSD'),{data.sound},'UniformOutput',false));
totalClicSTSD=dataCell2dataMat(cellfun(@(x) getClic(x,'totalSD'),{data.soundST},'UniformOutput',false));


outliers=[];

for jj=1:length(vec2check)
    for ii=1:3
        eval(['outliersTmp=getOutliers(' vec2check{jj} '(xp==' num2str(ii) '),' num2str(tresh) ');']);
        
        if ~isempty(outliersTmp)
            
            switch ii    
                case 1
                    outliers=[outliers outliersTmp];
                    indTmp=outliersTmp;
                    eval(['valTmp=' vec2check{jj} '(outliersTmp);'])
                case 2
                    outliers=[outliers 20+outliersTmp];
                    indTmp=20+outliersTmp;
                    eval(['valTmp=' vec2check{jj} '(20+outliersTmp);'])
                case 3
                    outliers=[outliers 40+outliersTmp];
                    indTmp=40+outliersTmp;
                    eval(['valTmp=' vec2check{jj} '(40+outliersTmp);'])
            end
            
            disp([num2str(length(indTmp)) ' Outliers detected ('  num2str(indTmp(:)') ') with ' vec2check{jj} ' - for xp ' labels{ii}])
            disp(['values = ' num2str(valTmp(:)')])
            
        end
    end
end

outliers=unique(outliers);
save('extractedData/outliers','outliers')

%% rm outliers

data(outliers)=[];
xp=[data.xp];

searchDuration=dataCell2dataMat({data.searchDuration});
totalSearchDuration=sum(searchDuration,2);
absoluteDuration=dataCell2dataMat({data.xpDuration});

clic=dataCell2dataMat(cellfun(@(x) getClic(x,'all'),{data.sound},'UniformOutput',false));
clicST=dataCell2dataMat(cellfun(@(x) getClic(x,'all'),{data.soundST},'UniformOutput',false));
clicSD=dataCell2dataMat(cellfun(@(x) getClic(x,'SD'),{data.sound},'UniformOutput',false));
clicSTSD=dataCell2dataMat(cellfun(@(x) getClic(x,'SD'),{data.soundST},'UniformOutput',false));

maxClicST=max(clicST,[],2);
totalClic=sum(clic,2);
totalClicST=sum(clicST,2);
totalClicSD=dataCell2dataMat(cellfun(@(x) getClic(x,'totalSD'),{data.sound},'UniformOutput',false));
totalClicSTSD=dataCell2dataMat(cellfun(@(x) getClic(x,'totalSD'),{data.soundST},'UniformOutput',false));


%% absolute durations search durations

figure(1)
subplot 131
boxplot(absoluteDuration,'whisker',3)
subplot 132
boxplot(totalSearchDuration,xp,'whisker',3)
subplot 133
boxplot(maxClicST,xp,'whisker',3)
disp('')

%% clic
figure(2)
subplot 221
boxplot(sum(totalClic,2),xp,'whisker',3)
title('clic')
subplot 222
boxplot(sum(totalClicST,2),xp,'whisker',3)
title('clicST')
subplot 223
boxplot(sum(totalClicSD,2),xp,'whisker',3)
title('clicSD')
subplot 224
boxplot(sum(totalClicSTSD,2),xp,'whisker',3)
title('clicSTSD')



