% generate the mask of convex
%input: xv,yv are the coordinates of verteses vx(1)=vx(end),vy(1)=vy(end)
% output S: the mask of a convex
% created by Angus, wjtcw@hotmail.com
function S = WJG_convex_S(w,vx,vy)

 
row = w;
col = w;
[A,B]=meshgrid(1:row,1:col);
S = inpolygon(A,B,vy,vx);
 
