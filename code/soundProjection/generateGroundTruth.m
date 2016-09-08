function generateGroundTruth(type, targetLevel)

if ~exist('type', 'var'), type = 'urban'; end
if ~exist('targetLevel', 'var'), targetLevel = 2; end

a=loadjson(['../interface/json_csv/typologie_' type '.json']);

[wavFile, ~, ~, classNames] = parseTree(a, {}, 1, 1, {}, targetLevel);

gt = cell2mat(wavFile(:,2))';
classNames
save (['../getFeatures/data/groundtruth_' type], 'wavFile', 'classNames');


function [gt, id, level, names, targetLevel] = parseTree(tree, gt, id, level, names, targetLevel)

if ~tree.last
    for k=1:length(tree.children)
        [gt, id, ~, names, targetLevel] = parseTree(tree.children{k}, gt, id, level+1, names, targetLevel);
    end
else
    for k=1:length(tree.children)
        [~, name] = fileparts(tree.children{k}.oggFile);
        gt{end+1, 1} = name;
        gt{end, 2} = id;
    end
end

if level==targetLevel
    id=id+1;
    names{end+1} = tree.name;
end