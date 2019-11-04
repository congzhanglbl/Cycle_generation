function city_idle_for_plotting(X1, YMatrix1)
%CREATEFIGURE1(X1, YMATRIX1)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 27-Aug-2014 04:46:41

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YTickLabel',{'0','20','40','60','80','100'},...
    'YTick',[0 0.2 0.4 0.6 0.8 1],...
    'XTickLabel',{'-64','-48','-32','-24','-8','0','8','24','32','48','64'},...
    'XTick',[-40 -30 -20 -15 -5 0 5 15 20 30 40],...
    'FontSize',12);

 ylim(axes1,[0 1.1]);
hold(axes1,'all');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'LineWidth',2,'Parent',axes1);
set(plot1(1),'LineStyle','--','Color',[1 0 1],'DisplayName','Idle');
set(plot1(2),'LineStyle','-.','Color',[0 1 0],'DisplayName','Acceleration');
set(plot1(3),'Color',[0 0 1],'DisplayName','Cruise');
set(plot1(4),'LineStyle',':','Color',[1 0 0],'DisplayName','Deceleration');
set(plot1(5),'DisplayName','Sum of probabilities','Color',[0 0 0]);

% Create xlabel
xlabel('Error value (km/h)','FontSize',16);

% Create ylabel
ylabel('Probability (%)','FontWeight','light','FontSize',16);

% Create title
title('(B) Idling during City Driving','FontWeight','bold','FontSize',16);

