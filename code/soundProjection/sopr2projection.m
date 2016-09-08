function [config, store, obs] = sopr2projection(config, setting, data)
% sopr2projection PROJECTION step of the expLanes experiment soundProjection
%    [config, store, obs] = sopr2projection(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: Mathieu Lagrange
% Date: 12-May-2016

% Set behavior for debug mode
if nargin==0, soundProjection('do', 2, 'mask', {0 1 3}); return; else store=[]; obs=[]; end

load ([config.inputPath 'data/groundtruth_' setting.database]);
groundTruth = cell2mat(wavFile(:,2));

switch setting.projection
    case 'id'
        p = data.features;
    case 'pca'
        f = data.features';
        [~, p] = princomp(f);
        p = p(1:2, :)';
    case 'mds'
        vd = pdist(data.features,setting.distance);
        vd=vd./max(vd);
        th=.16;
        vd(vd<th)=vd(vd<th)+th;
        [p, stress] = mdscale(vd, 2);
        %  p = (p-repmat(min(p), length(fileNames), 1))./repmat(max(p)-min(p), length(fileNames), 1);
    case 'som'
        net = selforgmap([setting.neurons setting.neurons]);
        net.trainParam.showWindow=0;
        net = train(net, data.features');
        pos = gridtop(setting.neurons, setting.neurons);
        y = net(data.features');
        for m=1:size(data.features, 1)
            p(m, :) = pos(:, find(y(:, m)))+setting.spread*rand(2, 1);
        end
end


switch setting.database
    case 'urban'
        classNames = {'Traffic', 'Sirens', 'Nature', 'Leisure', 'Construction work', 'Human moves', 'Human Voice'};
    case 'music'
        classNames = {'Brass', 'Percussion', 'Piano', 'Voice', 'String', 'Woodwinds'};
end
for k=1:length(data.groundTruth)
    gt{k} = classNames{groundTruth(k)};
end
h=gscatter(p(:, 1), p(:, 2), gt');
set(h, 'Markersize', 25);
axis off
axis tight
set(gca, 'FontSize', 20)
config = expExpose(config, '', 'save', [setting.database '_' setting.projection]);

h=gscatter(p(:, 1), p(:, 2), gt', 'k', '+x*><vo^');
set(h, 'Markersize', 8);
axis off
config = expExpose(config, '', 'save', [setting.database '_' setting.projection '_bw']);

d = squareform(pdist(p,setting.distance));
obs= rankingMetrics(d, data.groundTruth);
