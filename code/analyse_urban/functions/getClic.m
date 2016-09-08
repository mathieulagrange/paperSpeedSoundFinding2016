function [ clic ] = getClic(data,type)

switch type
    
    case 'all'
        
        clic=cellfun(@(x) size(x,1),data);
        
    case 'SD'
        
        clic=cellfun(@(x) length(unique(x(:,1))),data);
        
    case 'totalSD'
        xx=1;
        
        for ii=1:length(data)
            for jj=1:size(data{ii},1)
                dataTmp{xx}=data{ii}{jj,1};
                xx=xx+1;
            end
        end
        
        clic=length(unique(dataTmp));
        
    case 'T'
        clic=cellfun(@(x) sum([x{:,3}]),data);
        
    otherwise
        error('wrong input ')
        
end


end

