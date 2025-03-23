function plot_cost_volume(cost,loc,limits, electrode_positions,markersize,activations)
%plot_cost_volume(cost,loc,limits, electrode_positions) - plot cost in 3 views
%
%  cost: cost function values
%  loc: locations
%  limits: plot limits in mm [default: [-100,100; -100,100; -50,150]]
%  electrode_positions: [default: none]
%  activations: [default: none]

if nargin<2; error('!'); end
if nargin<3||isempty(limits); limits=[-100,100; -100,100; -50,150]; end
if nargin<4; electrode_positions=[]; end
if nargin<5||isempty(markersize); markersize=30; end
if nargin<6; activations=[]; end

if ~isempty(electrode_positions)
    idxSEEG=find(count({electrode_positions.Channel(:).Type},'SEEG')&~count({electrode_positions.Channel(:).Type}, 'SEEG_NO_LOC'));
    electrode_positions.Channel=electrode_positions.Channel(idxSEEG);
end

subplot 131
[c_collapsed,l_collapsed]=collapse_xyz(cost,loc,3);
x=l_collapsed(:,1)*1000; 
y=l_collapsed(:,2)*1000;
z=l_collapsed(:,3)*1000;
z=-100*ones(size(x));
scatter3(x,y,z,markersize,c_collapsed,'filled');
view(0, 90)
colormap (parula);
set(gca,'color',[1 1 1])
xlim(limits(1,:))
ylim(limits(2,:))
%zlim(limits(3,:))
xlabel('mm'); ylabel('mm');
set(gca,'fontsize', 14, 'box','on');
if ~isempty(electrode_positions)
    ep=electrode_positions;
    hold on; plot_SEEG_electrodes(ep,activations);
end
axis square
title('axial')
set(gca,'clim',[min(cost(:)),0])
plot_tweak([-0.05 0 0 0])

subplot 132
[cc_collapsed,l_collapsed]=collapse_xyz(cost,loc,2);
x=l_collapsed(:,1)*1000;
y=l_collapsed(:,2)*1000;
z=l_collapsed(:,3)*1000;
y=100*ones(size(x));
scatter3(x,y,z,markersize,cc_collapsed,'filled');
view(0, 0)
colormap (parula);
set(gca,'color',[1 1 1])
% h=colorbar('eastoutside');
% set(h,'fontsize',14);
% set(get(h,'label'),'string','%', 'fontsize',18);
xlim(limits(1,:))
%ylim(limits(2,:))
zlim(limits(3,:))
xlabel('mm'); ylabel('mm');
set(gca,'fontsize', 14, 'box','on');
if ~isempty(electrode_positions)
    ep=electrode_positions;
    hold on; plot_SEEG_electrodes(ep,activations);
end
axis square
title('sagittal')
set(gca,'clim',[min(cost(:)),0])
plot_tweak([-0.05 0 0 0])

subplot 133
[cc_collapsed,l_collapsed]=collapse_xyz(cost,loc,1);
x=l_collapsed(:,1)*1000;
y=l_collapsed(:,2)*1000;
z=l_collapsed(:,3)*1000;
x=100*ones(size(x));
scatter3(x,y,z,markersize,cc_collapsed,'filled');
view(-90,0)
colormap (parula);
set(gca,'color',[1 1 1]) 
% set(h,'fontsize',14);
% set(get(h,'label'),'string','%', 'fontsize',18);
%xlim(limits(1,:))
ylim(limits(2,:))
zlim(limits(3,:))
xlabel('mm'); ylabel('mm');
set(gca,'fontsize', 14, 'box','on');
if ~isempty(electrode_positions)
    ep=electrode_positions;
    hold on; plot_SEEG_electrodes(ep,activations);
end
axis square
title('coronal');
p=get(gca,'position');
h=colorbar('eastoutside'); set(get(h,'label'),'string','cost')
set(gca,'position',p)
set(gca,'clim',[min(cost(:)),0])
plot_tweak([-0.05 0 0 0])




