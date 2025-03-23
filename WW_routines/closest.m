function idxClosest=closest(loc,N)
%idxClosest=closest(loc,N) - find closest locations
%
%  idxClosest: matrix of indices (nlocations X N)
%
%  loc: locations (nlocations X 3)
%  N: number of neighbors to consider

if nargin<2; error('!'); end

idxClosest=zeros(size(loc,1),N);

CHUNKSIZE=1000;
for iLoc=1:CHUNKSIZE:size(loc,1)
    disp(iLoc)
    idx=iLoc+(0:CHUNKSIZE-1);
    idx=min(idx,size(loc,1));
    a=reshape(loc(idx,:),[1,numel(idx),3]);
    b=reshape(loc,[size(loc,1),1,3]);
    d=repmat(a,[size(loc,1),1,1])-repmat(b,[1,numel(idx),1]);
    dd=sum(d.^2,3);
    [~,ii]=sort(dd);
    idxClosest(idx,:)=ii(1:N,:)';
end
    
    
