function [ c ] = WJGgenRing( w,r1,r2,center )

%   r1,r2 are radials of corresponding circles, r1 must bigger than r2 
c1 = WJGgenCircle(w,r1,center);
c2 = WJGgenCircle(w,r2,center);
c = c1 & ~c2;
end
