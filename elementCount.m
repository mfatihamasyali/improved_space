function [sortedElement, count] = elementCount(in)
%elementCount: Count elements in a vector.
%	Usage: [sortedElement, count] = elementCount(in)

%	Type "elementCount" for a self demo.

%	Roger Jang, 19970327, 20040928

if nargin==0, selfdemo; return, end

[m,n] = size(in);
in1 = sort(in);
in1(end+1)=in1(end)+1;
index = find(diff(in1) ~= 0);
sortedElement = in1(index);
if n==1
	count = diff([0; index]);
else
	count = diff([0, index]);
end

% ====== Self demo ======
function selfdemo
in = [5 1 5 5 7 9 9];
fprintf('in = %s\n', mat2str(in));
fprintf('"[sortedElement, count] = elementCount(in)" produces the following output:\n');
[sortedElement, count] = elementCount(in);
fprintf('sortedElement = %s\n', mat2str(sortedElement));
fprintf('count = %s\n', mat2str(count));