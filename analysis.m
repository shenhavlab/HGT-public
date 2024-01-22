setup;

%% Effort output (grip force) varies with both effort demands and time on task

effort_model = fitlme(allSubData,...
    'AbsEffort ~ 1 + zCenterBox * zTrialNum_Session + (1 + zCenterBox * zTrialNum_Session|SubID)',...
    'FitMethod','REML') ;
[~,~,effort_model_results] = fixedEffects(effort_model, 'DFmethod', 'satterthwaite')

EffortOvershootBias = fitlme(allSubData,...
    'Overshoot ~ 1 + (1|SubID)',...
    'FitMethod','REML') ;
[~,~,EffortOvershootBias_results] = fixedEffects(EffortOvershootBias, 'DFmethod', 'satterthwaite')

average_accuracy = grpstats(allSubData, "SubID","mean","DataVars", ["BoxDuration", "IsCorrect"]);
mean_box_duration = nanmean(average_accuracy.mean_BoxDuration)
mean_met_trial_acc = nanmean(average_accuracy.mean_IsCorrect)

%% Fatigue and perceived exertion are tied to dissociable aspects of effort output

fatigue_time_effort = fitlme(allSubData,...
    'Tired ~ 1 + zTrialNum_Session * zAbsEffort + zConfidence + zBorg + (1 + zTrialNum_Session * zAbsEffort + zConfidence + zBorg|SubID)',...
    'FitMethod','REML') ;
[~,~,fatigue_time_effort_results] = fixedEffects(fatigue_time_effort, 'DFmethod', 'satterthwaite')

borg_time_effort = fitlme(allSubData,...
    'Borg ~ 1 + zTrialNum_Session * zAbsEffort + zConfidence + zTired + (1 + zTrialNum_Session * zAbsEffort + zConfidence + zTired|SubID)',...
    'FitMethod','REML') ;
[~,~,borg_time_effort_results] = fixedEffects(borg_time_effort, 'DFmethod', 'satterthwaite')

% crossover interaction

borgFatigueInteraction;

%% Fatigue increases more rapidly when receiving negative relative to positive feedback

fatigue_time_fb = fitlme(allSubData,...
    'Tired ~ 1 + FeedbackCondition * zTrialNum_Session + zAbsEffort * zTrialNum_Session + zConfidence + zBorg + (1 + FeedbackCondition * zTrialNum_Session + zAbsEffort * zTrialNum_Session + zConfidence + zBorg |SubID)',...
    'FitMethod','REML') ;
[~,~,fatigue_time_fb_results] = fixedEffects(fatigue_time_fb, 'DFmethod', 'satterthwaite')

borg_effort_fb = fitlme(allSubData,...
    'Borg ~ 1 + FeedbackCondition * zAbsEffort + zAbsEffort * zTrialNum_Session + zConfidence + zTired + (1 + FeedbackCondition * zAbsEffort + zAbsEffort * zTrialNum_Session + zConfidence + zTired |SubID)',...
    'FitMethod','REML') ;
[~,~,borg_effort_fb_results] = fixedEffects(borg_effort_fb, 'DFmethod', 'satterthwaite')

% supplementary table 2

borg_time_fb = fitlme(allSubData,...
    'Borg ~ 1 + FeedbackCondition * zTrialNum_Session + zAbsEffort * zTrialNum_Session + zConfidence + zTired + (1 + FeedbackCondition * zTrialNum_Session + zAbsEffort * zTrialNum_Session + zConfidence + zTired |SubID)',...
    'FitMethod','REML') ;
[~,~,borg_time_fb_results] = fixedEffects(borg_time_fb, 'DFmethod', 'satterthwaite')

fatigue_effort_fb = fitlme(allSubData,...
    'Tired ~ 1 + FeedbackCondition * zAbsEffort + zAbsEffort * zTrialNum_Session + zConfidence + zBorg + (1 + FeedbackCondition * zAbsEffort + zAbsEffort * zTrialNum_Session + zConfidence + zBorg |SubID)',...
    'FitMethod','REML') ;
[~,~,fatigue_effort_fb_results] = fixedEffects(fatigue_effort_fb, 'DFmethod', 'satterthwaite')

% figures

feedback_figure('Fatigue', fatigue_time_fb, allSubData, 'Time')

feedback_figure('Perceived Exertion', borg_effort_fb, allSubData, 'Grip Force')

%% Negative feedback increases the sensitivity of effort output to task difficulty

% supplementary table 3
effort_feedback_model = fitlme(allSubData,...,
    'AbsEffort ~ 1 + FeedbackCondition * zCenterBox * zTrialNum_Session + (1 + FeedbackCondition * zCenterBox * zTrialNum_Session|SubID)',...
    'FitMethod','REML') ;
[~,~,effort_feedback_model_results] = fixedEffects(effort_feedback_model, 'DFmethod', 'satterthwaite')

% figures

feedback_figure('Grip Force', effort_feedback_model, allSubData, 'Effort Demands')

%% Confidence reflects cumulative feedback, despite both being decoupled from performance

confidenceFB = fitlme(allSubData,...
    'Confidence ~ 1 + CumulativeFeedback * FeedbackCondition + (1 + CumulativeFeedback * FeedbackCondition|SubID)',...
    'FitMethod','REML') ;
[~,~,results] = fixedEffects(confidenceSession, 'DFmethod', 'satterthwaite')

% figures

feedback_figure('Confidence', confidence_fb, allSubData, 'Cumulative Feedback')

% Break confidence into positive and negative feedback blocks
conf_posFB = fitlme(allSubData,...
    'Confidence ~ 1 + CumulativeFeedback + (1 + CumulativeFeedback|SubID)',...
    'FitMethod','REML', 'Exclude', allSubData.cFeedback==categorical(0)) ;
[~,~,confidence_posFB_results] = fixedEffects(conf_posFB, 'DFmethod', 'satterthwaite')

conf_negFB = fitlme(allSubData,...
    'Confidence ~ 1 + CumulativeFeedback + (1 + CumulativeFeedback|SubID)',...
    'FitMethod','REML', 'Exclude', allSubData.cFeedback==categorical(1)) ;
[~,~, conf_negFB_results] = fixedEffects(conf_negFB, 'DFmethod', 'satterthwaite')

% difference between magnitude of slopes
z = beta_coeff_test(.0002, .0004, 0.001, 0.001)

% accuracy over time
accuracy_time = fitlme(allSubData,...,
    'IsCorrect ~ 1  + zTrialNum_Session + (1 + zTrialNum_Session|SubID)',...
    'FitMethod','REML') ;
[~,~,accuracy_time_results] = fixedEffects(accuracy_time, 'DFmethod', 'satterthwaite')

% supplementary table

rawPlotAcc(allSubData, 'Confidence', 'Confidence')

allSubData.zAccuracy = zscoreNan(allSubData.CorrAccMean);

confAcc = fitlme(allSubData,...
    'Confidence ~ 1 + zAccuracy + (1 + zAccuracy|SubID)',...
    'FitMethod','REML') ;
[~,~,confAcc_results] = fixedEffects(confAcc, 'DFmethod', 'satterthwaite')

conf_effort = fitlme(allSubData,...
    'Confidence ~ 1 + zAbsEffort + (1 + zAbsEffort|SubID)',...
    'FitMethod','REML') ;
[~,~,conf_effort_results] = fixedEffects(conf_effort, 'DFmethod', 'satterthwaite')

conf_fatigue = fitlme(allSubData,...
    'Confidence ~ 1 + zTired + (1 + zTired|SubID)',...
    'FitMethod','REML') ;
[~,~,conf_fatigue_results] = fixedEffects(conf_fatigue, 'DFmethod', 'satterthwaite')

conf_perceived_exertion = fitlme(allSubData,...
    'Confidence ~ 1 + zBorg + (1 + zBorg|SubID)',...
    'FitMethod','REML') ;
[~,~,conf_perceived_exertion_results] = fixedEffects(conf_perceived_exertion, 'DFmethod', 'satterthwaite')
