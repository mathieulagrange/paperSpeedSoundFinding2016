function [config, store, obs] = sopr1features(config, setting, data)
% sopr1features FEATURES step of the expLanes experiment soundProjection
%    [config, store, obs] = sopr1features(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: Mathieu Lagrange
% Date: 12-May-2016

% Set behavior for debug mode
if nargin==0, soundProjection('do', 1, 'mask', {2}); return; else store=[]; obs=[]; end




%% get file informations
load ([config.inputPath 'data/groundtruth_' setting.database]);
groundTruth = cell2mat(wavFile(:,2));
fileNames = wavFile(:,1);


%% compute features
features=[];
for k=1:length(fileNames)   
    [a, fs] = audioread([config.inputPath 'sound' '_' setting.database '/' fileNames{k} '.wav']);
    a = a(:, 1);
    
    % features
    switch setting.features
        case 'spectrum'
            s = log10(abs(spectrogram(a, 2048)));
        case 'mfcc'
            s = mfcc(a);
    end
    % remove bad frames
    s(:, isinf(mean(s)) | isnan(mean(s))) = [];
    % perform average
    features(k, :) = mean(s, 2);
end
features(isnan(features)) = 0;
features(isinf(features)) = 0;

store.features = features;
store.groundTruth = groundTruth;
store.classNames = classNames;
