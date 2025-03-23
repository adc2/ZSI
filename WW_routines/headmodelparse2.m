function [gain3,gain,loc,orient]=headmodelparse(head_model)
%[gain3,gain,loc,orient]=headmodelparse(head_model) - unpack head model
%
%   gain3: full gain matrix (nlocations X nsensors X 3)
%   gain: constrained gain matrix (nlocations X nsensors)
%   loc: dipole locations (nlocations X 3)
%   orient: orentations (nlocations X 3)
%

if nargin<1; error('!'); end

loc=head_model.GridLoc;
orient=head_model.GridOrient;
g=head_model.Gain;
nlocations=size(g,2)/3;
nsensors=size(g,1);
g=g'; % --> (nlocationsX3) X nsensors
g=reshape(g,3,nlocations,nsensors);
g=permute(g,[2,3,1]);
gain3=g;

if ~isempty(orient)
    gain=gain3(:,:,1).*orient(:,1) + gain3(:,:,2).*orient(:,2) + gain3(:,:,3).*orient(:,3);
else
    gain=[];
end



