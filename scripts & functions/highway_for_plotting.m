function highway_for_plotting

% Create and plot the probability vs error curves for acceleration, deceleration and cruise
% for a highway drive cycle.
%
% The error is the speed required minus the mean speed of the drive cycle so far.
% The inputs a & b are the key values of the error.
% The outputs are respectively the transition probability matrix, the vector
% of the error values and the parameter b.

a = 50; b = 55;

figure1 = figure;

x = [(-b-10);(-b);(-a);0;a;b;b+10];
xq = ((-b-10):0.1:b+10);

% Create the probability curve for idle
y = [0;0;0;0;0;0;0];
vqi = interp1(x,y,xq);


% Create the probability curve for acceleration
y = [0;0;0;0.025;0.85;0.9;0.9];
vqa = interp1(x,y,xq);


% Create the probability curve for cruise
y = [0.2;0.2;0.8;0.95;0.15;0.1;0.1];
vqc = interp1(x,y,xq);


% Create the probability curve for deceleration
y = [0.8;0.8;0.2;0.025;0;0;0];
vqd = interp1(x,y,xq);


% Plot the sum of probabilities
sum = vqi+vqa+vqd+vqc;

axes1 = axes('Parent',figure1,'YTickLabel',{'0','20','40','60','80','100'},...
    'YTick',[0 0.2 0.4 0.6 0.8 1],...
    'XTickLabel',{'-104','-88','-80','-72','-56','-40','-24','0','24','40','56','72','80','88','104'},...
    'XTick',[-65 -55 -50 -45 -35 -25 -15  0 15 25 35 45 50 55 65],...
    'FontSize',12);

xlim(axes1,[-65 65]);
ylim(axes1,[0 1.1]);
hold(axes1,'all');

plot(xq,vqi,'--m')
plot(xq,vqa,'-.g')
plot(xq,vqc,'b')
plot(xq,vqd,':r')
plot(xq,sum,'k')


legend('Idle','Acceleration','Cruise','Deceleration','Sum of probabilities')
xlabel('Error value (km/h)','FontSize',16);
ylabel('Probability (%)','FontWeight','light','FontSize',16);

clc
end

