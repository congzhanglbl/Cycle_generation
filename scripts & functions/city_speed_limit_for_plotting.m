function city_speed_limit_for_plotting
% Create and plot the probability vs error curves for acceleration, deceleration and cruise
% for a city drive cycle.
%
% The error is the speed required minus the mean speed of the drive cycle so far.
% The inputs a & b are the key values of the error
% The outputs are respectively the transition probability matrix, the vector
% of the error values and the parameter b

a = 15; b = 20;

% Create figure
figure1 = figure;

x = [(-b-10);(-b);(-a);0;a;b;b+10];
xq = ((-b-10):0.1:b+10);

% Create the probability curve for idle
y = [0;0;0;0;0;0;0];
vqi = interp1(x,y,xq);


% Create the probability curve for acceleration
y = [0;0;0;0;0;0;0];
vqa = interp1(x,y,xq);


% Create the probability curve for cruise
y = [0.5;0.5;0.7;0.9;0.9;1;1];
vqc = interp1(x,y,xq);


% Create the probability curve for deceleration
y = [0.5;0.5;0.3;0.1;0.1;0;0];
vqd = interp1(x,y,xq);


% Plot the sum of probabilities
sum = vqi+vqa+vqd+vqc;


% Create axes
axes1 = axes('Parent',figure1,'YTickLabel',{'0','20','40','60','80','100'},...
    'XTickLabel',{'-48','-32','-24','-8','0','8','24','32','48'},...
    'XTick',[ -30 -20 -15 -5 0 5 15 20 30],...
    'FontSize',12);

xlim(axes1,[-b-10 b+10]);
ylim(axes1,[0 1.1]);
hold(axes1,'all');

plot(xq,vqi,'--m')
plot(xq,vqa,'-.g')
plot(xq,vqc,'b')
plot(xq,vqd,':r')
plot(xq,sum,'k')


% Create xlabel
xlabel('Error value (km/h)','FontSize',16);

% Create ylabel
ylabel('Probability (%)','FontWeight','light','FontSize',16);

% Create title
title('(A) Normal City Driving','FontWeight','bold','FontSize',16);

% Create legend
legend('Idle','Acceleration','Cruise','Deceleration','Sum of probabilities')
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.236044399458169 0.683860289997319 0.251275510204082 0.283464566929134]);

end