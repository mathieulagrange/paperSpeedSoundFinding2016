function [ outliers ] = getOutliers(data,tresh)

outliers=find(data<=(quantile(data,0.25)-tresh*iqr(data)) | data>=(quantile(data,0.75)+tresh*iqr(data)));

outliers=outliers(:)';
end

