function plot_SEEG_electrodes(electrode_positions,activations)
%plot_SEEG_electrodes(electrode_positions,activations) - plot SEEG electrodes in space
%
%  electrode_positions: BST structure indicating types and locations 
%  activations: activation value for each electrode [default: none]
%

if nargin<2; activations=[]; end

% colors to use in plots
if 0
    % lighter
    blue = [114 147 203]./255;
    red = [211 94 96]./255;
    black = [128 133 133]./255;
    green = [132 186 91]./255;
    brown = [171 104 87]./255;
    purple = [144 103 167]./255;
else 
    % darker
    blue = [57 106 177]./255;
    red = [204 37 41]./255;
    black = [83 81 84]./255;
    green = [62 150 81]./255;
    brown = [146 36 40]./255;
    purple = [107 76 154]./255;
end
cl=[blue;red;black;green;brown;purple];


idxSEEG=find(count({electrode_positions.Channel(:).Type},'SEEG')&~count({electrode_positions.Channel(:).Type}, 'SEEG_NO_LOC'));

groups={electrode_positions.Channel(idxSEEG).Group};
groups=unique(groups);

if isempty(activations)
    % plot each group with a different color
    for iGroup=1:numel(groups)
        group=groups{iGroup};
        idx=find(count({electrode_positions.Channel(:).Group},group));
        locs={electrode_positions.Channel(idx).Loc};
        locs=cell2mat(locs); % 3 X N
        x=locs(1,:)*1000;
        y=locs(2,:)*1000;
        z=locs(3,:)*1000;    
        scatter3(x,y,z,5,cl(mod(iGroup,size(cl,1))+1,:),'filled');
        plot3(x,y,z,'color',cl(mod(iGroup,size(cl,1))+1,:), 'linewidth',2);
    end
else
    % plot each electrode according to its activation
    for iGroup=1:numel(groups)
        group=groups{iGroup};
        idx=find(count({electrode_positions.Channel(idxSEEG).Group},group));
        locs={electrode_positions.Channel(idxSEEG(idx)).Loc};
        locs=cell2mat(locs); % 3 X N
        x=locs(1,:)*1000;
        y=locs(2,:)*1000;
        z=locs(3,:)*1000;  
        %scatter3(x,y,z,200*activations(idx)/max(activations),cl(mod(iGroup,size(cl,1))+1,:));
        scatter3(x,y,z,200*activations(idx)/max(activations),'k','linewidth',1);
        plot3(x,y,z,'color',cl(mod(iGroup,size(cl,1))+1,:), 'linewidth',2);
        hold on;
    end
end    
    