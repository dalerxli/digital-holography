function output = LS_Basic(sig_n)

Nx_n = max(size(sig_n));
Ny_n = min(size(sig_n));
flag_error = 0;
if flag_error
    return
end
m=min(sig_n);
M=max(sig_n);
if m~=0. & M~=1.
    sig_n=(sig_n-m)/(M-m);
end
% fczq1d basic settings
[q,J,min_size,max_size,progstr,oscstr]=fczq1dbasicsettings(Nx_n,Ny_n);
% fl1d basic settings
[N,lrstr,title,xlabel,ylabel]=fl1dbasicsettings;
%current_mouse_ptr=fl_waiton;
% call of the C_LAB routine
[alpha,fl_alpha]=fcfl1d(sig_n,q,[J,min_size,max_size],progstr,oscstr,lrstr);

%fl_waitoff(current_mouse_ptr);
% make global cell
output = struct ('type','graph','data1',alpha,'data2',fl_alpha,'title',title,'xlabel',xlabel,'ylabel',ylabel);

% fczq1dbasicsettings
function [q,J,min_size,max_size,progstr,oscstr]=fczq1dbasicsettings(Nx_n,Ny_n)
q=[-10.:.1:10.];
J=floor(log(Nx_n*Ny_n)/log(2.));
min_size=1.;
max_size=2.^(J-1);
progstr='lin';
oscstr='osc';

% fl1dbasicsettings
function [N,lrstr,title,xlabel,ylabel]=fl1dbasicsettings
N=200;
lrstr='ls';
title='Legendre spectrum';
xlabel='Hoelder exponents: \alpha';
ylabel='spectrum: f_l(\alpha)';