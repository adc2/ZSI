function [idx,val,C]=find_source(GSF,nTarget,exponent)
%[idx,val,C]=find_source(GSF,nTarget) - find index of source location
%
%   idx: index of source
%   val: value at minimum
%   C: cost function
%
%   GSF: source-to-filter gain for all null filters
%   nTarget: number of target filters [default: 1]
%   exponent: exponent to apply when summing across filters [default: 2]

if nargin<1; error('!'); end
if nargin<2||isempty(nTarget); nTarget=1; end
if nargin<3||isempty(exponent); exponent=2; end

C=cost_function5b(GSF,nTarget,exponent);
[val,idx]=min(C);

