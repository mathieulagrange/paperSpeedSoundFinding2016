clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INDICATION VARIABLE

% Total : Donnees valable pour l'ensemble des sequences du sujet
% All : Donnees valable pour l'ensemble des sujets
% NbrTotal : somme sur l'ensemble des sequences
% NbrAll : somme sur l'ensemble des sujets
% SD : sans repetition
% SC : sans target sound

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('./../analyse_urban/functions'));
json.startup

dataPath='data_test/';

listing = dir([dataPath '*json']);

for mm = 1:length(listing)
    
    navigation =  json.read([dataPath listing(mm).name]);
    
    timeDebut = round(navigation{end}{end}.timeDebut/1000);
    ind_ = strfind(listing(mm).name,'_');
    timeFin = str2double(listing(mm).name(ind_(end)+1:end-5));
    
    data(mm).xpDuration = timeFin-timeDebut;
    data(mm).xp = str2double(listing(mm).name(ind_(1)+1));
    
    for ii = 1:length(navigation)
        xx=1;
        yy=1;
        zz=1;
        
        %% searchTime
        time=strsplit(navigation{ii}{end}.time,':');
        data(mm).searchDuration(ii)= str2double(time{1})*60 + str2double(time{2});
        
        for jj =1:length(navigation{ii})-1
            
            if ~isempty(strfind(navigation{ii}{jj}.oggFile,'pause'));
                
                data(mm).pause{ii}{xx,1}=navigation{ii}{jj}.oggFile;
                data(mm).pause{ii}{xx,2}=navigation{ii}{jj}.time;
                
                xx=xx+1;
                
            elseif ~isempty(strfind(navigation{ii}{jj}.oggFile,'target_sound'));
                
                ind=strfind(navigation{ii}{jj}.oggFile,'/');
                targetName=navigation{ii}{jj}.oggFile(ind+1:end);
                data(mm).sound{ii}{zz,1}=['tragetSnd_' targetName];
                data(mm).sound{ii}{zz,2}=navigation{ii}{jj}.time;
                
                zz=zz+1;
                
            else
                
                ind=strfind(navigation{ii}{jj}.oggFile,'/');
                
                data(mm).soundST{ii}{yy,1}=navigation{ii}{jj}.oggFile(ind+1:end);
                data(mm).soundST{ii}{yy,2}=navigation{ii}{jj}.time;
                
                data(mm).sound{ii}{zz,1}=navigation{ii}{jj}.oggFile(ind+1:end);
                data(mm).sound{ii}{zz,2}=navigation{ii}{jj}.time;
                
                yy=yy+1;
                zz=zz+1;
                
            end
            
        end
        data(mm).sound{ii}(:,3)=mat2cell(strcmp(targetName,data(mm).sound{ii}(:,1)),ones(size(data(mm).sound{ii},1),1),1);
        data(mm).soundST{ii}(:,3)=mat2cell(strcmp(targetName,data(mm).soundST{ii}(:,1)),ones(size(data(mm).soundST{ii},1),1),1);
        disp('')
        
    end
    
    disp('')
    
end

save('extractedData/data','data');

