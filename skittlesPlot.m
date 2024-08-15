function [allh, lighth] = skittlesPlot(points, class, radius, spherepoints,colormat)
% [allh lighth] = skittlesPlot(points, class, radius, spherepoints,colormat)
% plot points as 3D spheres with lighting! 
% INPUTS:
% points: 3d data
% class: class of each point (used to color)
% radius: radius of each sphere
% spherepoints: number of points for each sphere mesh
% colormat: 3xn matrix of colors (where n = number of classes), use [] for default
% OUTPUTS:
% allh = list of handles to all sphere objects
% lighth = list of handles to two light objects
% NOTE: you can use 
% set(lighth(1),'position',get(gca,'cameraposition'));
% to reset the position of light object one to the current viewpoint
% Use the following to get access to all light objects
%  L = findobj(gcf,'Type','Light'); set(L(1),'position',get(gca,'cameraposition')*10); set(L(2),'position',get(gca,'cameraposition')*-10);

u = unique(class);
[x, y, z] = sphere(spherepoints); % number of vertices per sphere 

% if no color matrix specified, use defaults with black added as 0
if isempty(colormat)
    colormat = [lines(numel(u)-1); 0 0 0 ]
end

allh = [];
for n = 1:numel(u)
   
    f = find(class == u(n));
    for p = 1:numel(f)
       
        h =surfl( (x*radius) +points(f(p),1),  (y*radius)+points(f(p),2),  (z*radius)+points(f(p),3));       
        set(h,'FaceColor',colormat(n,:),'EdgeColor','none');
        hold on
        allh = [allh h];
    end
    
end

view(2)
axis off 
axis tight
axis equal

% add lights (if there are not any there already)
lighth = findobj(gcf,'Type','Light');
if numel(lighth)<1
lh1 = light ;
lh2 = light;
set(lh1,'position',get(gca,'cameraposition'));
set(lh2,'position',get(gca,'cameraposition')*-1);
lighth = [lh1 lh2];
end


