function [prob,err_val,b] = city_traffic_idle(a,b)
% Create the probability matrix for acceleration, deceleration and cruise
% for heavy traffic in a city when the vehicle is stopped.
%
% Create the vector of the error values.
% The error is the speed required minus the mean speed of the drive cycle
% so far.
%
% The inputs a & b are the particular values of the error, the parameters
% for the matrix.
%
% The outputs are respectively the transition probability matrix, the vector
% of the error values and the parameter b.


x = [(-b);(-a);0;a;b];
xq = ((-b):0.1:b);

% Create the probability curve for idle
y = [0.9;0.7;0.6;0.5;0.4];
vqi = interp1(x,y,xq);


% Create the probability curve for acceleration
y = [0.1;0.3;0.4;0.5;0.6];
vqa = interp1(x,y,xq);


% Create the probability curve for cruise
y = [0;0;0;0;0];
vqc = interp1(x,y,xq);


% Create the probability curve for deceleration
y = [0;0;0;0;0];
vqd = interp1(x,y,xq);


prob = [vqi',vqa',vqc',vqd'];
err_val = xq';

clc
end

