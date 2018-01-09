function test_improved_space
% compare original and improved space versions of ensembles over some datasets
% used ensemble types are Random Forest and Bagging
% used base learners are decision trees
% any type of ensemble and base learner algorithms can be used with improved space by appropriate code changes
% main function: generate_imp_space

% This code includes the demonstration of the following paper. If you use this toolbox, please cite the following paper: 
% Improved Space Forest: A Meta Ensemble Method https://doi.org/10.1109/TCYB.2017.2787718
% (c) Mehmet Fatih Amasyali, 2018

rng(3); % For reproducibility
Filename_Prefix = 'arfffiles\\'; % file name includes arff files
datasets={'hillValley','audiology','segment','vehicle'}; 

% general parameters:
trainratio=0.5; % training set ratio
T=10; % ensemble size
bootstrapping_ratio=1; % # of samples in a bootstrapped training set equals to bootstrapping_ratio*train_N(# of training samples) 
ens_type='RandomForest'; 
%ens_type='Bagging';
% NumVariablesToSample: Number of predictor variables randomly selected for each split
% for Bagging, NumVariablesToSample = d (# of original features)
% for Random Forest, NumVariablesToSample = 2*log2(d) 

% improved space parameters:
foz = 4; % # of features used for generating new features
order = 2; % order of design matrix used for generating new features
imp_feature_size = 1; % # of generated features equals to imp_feature_size*d(# of original features)
            
datasetnumber=size(datasets,2);
imp_ens_acc = zeros(1,datasetnumber); % accuracies of improved version of ensembles
ens_acc = zeros(1,datasetnumber); % accuracies of original ensembles

for i=1:datasetnumber % for each dataset
    % load the data
    [samples,labels] = read_arff(sprintf('%s%s.arff',Filename_Prefix,datasets{i}));
    % construct training and test samples
    cvp = cvpartition(labels,'HoldOut',1-trainratio);
    trainind=cvp.training;
    testind=cvp.test;
    train_data = samples(trainind,:);
    test_data = samples(testind,:);
    train_labels = labels(trainind);
    test_labels = labels(testind);
    train_N = size(train_data,1); % # of training samples
    test_N = size(test_data,1); % # of test samples
    d = size(train_data,2); % # of features in original space
    imp_test_pred = zeros(test_N,T); % predictions of base learners in improved spaces
    imp_test_ens_pred = zeros(test_N,1); % predictions of ensemble in improved space
    test_pred = zeros(test_N,T); % predictions of base learners in original space
    test_ens_pred = zeros(test_N,1); % predictions of ensemble in original space
    new_foz=foz; % temp variable for foz
    if foz>d % if foz is bigger than d, assign foz to d. 
        new_foz=d;
    end
    for t = 1:T % for each base learner
        % transform training and test samples to improved space
        [imp_train_data,imp_test_data] = generate_imp_space(train_data,train_labels,test_data,imp_feature_size,new_foz,order);
        imp_d = size(imp_train_data,2); % # of features in improved space
        
        %bootstrapping
        b_ind = ceil(rand(round(train_N*bootstrapping_ratio),1)*train_N); % bootstrapping indices
        imp_btrain_data = imp_train_data(b_ind,:); % bootstrapped samples in improved space
        btrain_data = train_data(b_ind,:); % bootstrapped samples in original space
        btrain_labels = train_labels(b_ind); 
 
        % construct base learners
        % Any type of base learner (SVM, NN etc.) can be used with improved spaces.
        % Here, decision trees are used.
        if strcmp(ens_type,'RandomForest')            
            imp_sel_d=2*round(log2(imp_d)); % Random Forest
            sel_d=2*round(log2(d));
        else
            imp_sel_d=imp_d; % Bagging
            sel_d=d;
        end
        imp_baselearner = fitctree(imp_btrain_data,btrain_labels,'NumVariablesToSample',imp_sel_d);%,'Prune','off','MergeLeaves','off');
        baselearner = fitctree(btrain_data,btrain_labels,'NumVariablesToSample',sel_d);%,'Prune','off','MergeLeaves','off');
        % generate predicitions
        imp_test_pred(:,t) = predict(imp_baselearner,imp_test_data); % t.th improved base learner's predictions
        test_pred(:,t) = predict(baselearner,test_data); % t.th base learner's predictions
    end
    % generate ensemble decisions from base learner decisions
    for j=1:test_N
        [sortedElement, e_count] = elementCount(imp_test_pred(j,:)); % count votes for classes
        [~, e_ind] = max(e_count);
        imp_test_ens_pred(j) = sortedElement(e_ind); % improved ensemble decision for j.th test sample
        
        [sortedElement, e_count] = elementCount(test_pred(j,:)); % count votes for classes
        [~, e_ind] = max(e_count);
        test_ens_pred(j) = sortedElement(e_ind); % ensemble decision for j.th test sample
    end
    % calculate ensemble accuracies
    imp_ens_acc(i)=sum(test_labels(:,end)==imp_test_ens_pred)/test_N; % improved ensemble accuracy for i.th dataset
    ens_acc(i)=sum(test_labels(:,end)==test_ens_pred)/test_N; % ensemble accuracy for i.th dataset
end
disp(['improved space ' ens_type ' accuracies:' num2str(imp_ens_acc)]);
disp([ens_type ' accuracies               :' num2str(ens_acc)]);


% Copyright Mehmet Fatih Amasyali, 2018 All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.





