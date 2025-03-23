function C=cost_function5(GSF,bias,exponent)
%C=cost_function5(GSF,bias) - cost function to locate sources in cortex model
%
%  C: cost function of sensor locations
%
%  GSF: source to filter gain matrix (nlocations X nfilters)
%  bias: bias to remove (nlocations X 1)
%  exponent: exponent to apply before adding [default:2]
%
% calculate bias as: bias=sum(sum(gain.^2,2),3);

if nargin<1; error('!'); end
if nargin<2; bias=[]; end
if nargin<3; exponent=2; end

C=sum(abs(GSF).^exponent,2); % square, sum over filters

if ~isempty(bias)
    C=bsxfun(@times,C,1./bias);
end
