clear all
clc

%% setting

addpath(genpath('functions'))
load('extractedData/data');
labels={'PD','FD','AD'};
tresh=3;
rmOutlier=0;

vec2check={'absoluteDuration','totalSearchDuration','totalClicST','totalClicT'};

%% get data

xp=[data.xp];

nb_1=sum(xp==1);
nb_2=sum(xp==2);
nb_3=sum(xp==3);

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

%% visu

figure(1)
subplot 221
boxplot(absoluteDuration,xp,'whisker',3)
title('absoluteDuration')
subplot 222
boxplot(totalSearchDuration,xp,'whisker',3)
title('totalSearchDuration')
subplot 223
boxplot(totalClicST,xp,'whisker',3)
title('totalSearchDuration')
subplot 224
boxplot(totalClicT,xp,'whisker',3)
title('totalClicT')
disp('')


%% outliers

outliers=[];

for jj=1:length(vec2check)
    for ii=1:3
        eval(['data2look=' vec2check{jj} '(xp==' num2str(ii) ');']);
        outliersTmp=getOutliers(data2look,tresh);
        
        if ~isempty(outliersTmp)
            
            switch ii
                case 1
                    outliers=[outliers outliersTmp];
                    indTmp=outliersTmp;
                    eval(['valTmp=' vec2check{jj} '(outliersTmp);'])
                case 2
                    outliers=[outliers nb_1+outliersTmp];
                    indTmp=nb_1+outliersTmp;
                    eval(['valTmp=' vec2check{jj} '(nb_1+outliersTmp);'])
                case 3
                    outliers=[outliers nb_1+nb_2+outliersTmp];
                    indTmp=nb_1+nb_2+outliersTmp;
                    eval(['valTmp=' vec2check{jj} '(nb_1+nb_2+outliersTmp);'])
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

clicT=dataCell2dataMat(cellfun(@(x) getClic(x,'T'),{data.soundST},'UniformOutput',false));

totalClic=sum(clic,2);
totalClicT=max(clicT,[],2);
totalClicST=sum(clicST,2);
meanClicST=mean(clicST,2);
totalClicSD=dataCell2dataMat(cellfun(@(x) getClic(x,'totalSD'),{data.sound},'UniformOutput',false));
totalClicSTSD=dataCell2dataMat(cellfun(@(x) getClic(x,'totalSD'),{data.soundST},'UniformOutput',false));


figure(2)
subplot 221
boxplot(absoluteDuration,xp,'whisker',3)
title('absoluteDuration')
subplot 222
boxplot(totalSearchDuration,xp,'whisker',3)
title('totalSearchDuration')
subplot 223
boxplot(totalClicST,xp,'whisker',3)
title('totalSearchDuration')
subplot 224
boxplot(totalClicT,xp,'whisker',3)
title('totalClicT')
disp('')



