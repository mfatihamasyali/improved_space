function [samples,labels] = read_arff(filename)
% read arff files includes only numeric values (features and labels)
% to use categorical class labels, transform them to integers.
% (c) Mehmet Fatih Amasyali, 2018

fid = fopen(filename);
c = lower(strtrim(fgetl(fid)));
count =0;
while(isempty(strfind(c,'@data')))
        if (~isempty(strfind(c,'@attribute')))
            count=count +1;
        end
        c = lower(strtrim(fgetl(fid)));
end
a= (ones(count-1,1)*'%f ')';  formatString = [char(a(:)') ' %f'];   
in_data = textscan(fid,formatString,'delimiter', ',', 'commentStyle', '@');
M = [];
d=size(in_data,2); % # of feature 
for j=1:d
       M = [M cell2mat(in_data(j))]; 
end
samples=M(:,1:d-1);
labels=M(:,d);

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

