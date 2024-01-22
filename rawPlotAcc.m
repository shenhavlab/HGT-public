function rawPlotAcc(dat, var, y_title)
%% subset positive feedback data and negative feedback
posData = dat((dat.Feedback==1),1:width(dat));
negData = dat((dat.Feedback==0),1:width(dat));
%% target
figure(1)
% bin
%targetBins = discretize(posData.CorrAccMean, 5);
%posData.binnedTargets = targetBins;
[bin, binValues] = discretize(posData.CorrAccMean, 5);
posData.binnedTargets = bin;
% group stats
pos_binEffort_target=grpstats(posData,{'binnedTargets'},{'mean','std'},'DataVars',{var});
pos_binEffort_target_subj=grpstats(posData,{'SubID','binnedTargets'},{'mean'},'DataVars',{var}); % subject and bin level 
pos_binEffort_target_grp=grpstats(pos_binEffort_target_subj,{'binnedTargets'},{'mean','sem'},'DataVars',{strcat('mean_',var)}); % overall level
% plot positive feedback
posPlot=plot(pos_binEffort_target_grp.binnedTargets, pos_binEffort_target_grp{:,3}, 'g', 'Marker', 'o')
posPlot.LineWidth=2;
hold on
eG=errorbar(pos_binEffort_target_grp{:,3}, pos_binEffort_target_grp{:,4}, '.');
eG.Color='green';
eG.LineWidth=2;
hold on
% now same for negative feedback
%targetBins = discretize(negData.CorrAccMean, 5);
%negData.binnedTargets = targetBins;
[bin, binValues] = discretize(negData.CorrAccMean, 5);
negData.binnedTargets = bin;
neg_binEffort_target=grpstats(negData,{'binnedTargets'},{'mean','std'},'DataVars',{var});
neg_binEffort_target_subj=grpstats(negData,{'SubID','binnedTargets'},{'mean'},'DataVars',{var}); % subject and bin level 
neg_binEffort_target_grp=grpstats(neg_binEffort_target_subj,{'binnedTargets'},{'mean','sem'},'DataVars',{strcat('mean_',var)}); % overall level
% plot negitive feedback
negPlot=plot(neg_binEffort_target_grp.binnedTargets, neg_binEffort_target_grp{:,3}, 'r', 'Marker', 'o')
negPlot.LineWidth=2;
hold on
eG=errorbar(neg_binEffort_target_grp{:,3}, neg_binEffort_target_grp{:,4}, '.');
eG.Color='red';
eG.LineWidth=2;
hold on
% Make the graphs pretty
set(gca, 'FontSize', 12)
hold on
ylabel(y_title, 'FontSize', 14)
hold on
xlabel('Accuracy', 'FontSize', 14)
hold on
xlim([0 6])
set(gca, 'xtick', [1:5], 'xticklabel', binValues(2:6)); 
end 