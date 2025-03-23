function [c_collapsed,locs_collapsed]=collapse_xyz(c,locs,dim)
%[c_collapsed,locs_collapsed]=collapse_xyz(c,locs,dim) - take min along x, y or z dimension 
%  
%  cm: min of cost function
%  locsm: associated locations (in 2D plane)
%
%  c: cost function of location
%  locs: locations
%  dim: dimension to collapse

if nargin<3; error('!'); end

% indices of locations that differ only along dim
other_dims=setdiff(1:3,dim);
[C,IA,IC]=unique(locs(:,other_dims),'rows'); % IC indicates membership

locs_collapsed=zeros(size(C,1),3);
locs_collapsed(:,other_dims)=C;

c_collapsed=zeros(size(C,1),1);
for iLoc=1:size(locs_collapsed)
    c_collapsed(iLoc)=min(c(IC==iLoc));
end
