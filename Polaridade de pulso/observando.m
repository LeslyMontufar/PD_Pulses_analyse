% clc; close all; clearvars;
% load('dadosLesly.mat');
n = 1:numel(iPeak);
positivos = n(iPeak>0);
for x=2:numel(positivos)/25
plot_pulsos_iPeak(x,pulsos(positivos,:),iPeak(positivos,:));
end