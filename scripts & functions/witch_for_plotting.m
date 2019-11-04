function witch_for_plotting

a = 8; b = 10;

% Create figure
figure1 = figure;

x = [(-b-10);(-b);(-a);0;a;b;b+10];
xq = ((-b-10):0.1:b+10);

% Create the probability curve for idle
y = [0;0;0;0;0;0;0];
vqi = interp1(x,y,xq);


% Create the probability curve for acceleration
y = [0;0;0;0.25;0.65;0.75;0.75];
vqa = interp1(x,y,xq);


% Create the probability curve for cruise
y = [0.3;0.3;0.5;0.5;0.3;0.25;0.25];
vqc = interp1(x,y,xq);


% Create the probability curve for deceleration
y = [0.7;0.7;0.5;0.25;0.05;0;0];
vqd = interp1(x,y,xq);


% Plot the sum of probabilities
sum = vqi+vqa+vqd+vqc;


% Create axes
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


% Create xlabel
xlabel('Error value (km/h)','FontSize',16);

% Create ylabel
ylabel('Probability (%)','FontWeight','light','FontSize',16);

% Create title
title('(A) City Driving','FontWeight','bold','FontSize',16);

% Create legend
legend('Idle','Acceleration','Cruise','Deceleration','Sum of probabilities')
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.236044399458169 0.683860289997319 0.251275510204082 0.283464566929134]);

end

