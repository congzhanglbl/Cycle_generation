function city_traffic_idle_for_plotting
% Creates and plots the probability vs error curves for acceleration, deceleration and cruise
% when driving on highways.
%
% The error is the speed required minus the mean speed of the drive cycle so far.
% The inputs a & b are the key values of the error
% The outputs are respectively the transition probability matrix, the vector
% of the error values and the parameter b

a = 8; b = 10;

figure1 = figure;

x = [(-b-10);(-b);(-a);0;a;b;b+10];
xq = ((-b-10):0.1:b+10);

% Create the probability curve for idle
y = [0.9;0.9;0.7;0.6;0.5;0.4;0.4];
vqi = interp1(x,y,xq);


% Create the probability curve for acceleration
y = [0.1;0.1;0.3;0.4;0.5;0.6;0.6];
vqa = interp1(x,y,xq);


% Create the probability curve for cruise
y = [0;0;0;0;0;0;0];
vqc = interp1(x,y,xq);


% Create the probability curve for deceleration
y = [0;0;0;0;0;0;0];
vqd = interp1(x,y,xq);


% Plot the sum of probabilities
sum = vqi+vqa+vqd+vqc;

axes1 = axes('Parent',figure1,'YTickLabel',{'0','20','40','60','80','100'},...
    'YTick',[0 0.2 0.4 0.6 0.8 1],...
    'XTickLabel',{'-32','-16','-13','-8','0','8','13','16','32'},...
    'XTick',[-20 -10 -8 -5  0 5 8 10 20],...
    'FontSize',12);

xlim(axes1,[-20 20]);
ylim(axes1,[0 1.1]);
hold(axes1,'all');

plot(xq,vqi,'--m')
plot(xq,vqa,'-.g')
plot(xq,vqc,'b')
plot(xq,vqd,':r')
plot(xq,sum,'k')


xlabel('Error value (km/h)','FontSize',16);
ylabel('Probability (%)','FontWeight','light','FontSize',16);

clc
end

