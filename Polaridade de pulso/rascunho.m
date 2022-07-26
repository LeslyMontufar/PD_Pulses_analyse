clc; clearvars; close all;
x = -1:1e-3:1;
f = (x).^2;
f = awgn(f,50);
yyaxis left
plot(f);
hold on;
yyaxis right
derivada = diff(f);
k = 300;

plot(derivada);
derivada = conv(derivada,ones(1,k)/k,'same');
plot(derivada,'g');
legend("f","diff","diff suave");
% xlim([0 1000])