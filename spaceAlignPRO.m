function [UNI, D, TRANSFORM] = spaceAlignPRO(data,id,show)
% Align latent spaces using Procrustes transform
% INPUT:
% data: cell array with latent spaces each sized nsamples x dimensions. The
%       first dataset will be used as the starting point to alignt the others.
% id: labels for the each sample (also in a cell array). The centroids of the
%     classes defined by id will be used to align the data.
% show: set to 1 to generate pretty skittles plot
%OUTPUT:
%UNI: aligned data (univeral latent space)
%D: goodness of fit metric from the procrustes transform. 
%TRANSFORM: 
% structure with fields:
%        c:  the translation component
%        T:  the orthogonal rotation and reflection component
%        b:  the scale component
%     That is, Z = TRANSFORM.b * Y * TRANSFORM.T + TRANSFORM.c.

UNI{1} = data{1}; % align all datasets to the first one

if(show)
    radius = 1
    spherepoints = 10
    figure
    skittlesPlot(UNI{1}, id{1}, radius, spherepoints,[]);
    hold on
end

% get centroids
n =1
uc = unique(id{n});
f = find(uc ~= 'no_action' & uc ~= 'Do nothing');
uc = uc(f)
for c = 1:numel(uc)
    fc = find(id{n} == uc(c));
    cent{n}(c,:) = mean( data{n}(fc,:));
end

%%

for n = 2:numel(data)
    
    
    % get BP centroids
    uc = unique(id{n});
    % exclude no_action & Do nothing centroids
    f = find(uc ~= 'no_action' & uc ~= 'Do nothing');
    uc = uc(f); 
    for c = 1:numel(uc)
        fc = find(id{n} == uc(c));
        cent{n}(c,:) = mean( data{n}((fc),:) );
    end
    
    %get procrustes transform using centroids
    [D(n), Z, TRANSFORM(n)] = procrustes(cent{1}, cent{n});
    
    % apply transform to all points
    UNI{n} =  TRANSFORM(n).b * data{n} * TRANSFORM(n).T + repmat(TRANSFORM(n).c(1,:), size(data{n}, 1), 1);
    
    % keep track of transform statistics? may not generalize to High-D
%     RDEG(n) = rad2deg(  acos( (trace(TRANSFORM.T)-1)/2 ) );
%     REFLECTION(n) = det(T.T) == -1;
    
    
    if(show)
        hold on
        
        [h lob] = skittlesPlot(UNI{n}, id{n}, radius, spherepoints,[]);
        delete(lob(1));
        delete(lob(2));
    end
end


if(show)
    set(gcf,'position',[13 217 1033 777])
    view(2)
    L = findobj(gcf,'Type','Light'); set(L(1),'position',get(gca,'cameraposition')); set(L(2),'position',get(gca,'cameraposition')*-1);
end

UNI = vertcat(UNI{:});

