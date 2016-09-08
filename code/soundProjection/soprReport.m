function config = soprReport(config)                             
% soprReport REPORTING of the expLanes experiment soundProjection
%    config = soprInitReport(config)                             
%       config : expLanes configuration state                    
                                                                 
% Copyright: Mathieu Lagrange                                    
% Date: 12-May-2016                                              
                                                                 
if nargin==0, soundProjection('report', 'rcv'); return; end        
                                                                 
                                

config = expExpose(config, 't', 'obs', [2 5], 'mask', {1 1 [1 2 3 4] 1 9 6 1}); 

config = expExpose(config, 't', 'obs', [2 5], 'mask', {2 1 [1 2 3 4] 1 9 6 1}); 

config = expExpose(config, 'p', 'obs', 2, 'mask', {1, 4, 1, 0, 5, 0}, 'expand', 'neurons'); 