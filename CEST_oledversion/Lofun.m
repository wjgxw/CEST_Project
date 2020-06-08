function Lof=Lofun(K,x)
Lof=K(1)+K(3)^2*K(2)/pi*K(3)*((4*(x-K(4)).^2+K(3).^2).^(-1));
% Lof=K(1)+2*K(2)/pi*K(3)*((4*(x-K(4)).^2+K(3).^2).^(-1));
end