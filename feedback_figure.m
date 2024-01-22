function feedback_figure(outcome,lmm, data, main_covariate)
    prevData = data;
    prevDataNew = table();
    
    if strcmp(main_covariate, 'Grip Force')
        % Grip Force
        prevDataNew.zAbsEffort = linspace(nanmin(data.zAbsEffort), nanmax(data.zAbsEffort))';
        % Covariates
        prevDataNew.zTrialNum_Session = (0*ones(1,height(prevDataNew)))';

        if strcmp(outcome, 'Fatigue')
            prevDataNew.zBorg = (0*ones(1,height(prevDataNew)))';
            prevDataNew.zConfidence = (0*ones(1,height(prevDataNew)))';
        elseif strcmp(outcome, 'Perceived Exertion')
            prevDataNew.zTired = (0*ones(1,height(prevDataNew)))';
            prevDataNew.zConfidence = (0*ones(1,height(prevDataNew)))';
        elseif strcmp(outcome, 'Confidence')
            prevDataNew.zBorg = (0*ones(1,height(prevDataNew)))';
            prevDataNew.zTired = (0*ones(1,height(prevDataNew)))';
        end

        % Negative feedback first
        prevDataNew.FeedbackCondition = categorical(1*ones(1,height(prevDataNew))');
        prevDataNew.SubID = repmat(prevData.SubID(1),height(prevDataNew),1);
        [ypred_marg,yCIpred_marg] = predict(lmm,prevDataNew,...
            'Conditional',false,'DFmethod','satterthwaite');

        figure();
        shadedErrorBar(prevDataNew.zAbsEffort,ypred_marg,yCIpred_marg(:,2)-ypred_marg,'lineprops',{'r','LineWidth', 3});
        hold on

        % Positive Feedback
        prevDataNew.FeedbackCondition = categorical(0*ones(1,height(prevDataNew))');
        [ypred_marg,yCIpred_marg] = predict(lmm,prevDataNew,...
            'Conditional',false,'DFmethod','satterthwaite');
        shadedErrorBar(prevDataNew.zAbsEffort,ypred_marg,yCIpred_marg(:,2)-ypred_marg,'lineprops',{'g','LineWidth', 3});
        hold on

        % Make the plots pretty
        set(gca, 'FontSize', 12) % bigger font size
        hold on
        ylabel(outcome, 'FontSize', 14)
        hold on
        xlabel('Grip Force (z-scored)', 'FontSize', 14)
        set(gca,'TickDir','out');
        box off
        % h = findobj(gca,'Type','line');
        % lgd = legend([h(1), h(4)],{'Positive','Negative'});
        % fontsize(lgd,14,'points')
        filename = strcat(outcome,'GripForce','.png');
        saveas(gcf,filename)
%        hold on
%        h = findobj(gca,'Type','line');
%        legend([h(1), h(4)],{'Positive','Negative'});
    elseif strcmp(main_covariate, 'Time')   
         % Time
         prevDataNew.zTrialNum_Session = linspace(nanmin(data.zTrialNum_Session), nanmax(data.zTrialNum_Session))';
         % Covariates
         prevDataNew.zAbsEffort = (0*ones(1,height(prevDataNew)))';
         
         if strcmp(outcome, 'Fatigue')
            prevDataNew.zBorg = (0*ones(1,height(prevDataNew)))';
            prevDataNew.zConfidence = (0*ones(1,height(prevDataNew)))';
        elseif strcmp(outcome, 'Perceived Exertion')
            prevDataNew.zTired = (0*ones(1,height(prevDataNew)))';
            prevDataNew.zConfidence = (0*ones(1,height(prevDataNew)))';
        elseif strcmp(outcome, 'Confidence')
            prevDataNew.zBorg = (0*ones(1,height(prevDataNew)))';
            prevDataNew.zTired = (0*ones(1,height(prevDataNew)))';
        elseif strcmp(outcome, 'Grip Force')
            prevDataNew.zCenterBox = (0*ones(1,height(prevDataNew)))';
        end

         % Negative feedback first
         prevDataNew.FeedbackCondition = categorical(1*ones(1,height(prevDataNew))');
         prevDataNew.SubID = repmat(prevData.SubID(1),height(prevDataNew),1);
         
         [ypred_marg,yCIpred_marg] = predict(lmm,prevDataNew,...
             'Conditional',false,'DFmethod','satterthwaite');
 
         figure();

         shadedErrorBar(prevDataNew.zTrialNum_Session,ypred_marg,yCIpred_marg(:,2)-ypred_marg,'lineprops',{'r','LineWidth', 3});

         hold on
 
         % Positive Feedback
         prevDataNew.FeedbackCondition = categorical(0*ones(1,height(prevDataNew))');
         [ypred_marg,yCIpred_marg] = predict(lmm,prevDataNew,...
             'Conditional',false,'DFmethod','satterthwaite');
             
         shadedErrorBar(prevDataNew.zTrialNum_Session,ypred_marg,yCIpred_marg(:,2)-ypred_marg,'lineprops',{'g','LineWidth', 3});
         hold on
         
         % Make the plots pretty
         set(gca, 'FontSize', 12) % bigger font size
         hold on
         ylabel(outcome, 'FontSize', 14)
         hold on
         xlabel('Trial (z-scored)', 'FontSize', 14)
         set(gca,'TickDir','out');
         box off
        %  h = findobj(gca,'Type','line');
        %  lgd = legend([h(1), h(4)],{'Positive','Negative'});
        %  fontsize(lgd,14,'points')
         filename = strcat(outcome,'Trial','.png');
         saveas(gcf,filename)
%         hold on
%         h = findobj(gca,'Type','line');
%         legend([h(1), h(4)],{'Positive','Negative'});
    elseif strcmp(main_covariate,'Cumulative Feedback')
        prevDataNew.CumulativeFeedback = linspace(nanmin(data.CumulativeFeedback), nanmax(data.CumulativeFeedback))';
        % Negative feedback first
        prevDataNew.FeedbackCondition = categorical(1*ones(1,height(prevDataNew))');
        prevDataNew.SubID = repmat(prevData.SubID(1),height(prevDataNew),1);
        
        [ypred_marg,yCIpred_marg] = predict(lmm,prevDataNew,...
            'Conditional',false,'DFmethod','satterthwaite');

        figure();

        shadedErrorBar(prevDataNew.CumulativeFeedback,ypred_marg,yCIpred_marg(:,2)-ypred_marg,'lineprops',{'r','LineWidth', 3});

        hold on

        % Positive Feedback
        prevDataNew.FeedbackCondition = categorical(0*ones(1,height(prevDataNew))');
        [ypred_marg,yCIpred_marg] = predict(lmm,prevDataNew,...
            'Conditional',false,'DFmethod','satterthwaite');
            
        shadedErrorBar(prevDataNew.CumulativeFeedback,ypred_marg,yCIpred_marg(:,2)-ypred_marg,'lineprops',{'g','LineWidth', 3});
        hold on
        
        % Make the plots pretty
        set(gca, 'FontSize', 12) % bigger font size
        hold on
        ylabel(outcome, 'FontSize', 14)
        hold on
        xlabel('Cumulative Feedback', 'FontSize', 14)
        set(gca,'TickDir','out');
        % hold on
        box off
        % h = findobj(gca,'Type','line');
        % lgd = legend([h(1), h(4)],{'Positive','Negative'});
        % fontsize(lgd,14,'points')
        filename = strcat(outcome,'CumulativeFeedback','.png');
        saveas(gcf,filename)
    else
        % Difficulty
        prevDataNew.zCenterBox = linspace(nanmin(data.zCenterBox), nanmax(data.zCenterBox))';
        % Covariates
        prevDataNew.zTrialNum_Session = (0*ones(1,height(prevDataNew)))';
        
        if strcmp(outcome, 'Fatigue')
            prevDataNew.zBorg = (0*ones(1,height(prevDataNew)))';
            prevDataNew.zConfidence = (0*ones(1,height(prevDataNew)))';
        elseif strcmp(outcome, 'Perceived Exertion')
            prevDataNew.zTired = (0*ones(1,height(prevDataNew)))';
            prevDataNew.zConfidence = (0*ones(1,height(prevDataNew)))';
        elseif strcmp(outcome, 'Confidence')
            prevDataNew.zBorg = (0*ones(1,height(prevDataNew)))';
            prevDataNew.zTired = (0*ones(1,height(prevDataNew)))';
        end

        % Negative feedback first
        prevDataNew.FeedbackCondition = categorical(1*ones(1,height(prevDataNew))');
        prevDataNew.SubID = repmat(prevData.SubID(1),height(prevDataNew),1);
        
        [ypred_marg,yCIpred_marg] = predict(lmm,prevDataNew,...
            'Conditional',false,'DFmethod','satterthwaite');

        figure();

        shadedErrorBar(prevDataNew.zCenterBox,ypred_marg,yCIpred_marg(:,2)-ypred_marg,'lineprops',{'r','LineWidth', 3});

        hold on

        % Positive Feedback
        prevDataNew.FeedbackCondition = categorical(0*ones(1,height(prevDataNew))');
        [ypred_marg,yCIpred_marg] = predict(lmm,prevDataNew,...
            'Conditional',false,'DFmethod','satterthwaite');
            
        shadedErrorBar(prevDataNew.zCenterBox,ypred_marg,yCIpred_marg(:,2)-ypred_marg,'lineprops',{'g','LineWidth', 3});
        hold on
        
        % Make the plots pretty
        set(gca, 'FontSize', 12) % bigger font size
        hold on
        ylabel(outcome, 'FontSize', 14)
        hold on
        xlabel('Effort Demands (z-scored)', 'FontSize', 14)
        set(gca,'TickDir','out');
        box off
        h = findobj(gca,'Type','line');
        lgd = legend([h(1), h(4)],{'Positive','Negative'}, 'Location', 'northwest');
        fontsize(lgd,14,'points')
        filename = strcat(outcome,'EffortDemands','.png');
        saveas(gcf,filename)
%         hold on
%         h = findobj(gca,'Type','line');
%         legend([h(1), h(4)],{'Positive','Negative'});
    end 