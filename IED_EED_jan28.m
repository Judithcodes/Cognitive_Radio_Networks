% ----- IED KMM -------
clear all;
Pf = 1;
% Pf = 0.5;
SNR_dB= -5; % SNR in dB
gam=power(10,SNR_dB/10); % SNR ratio
N=100; % No of samples

% avg_noise_pow = 1;
f=6e6; % carrier freq for modn
bw = 6e6; % bandwidth of interest
noise_figure = 11; % noise figure in dB (as specified in IEEE 802.22)
noise_power = -174+10*log(bw)+noise_figure; %noise power in dBm conversion
avg_noise_pow=double((1e-3)*power(10,noise_power/10));% received power in watts
% avg_noise_pow = 1;
%----- uniformly distributed random numbers-----

m =0.5:0.01:10;
M = 10;
L = 10;
% mu0 = N*((2^(p/2))*gamma((p+1)/2)*(avg_noise_pow^(p/2))/sqrt(pi));
% var0 = N*(((2^p)*(gamma(((2*p)+1)/2)-((gamma((p+1)/2)^2)/sqrt(pi)))*(avg_noise_pow^p))/sqrt(pi));
% mu1 = N*((2^(p/2))*((1+gam)^(p/2))*gamma((p+1)/2)*(avg_noise_pow^(p/2))/sqrt(pi));
% var1 = N*(((2^p)*((1+gam)^p)*(gamma(((2*p)+1)/2)-((gamma((p+1)/2)^2)/sqrt(pi)))*(avg_noise_pow^p))/sqrt(pi));
% 
%  mu_avg = ((M/L)*N*mu1)+ (((L-M)/L)*N*mu0);
%  sig_avg =((M/L^2)*N*var1)+ (((L-M)/L^2)*N*var0) ;
 
for i = 1:length(m) 
    p = m(i);
    mu0 = N*((2^(p/2))*gamma((p+1)/2)*(avg_noise_pow^(p/2))/sqrt(pi));
    var0 = N*(((2^p)*(gamma(((2*p)+1)/2)-((gamma((p+1)/2)^2)/sqrt(pi)))*(avg_noise_pow^p))/sqrt(pi));
    mu1 = N*((2^(p/2))*((1+gam)^(p/2))*gamma((p+1)/2)*(avg_noise_pow^(p/2))/sqrt(pi));
    var1 = N*(((2^p)*((1+gam)^p)*(gamma(((2*p)+1)/2)-((gamma((p+1)/2)^2)/sqrt(pi)))*(avg_noise_pow^p))/sqrt(pi));

%     mu_avg = ((M/L)*N*mu1)+ (((L-M)/L)*N*mu0);
%     sig_avg =((M/L^2)*N*var1)+ (((L-M)/L^2)*N*var0) ;
    mu_avg = ((M/L)*mu1)+ (((L-M)/L)*mu0);
    sig_avg =((M/L^2)*var1)+ (((L-M)/L^2)*var0) ;


    lamda = ((qfuncinv(Pf))*(sqrt(var0)))+ mu0;
    Pd(i) = qfunc((lamda-mu1)/sqrt(var1));
    Pdied(i) = Pd(i)+(Pd(i)*((1-Pd(i))*qfunc((lamda-mu_avg)/sqrt(sig_avg))));
    Pfied(i) = Pf+(Pf*((1-Pf)*qfunc((lamda-mu_avg)/sqrt(sig_avg))));
       
end

[v1 p1]=max(Pd);
opt_m1 = m(p1);

[v2 p2]=max(Pdied);
opt_m2 = m(p2);
% plot(Pfc,Pdc,'b','linewidth',2); hold on
% plot(Pfa,Pdt,'b','linewidth',2);hold on
plot(m,Pdied,'r','linewidth',2); hold on
plot(m,Pd,'b','linewidth',2); hold on
plot(opt_m1,v1,'*k');hold on;
plot(opt_m2,v2,'*k');grid minor
% plot(Pf,Pd,'r');hold on;