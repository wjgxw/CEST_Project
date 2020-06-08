function [ c ] = WJGgenCircle(w,r,center)
%GENCIRCLE Summary of this function goes here
%   Detailed explanation goes here
%	W: is the size of the output size
%	r: the radial of circule 
%	center: the location of the center of the circle
[rr cc] = meshgrid(1:w);
c = sqrt((rr-center(1)).^2 + (cc-center(2)).^2) <= r;
end
