%% Crossover interaction between Perceived Exertion & Fatigue

outcome = 'subjectExperienceRating';

% create a table for analyses
borgFatigueVals = [allSubData.Borg; allSubData.Tired];
borgFatigueDummy = [zeros(26928/2, 1); ones(26928/2,1)]; % 0 = Borg
difficulty = [allSubData.Difficulty; allSubData.Difficulty];
confidence = [zscoreNan(allSubData.Confidence); zscoreNan(allSubData.Confidence)];
effort = [zscore(allSubData.AbsEffort); zscore(allSubData.AbsEffort)];
time = [allSubData.zTrialNum_Session; allSubData.zTrialNum_Session];
subID = [allSubData.SubID; allSubData.SubID];

dummyTable = [borgFatigueVals'; borgFatigueDummy'; difficulty'; confidence'; effort'; time']';
borgFatigueHdr = {'BorgFatigueVal', 'isBorgFatigue', 'Difficulty', 'Confidence', 'Effort', 'Time'};
borgFatigueTbl = array2table(dummyTable);
borgFatigueTbl.Properties.VariableNames = borgFatigueHdr; 
borgFatigueTbl.SubID = subID;
borgFatigueTbl.isBorgFatigue = categorical(borgFatigueTbl.isBorgFatigue);

% crossover interaction model
borg_fatigue_model = fitlme(borgFatigueTbl,...
    'BorgFatigueVal ~ 1 + isBorgFatigue*Effort + isBorgFatigue*Time + Confidence + (1 + isBorgFatigue*Effort + isBorgFatigue*Time + Confidence|SubID)',...
    'FitMethod','REML') ;
% [~,~,borg_fatigue_model_res] = fixedEffects(borg_fatigue_model, 'DFmethod', 'satterthwaite')

%% Plot predicted subjective ratings from crossover interaction with time as main covariate
% Create datatable for predict function
dat = borgFatigueTbl;
datNew = table();
% X
datNew.Time = linspace(nanmin(dat.Time), nanmax(dat.Time))';
% covariates of no interest
datNew.Difficulty = (0*ones(1,height(datNew)))';
datNew.Confidence = (nanmean(dat.Confidence)*ones(1,height(datNew)))';
datNew.Effort = (0*ones(1,height(datNew)))';
datNew.isBorgFatigue = categorical(0*ones(1,height(datNew))');
datNew.SubID = repmat(dat.SubID(1),height(datNew),1);
% Y
[ypred_Fatigue_marg,yCIpred_Fatigue_marg] = predict(borg_fatigue_model,datNew,...
    'Conditional',false,'DFmethod','satterthwaite');

ySE = yCIpred_Fatigue_marg(:,2) - ypred_Fatigue_marg;

figure();

[y_pred_marg, yCI_marg] = predict(borg_fatigue_model, datNew,...
    'Conditional',false,'DFmethod','satterthwaite');

shadedErrorBar(datNew.Time, y_pred_marg, yCI_marg(:,2)-y_pred_marg, 'lineprops', {'b', 'LineWidth', 3})

% Figure of predicted perceived exertion 
shadedErrorBar(datNew.Time, ypred_Fatigue_marg, ySE,'lineprops',{'b','LineWidth', 3})

hold on

% Figure of predicted fatigue 
datNew.isBorgFatigue = categorical(1*ones(1,height(datNew))');

[ypred_Fatigue_marg,yCIpred_Fatigue_marg] = predict(borg_fatigue_model,datNew,...
    'Conditional',false,'DFmethod','satterthwaite');
ySE = yCIpred_Fatigue_marg(:,2) - ypred_Fatigue_marg;

shadedErrorBar(datNew.Time,ypred_Fatigue_marg,ySE,'lineprops',{'m','LineWidth', 3});
hold on

% Make the graphs pretty
set(gca, 'FontSize', 12)
hold on
ylabel('Subjective Experience Rating', 'FontSize', 14)
hold on
xlabel('Trial (z-scored)','FontSize', 14)
set(gca,'TickDir','out');
box off
% h = findobj(gca,'Type','line');
% lgd = legend([h(1), h(4)],{'Positive','Negative'});
% fontsize(lgd,14,'points')
filename = strcat(outcome,'Trial','.png');
saveas(gcf,filename)

% Legend
% hold on
% h = findobj(gca,'Type','line');
% legend([h(1), h(4)],{'Fatigue','Perceived Exertion'})

%% Plot predicted subjective ratings from crossover interaction with grip force as main covariate
datNew.Effort = linspace(nanmin(dat.Effort), nanmax(dat.Effort))';
datNew.Time = (nanmean(dat.Time)*ones(1,height(datNew)))';

figure();

% Figure of predicted perceived exertion 
datNew.isBorgFatigue = categorical(0*ones(1,height(datNew))');
[ypred_Fatigue_marg,yCIpred_Fatigue_marg] = predict(borg_fatigue_model,datNew,...
    'Conditional',false,'DFmethod','satterthwaite');
shadedErrorBar(datNew.Effort,ypred_Fatigue_marg,(yCIpred_Fatigue_marg(:,2)-ypred_Fatigue_marg),'lineprops',{'b','LineWidth', 3});
hold on

% Figure of predicted fatigue 
datNew.isBorgFatigue = categorical(1*ones(1,height(datNew))');
[ypred_Fatigue_marg,yCIpred_Fatigue_marg] = predict(borg_fatigue_model,datNew,...
    'Conditional',false,'DFmethod','satterthwaite');
shadedErrorBar(datNew.Effort,ypred_Fatigue_marg,(yCIpred_Fatigue_marg(:,2)-ypred_Fatigue_marg),'lineprops',{'m','LineWidth', 3});
hold on

% Make the graphs pretty
set(gca, 'FontSize', 12)
hold on
ylabel('Subjective Experience Rating', 'FontSize', 14)
hold on
xlabel('Grip Force (z-scored)','FontSize', 14)
% Legend
hold on
h = findobj(gca,'Type','line');
lgd = legend([h(1), h(4)],{'Fatigue','Perceived Exertion'}, 'Location', 'northwest');
set(gca,'TickDir','out');
box off
fontsize(lgd,14,'points')
filename = strcat(outcome,'GripForce','.png');
saveas(gcf,filename)