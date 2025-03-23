function [idx,val,c,C]=find_source_pair(GSF0,nTarget, exponent)
%[idx,val]=find_source_pair(GSF0,nTarget,exponent) - find pair of sources
%
%   idx: indices of source pair
%   val: value at minimum
%
%   GSFo: source-to-filter gain for all null filters
%   nTarget: number of target null filters
%   exponent: for sum across filters [default: 2]

if nargin<2; error('!'); end
if nargin<3; exponent=2; end

nlocations=size(GSF0,1);

% construct a gain matrix of all pairs
GG0=zeros(nlocations*(nlocations-1)/2,size(GSF0,2));
idx1=zeros(nlocations*(nlocations-1)/2,1);
idx2=zeros(nlocations*(nlocations-1)/2,1);
iRunning=0;
for k=1:nlocations
    GG0(iRunning+(1:k-1),:)=repmat(GSF0(k,:),k-1,1) + GSF0(1:k-1,:);
    idx1(iRunning+(1:k-1))=k;
    idx2(iRunning+(1:k-1))=1:k-1;
    iRunning=iRunning+k-1;
end

GG=GG0(:,nTarget+1:end);
bias=sum(GG0.^2,2);

% cost function over all pairs
C=cost_function5(GG,bias,exponent);

f=gcf;
figure(10); clf; semilogy(C)
figure(f);

% best pair
[val,iBest]=min(C);
idx=[idx1(iBest),idx2(iBest)]

iRunning=0;
c=zeros(nlocations);
for k=1:nlocations
    c(1:k-1,k)=C(iRunning+(1:k-1));
    iRunning=iRunning+k-1;
end
c=c+c';
c=c+eye(nlocations);

c=min(c);



