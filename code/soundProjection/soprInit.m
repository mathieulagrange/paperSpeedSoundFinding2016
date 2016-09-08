function [config, store] = soprInit(config)                         
% soprInit INITIALIZATION of the expLanes experiment soundProjection
%    [config, store] = soprInit(config)                             
%      - config : expLanes configuration state                      
%      -- store  : processing data to be saved for the other steps  
                                                                    
% Copyright: Mathieu Lagrange                                       
% Date: 12-May-2016                                                 
                                                                    
if nargin==0, soundProjection(); return; else store=[];  end        
