function [prob,err_val,b] = city_speed_limit(a,b)
% Create the probability matrix for acceleration, deceleration and cruise
% for a city drive cycle when the speed value is above a given speed limit.
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
y = [0;0;0;0;0];
vqi = interp1(x,y,xq);


% Create the probability curve for acceleration
y = [0;0;0;0;0];
vqa = interp1(x,y,xq);


% Create the probability curve for cruise
y = [0.5;0.7;0.9;0.9;1];
vqc = interp1(x,y,xq);


% Create the probability curve for deceleration
y = [0.5;0.3;0.1;0.1;0];
vqd = interp1(x,y,xq);


prob = [vqi',vqa',vqc',vqd'];
err_val = xq';

clc
end

