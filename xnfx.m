function d = xnfx(x,order)
%XNFX   An extension to X2FX which can convert predictors to design matrix
%       to higher order (equal or lower than dimension of x).
%
%   x2fx can only generate predictor matrix of at most second order, while 
%   xnfx allows the generation of any higher order of predictor matrix.
%
%   d = xnfx(x,order) converts a matrix of predictors X to a design 
%   matrix d for regression analysis. Distinct predictor variables 
%   should appear in different columns of X. 
%
%   If X has n columns, the order of the columns of D for a full ordered
%   model is:
%
%     1.  The constant term
%     2.  The linear terms (the columns of X, in order 1,2,...,n)
%     3.  The interaction terms in 2nd order (1,2), (1,3), ..., (1,n)
%                                            (2,3), (2,4), ..., (n-1,n)
%     4.  The power terms in 2nd order (1^2), (2^2), ..., (n^2)
%     5.  The interaction terms in 3nd order (1,2,3), (1,2,4), ...
%                                                           (n-2,n-1,n)
%     6.  The power terms in 3rd order (1^3), (2^3), (3^3), ..., (n^3)
%     7.  The interaction terms in 4th order (1,2,3,4),...
%     ...
%     8.  Higher power and interaction terms...
%
%   Example 3rd order predictor matrix of X:
%     X = [1 10 5     D = [1 1 10 5 10  5  50  1 100 25  50   1 1000 125
%          2 20 6          1 2 20 6 40 12 120  4 400 36 240   8 8000 216
%          3 10 7          1 3 10 7 30 21  70  9 100 49 210  27 1000 343
%          4 20 1          1 4 20 1 80  4  20 16 400  1  80  64 8000   1
%          5 15 2          1 5 15 2 75 10  30 25 225  4 150 125 3375   8
%          6 15 3]         1 6 15 3 90 18  45 36 225  9 270 216 3375  27]
%   Let A, B, C represent the two columns of X.  The rows of the MODEL
%   matrix specify the terms 1, A, B, C, A.*B, A.*C, B.*C, A.^2, B.^2,...
%                                       C.^2,...,A*B*C,  A^3, B^3, C^3. 
%
%   XNFX is a utility used by a variety of other functions, such
%   as RSTOOL, REGSTATS, CANDEXCH, CANDGEN, CORDEXCH, and ROWEXCH.
%
%(c) Ieong Wong, 2012

[xn,xd] = size(x);
d=ones(xn,1);
if order>xd
    d = 'Order cannot be higher than dimension';
else
    for i=1:order
        c=combnk(1:xd,i);
        if c(1,1)~=1 
            c=flipud(c); 
        end
        [cn,cd]=size(c);
        x_r=[];
        for j=1:cn
            x_app=ones(xn,1);
            for k=1:cd
                x_app=x_app.*x(:,c(j,k));
            end
        x_r=[x_r x_app];        
        end
        if i>1 
            x_r=[x_r x.^i]; 
        end
    d=[d x_r];
    end
end

% Copyright (c) 2012, Ieong Wong All rights reserved.
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