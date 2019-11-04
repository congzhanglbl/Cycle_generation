function plot_cycles(cycles)

for k = 1:length(cycles)
        createfigure(cycles(k).speed(:,end))
end

