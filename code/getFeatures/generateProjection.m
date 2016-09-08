function generateProjection(type, method, data, distance)

if nargin==0, generateProjection('music', {'mds'}); return; end
if ~exist('type', 'var'), type = 'music'; end
if ~exist('method', 'var'), method = {'mds'}; end
if ~exist('features', 'var'), features = 'mfcc'; end
if ~exist('distance', 'var'), distance = 'euclidean'; end

rng(0)

%% path
addpath(genpath('functions'));
dataPath='data/';
soundPath = ['sound_' type '/'];
outputPath='./../interface/json_csv/';

%% get file informations

load ([dataPath 'groundtruth_' type]);
groundTruth = cell2mat(wavFile(:,2));
fileNames = wavFile(:,1);

if exist(['data_' type '.mat'], 'file')
    load(['data_' type]);
else
    %% compute features
    data=[];
    for k=1:length(fileNames)
        
        [a, fs] = audioread([soundPath fileNames{k} '.wav']);
        a = a(:, 1);
        
        % features
        switch features
            case 'spectrum'
                s = log10(abs(spectrogram(a, 2048)));
            case 'mfcc'
                s = mfcc(a);
        end
        % remove bad frames
        s(:, isinf(mean(s)) | isnan(mean(s))) = [];
        % perform average
        data(k, :) = mean(s, 2);
    end
    data(isnan(data)) = 0;
    data(isinf(data)) = 0;
    
    save(['data_' type '.mat'], 'data');
end

d = squareform(pdist(data,distance));
rm = rankingMetrics(d, groundTruth);
map1 = rm.meanAveragePrecision;
prec1 = rm.precisionAtRank;


%% dimensionality reduction
for k=1:length(method)
    switch method{k}
        case 'mds'           
            vd = squareform(d);
            vd=vd./max(vd);
            th=.16;
            vd(vd<th)=vd(vd<th)+th;
            [p, stress] = mdscale(vd, 2);
            p = (p-repmat(min(p), length(fileNames), 1))./repmat(max(p)-min(p), length(fileNames), 1);
                       
        case 'pca'
            [~, p] = princomp(data');
            p = p(1:2, :)';
        case 'som'  
            som1=8;
            som2=8;
            net = selforgmap([som1 som2]);
            net.trainParam.showWindow=0;
            net = train(net, data');
            pos = gridtop(som1, som2);
            y = net(data');
            for m=1:size(data, 1)
                p(m, :) = pos(:, find(y(:, m)))+.8*rand(2, 1);
            end
        otherwise
            error('not done')
    end
    
    d2 = squareform(pdist(p));
    rm = rankingMetrics(d2, groundTruth);
    
    map2 = rm.meanAveragePrecision;
    prec2 = rm.precisionAtRank;
    fprintf('Feature type: %s, distance: %s projection: %s \n',features,distance,method{k});
    fprintf('Results: %f (map), %f (map of projection), %f (pa5), %f (pa5 of projection)\n', map1, map2, prec1, prec2);
    
    p=p-min(p(:));
    p=p/max(p(:));
    %% store    
    result=cell(length(fileNames)+1,3);
    result{1,1}='x';
    result{1,2}='y';
    result{1,3}='oggFile';
    result(2:end,1)=num2cell(p(:,1));
    result(2:end,2)=num2cell(p(:,2));
    result(2:end,3)=fileNames;
    
    for ii=2:length(fileNames)+1
        result{ii,3}=[soundPath [result{ii,3} '.ogg']];
    end
    figure(k)
    scatter(p(:, 1), p(:, 2), 20, groundTruth, 'filled');
    save([dataPath 'pos_' features '_' distance '_' method{k} '.mat'],'result');
    cell2csv([outputPath 'pos_' type '.csv'], result);
end
