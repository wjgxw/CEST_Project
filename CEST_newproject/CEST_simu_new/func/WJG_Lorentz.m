%reference: McRobbie, Donald W, from proton to picture,2006,pp.379
%fwhm:
%amplitude:amplitude
%omega_0:the center frequency
%

function Lof=WJG_Lorentz(par0,omega)
    if iscell(par0)
        amplitude = par0{1};
        omega_0 = par0{2};
        fwhm = par0{3};
        sigma0 = fwhm./2;
        amplitude = sigma0.*amplitude;
        max_value = par0{4};
        Lof = max_value-amplitude.*sigma0./(sigma0.^2+(omega-omega_0).^2+eps);
    else
        amplitude = par0(1);
        omega_0 = par0(2);
        fwhm = par0(3);
        sigma0 = fwhm./2;
        amplitude = sigma0.*amplitude;
        max_value = par0(4);
        Lof = max_value-amplitude.*sigma0./(sigma0.^2+(omega-omega_0).^2+eps);
    end
