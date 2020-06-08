
function dB0=MagLinear_CEST(p,VMmg)
%create dB0 field
% Initialize parameters
GradX=p.GradX;
GradY=p.GradY;
GradZ=p.GradZ;
Scale=p.Scale;


% Initialize display grid
xgrid=VMmg.xgrid;
ygrid=VMmg.ygrid;
zgrid=VMmg.zgrid;
%ygrid = abs(ygrid);
dB0=(xgrid.*GradX+ygrid.*GradY+zgrid.*GradZ).*Scale;
% size(dB0)
end
