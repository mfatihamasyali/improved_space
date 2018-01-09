function [imp_train_data,imp_test_data] = generate_imp_space(Trdata,Trlabels,Tsdata,imp_feature_size,foz,order)
% generate improved space 
% (c) Mehmet Fatih Amasyali, 2018

% inputs: 
% Trdata: training samples
% Trlabels: training labels
% Tsdata: test samples
% imp_feature_size: % # of generated features equals to imp_feature_size*d(# of original features)
% foz: # of features used for generating new features
% order: order of design matrix used for generating new features

% outputs: 
% imp_train_data: training samples in improved space
% imp_test_data: test samples in improved space
% the first d features is the original features, the rest is improved ones

num_class = size(unique(Trlabels),1);
d=size(Trdata,2); % # of original features

imp_train_data=Trdata; % initialize improved space with original features 
imp_test_data=Tsdata;
for i=1:imp_feature_size*foz  % imp_feature_size*foz times 
    Xindis=randperm(d); % generate a random sequence of feature indices
    for j=1:foz:d-(foz-1) % at each iteration, adds d/foz new features
        sX=randperm(num_class); % for datasets having more than two classes, create two super sets by 1 vs. all approach
        s1=sX(1);
        s1data=Trdata((Trlabels==s1),Xindis(j:j+(foz-1))); % get samples from s1 class 
        s2data=Trdata((Trlabels~=s1),Xindis(j:j+(foz-1))); % get samples from all other classes
        s1label=ones(size(s1data,1),1);
        s2label=-1*ones(size(s2data,1),1);
        Wdata=[s1data;s2data]; 
        Wdata=xnfx(Wdata,order);    
        Wlabel=[s1label;s2label];
        W=pinv(Wdata'*Wdata)*Wdata'*Wlabel; % calculate transformatino matrix
        
        WW=xnfx(Trdata(:,Xindis(j:j+foz-1)),order);
        imp_train_data=[imp_train_data WW*W]; % add new feature (WW*W)
        TT=xnfx(Tsdata(:,Xindis(j:j+foz-1)),order);
        imp_test_data=[imp_test_data TT*W]; % add new feature (TT*W)
    end
end

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
