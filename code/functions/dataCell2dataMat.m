function [ dataMat ] = dataCell2dataMat( dataCell )

dataMat=zeros(length(dataCell),length(dataCell{1}));

for jj=1:length(dataCell)
    dataMat(jj,:)=dataCell{jj};
end

