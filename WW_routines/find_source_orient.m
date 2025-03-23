function [idx,val,orient,cc]=find_source_orient(GLF3D,nTarget)
%[idx,val,orient,cc]=find_source_orient(GLF3D,nTarget) - find index and orientation of source 
%
%   idx: indices of source pair
%   val: value at minimum
%   orient: orientation vector (3 X 1)
%   cc: value at best orientation for all locations
%
%   GLF3D: location-to-filter gain for null filters (nlocations X nfilters X 3)
%   nTarget: number of target components [default: 1]

if nargin<1; error('!'); end
if nargin<2; nTarget=1; end

GLF03D=GLF3D; % keep
GLF3D=GLF03D(:,nTarget+1:end,:);

nfilters=size(GLF3D,2);
nlocations=size(GLF3D,1);
nfilters0=size(GLF03D,2);

% sample 3D orientations uniformly
norientations=100;
oGrid=SpiralSampleSphere(norientations); % norientations X 3
dd=1-oGrid*oGrid'; % inter-orientation distances

% gain for each orientation (3 --> norientations)
GLOF=reshape(GLF3D,[nlocations*nfilters,3])*oGrid';
GLOF=reshape(GLOF,[nlocations,nfilters,norientations]);
GLOF=permute(GLOF,[1 3 2]);  % nlocations X norientations X nfilters

% evaluate cost at every location/orientation
cost=cost_function5(reshape(GLOF,[nlocations*norientations,nfilters]), 1);
cost=reshape(cost,nlocations,norientations);
    
if 0
for iLoc=1:nlocations
    figure(1); clf;
    scatter3(oGrid(:,1),oGrid(:,2),oGrid(:,3),60,log10(cost(iLoc,:)),'filled'); 
    drawnow
end
end


% best orientation at each location
[~,iBest]=min(cost,[],2);

nt_whoss;
% 
val=inf;
cmax=inf;
for iLoc=1:nlocations
    
    % the cost function of orientation is bipolar, we need to chose one pole
    cost(iLoc,find(dd(iBest(iLoc),:)>1))=cmax; % zap orientations opposite to best 
    [~,idxBest]=mink(cost(iLoc,:),4); % chose 4 best as anchors for interpolation
    oBest=oGrid(idxBest,:);
    cBest=cost(iLoc,idxBest);

    % interpolate to center of gravity of anchors
    oBetter=oBest(1,:)/cBest(1)+oBest(2,:)/cBest(2)+oBest(3,:)/cBest(3);
    oBetter=oBetter/sqrt(sum(oBetter.^2));
    
    % estimate cost at interpolated orientation
    g=reshape(GLF3D(iLoc,:,:),nfilters,3)*oBetter';
    cBetter=cost_function5(reshape(g,1,nfilters),1);
    
    % normalize by cost averaged over full filter matrix
    g2=reshape(GLF03D(iLoc,:,:),nfilters0,3)*oBetter';
    bias=cost_function5(reshape(g2,1,nfilters0),1);      
    cc(iLoc)=cBetter/bias;

    if cc(iLoc)<val
        val=cc(iLoc);
        idx=iLoc;
        orient=oBetter;
    end
end

