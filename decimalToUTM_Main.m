clc;clear;close all;

[b, a] = uigetfile('.xlsx');
[X, adr] = xlsread([a filesep b]);

for i = 1:size (X,1)
    
% Main script
utmX = X(i,1) ;  % Easting
utmY = X(i,2) ; % Northing


[easting, northing, zone, hemi] = decimalToUTM(utmX, utmY);

Easting(i)=easting;
Northing(i)=northing;

fprintf('Latitude: %.6f, Longitude: %.6f\n', easting, Northing);
end
% xlswrite([a filesep 'R1.csv'],adr,'sheet1','A');
xlswrite([a filesep 'R1.csv'],Easting','Sheet1','B');
xlswrite([a filesep 'R1.csv'],Northing','sheet1','C');
