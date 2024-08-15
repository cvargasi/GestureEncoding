function [CSIMS, basedmat] = GesturePaper1_StateSpacePlots( dataMatOL,dataMatCL,varargin)
% [CSIMS] = GesturePaper1_StateSpacePlots( dataMatOL,dataMatCL, dim, perp )
% generate state space plots for Gesture paper 1

if nargin>2
    dim = varargin(1)
else 
    dim = 15
end
if nargin>3
    perplexity = varargin(2)
else 
    perplexity = 100
end

 metric = 'seuclidean' % this can be any metric compatible with pdist
 
for n = 1:numel(dataMatOL)
    
    n
    
[ CSIMSRaw, ~, basedmat{n}] = getCSIMS( vertcat(dataMatOL{n},dataMatCL{n} )+(10^-100) , metric, dim, perplexity);
% rotate to display max variance
[coeff{n}, CSIMS{n}, latent{n}, tsquared{n}, CSexplained{n}] = pca(CSIMSRaw);
clear CSIMSRaw
end
