function C=cost_function2(source,sensor,F,bias_flag)
%C=cost_function2(source,sensor,F,bias_flag) - cost function to locate sources in disc
%
%  C: cost function of source positions
%
%  source: source positions (npositions X 2 X nsources)
%  sensor: sensor positions (nsensors X 2)
%  F: filters (nsensors X nfilters)
%  bias_flag: if 1, apply bias [default: 1]
%
% This version handles multiple sources

if nargin<3; error('!'); end
if nargin<4 || isempty(bias_flag); bias_flag=1; end 

for iSource=1:size(source,3)    
    GSS(:,:,iSource)=source2sensor(source(:,:,iSource),sensor);
    GSF(:,:,iSource)=source2filter(GSS(:,:,iSource),F);
end
GSF=sum(GSF,3); % sum gain over sources
C=sum(GSF.^2,2); % square, sum over filters

if bias_flag
    bias=sum(sum(GSS.^2,2),3);
    C=bsxfun(@times,C,1./bias);
end


mask=sum(source(:,:,1).^2,2);
C(mask>1,:)=inf;
