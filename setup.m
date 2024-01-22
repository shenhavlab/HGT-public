%% ANALYSIS SETUP

currPath = genpath(pwd);
addpath(currPath);

% Loads the data
cd data;
load('HandgripData.mat');
cd ..;

% Rename variables to make them more clear
allSubData.zTrialNum_Block = allSubData.zFblockTrial;
allSubData.zTrialNum_Session = zscore(allSubData.Trial);
allSubData.Difficulty = allSubData.zCenterBox;

    % make effort as a percentage of max
allSubData.AbsEffort = allSubData.tMercLvl/484;
allSubData.zAbsEffort = zscore(allSubData.AbsEffort);

% changes to a percentage of black box height
allSubData.Overshoot = allSubData.tEffortLvl/45;

    % binarized confidence
allSubData.BinConfidence = NaN(length(allSubData.Confidence),1);
for i=1:length(allSubData.BinConfidence)
    if allSubData.Confidence(i) >= 0.5
        allSubData.BinConfidence(i) = 1;
    elseif isnan(allSubData.Confidence(i)) 
        allSubData.BinConfidence(i) = NaN;
    else allSubData.BinConfidence(i) = 0;
    end 
end

allSubData.FeedbackCondition=categorical(abs(allSubData.Feedback - 1)); 

%% Z-score variables

allSubData.zBorg=zscoreNan(allSubData.Borg);
allSubData.zTired=zscoreNan(allSubData.Tired);
allSubData.zConfidence=zscoreNan(allSubData.Confidence);