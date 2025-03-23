function z=zerox3(x,idxClosest,thresh)
%z=zerox3(x) - 3D zero crossings
%
%  z: zero crossing matrix (nlocations X 1 or nlocations X npages), 0 if zero-crossing, 1 otherwise
%
%  x: value matrix (nlocations X 1 or nlocations X npages)
%  idxClosest: indices of closest neighbors (nlocations X nneighbors)
%  thresh: minimum number of neighbors of opposite sign [default: 1]

if nargin<2; error('!'); end
if nargin<3||isempty(thresh); thresh=1; end

if size(x,2)>1 
    z=ones(size(x));
    for iCol=1:size(x,2);
        z(:,iCol)=zerox3(x(:,iCol),idxClosest,thresh);
    end
    return
end

z=ones(size(x));
nneighbors=size(idxClosest,2);
nz=zeros(size(x));
for iNeighbor=1:nneighbors
    idxZ=x.*x(idxClosest(:,iNeighbor)) < 0; % opposite sign
    nz(idxZ)=nz(idxZ)+1; 
end
z(nz>thresh)=0;







% % zap if next sample along each dim is of a different sign
% idx=1:n-1;
% z(idx,:,:)=z(idx,:,:).*(x(idx,:,:).*x(idx+1,:,:)>0);
% z(:,idx,:)=z(:,idx,:).*(x(:,idx,:).*x(:,idx+1,:)>0);
% z(:,:,idx)=z(:,:,idx).*(x(:,:,idx).*x(:,:,idx+1)>0);
% 
% %  zap if previous sample along each dim is of a different sign
% idx=2:n;
% z(idx,:,:)=z(idx,:,:).*(x(idx,:,:).*x(idx-1,:,:)>0);
% z(:,idx,:)=z(:,idx,:).*(x(:,idx,:).*x(:,idx-1,:)>0);
% z(:,:,idx)=z(:,:,idx).*(x(:,:,idx).*x(:,:,idx-1)>0);
% 
