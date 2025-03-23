function C=cost_function5b(GSF,nTarget,exponent)
%C=cost_function5(GSF,nTarget,exponent) - cost function to locate sources in cortex model
%
%  C: cost function of sensor locations
%
%  GSF: gain matrix for all filters (nlocations X nfilters)
%  nTarget: number of target filters
%  exponent: exponent to apply before adding [default:2]
%

if nargin<1; error('!'); end
if nargin<2||isempty(nTarget); nTarget=1; end
if nargin<3||isempty(exponent); exponent=2; end

C=sum(abs(GSF(:,nTarget+1:end)).^exponent,2); 
bias=sum(abs(GSF).^exponent,2);

C=bsxfun(@times,C,1./bias);
