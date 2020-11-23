% Match descriptors.
%
% Input:
%   descr1        - k x q descriptor of first image
%   descr2        - k x q' descriptor of second image
%   matching      - matching type ('one-way', 'mutual', 'ratio')
%   
% Output:
%   matches       - 2 x m matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, matching)
    % distances(i,j) denotes the distance between i-th feature in descri1
    % and the j-th feature in descri2
    distances = ssd(descr1, descr2);
    
    if strcmp(matching, 'one-way')
        [~,idx] = min(distances,[],2);
        matches = [1:1:size(descr1,2);idx'];
    elseif strcmp(matching, 'mutual')
        [~, idx1] = min(distances,[],2);
        [~, idx2] = min(distances,[],1);
        matches = [];
        for ii=1:size(idx1)
            if idx2(idx1(ii))==ii
                matches = [matches, [ii;idx1(ii)]];
            end
        end
    elseif strcmp(matching, 'ratio')
        thresh = 0.5;
        [~,idx] = mink(distances',2);
        matches = [];
        for ii=1:size(idx,2)
            if distances(ii,idx(1,ii))<distances(ii,idx(2,ii))*thresh
                matches = [matches, [ii;idx(1,ii)]];
            end
        end
    else
        error('Unknown matching type.');
    end
end

function distances = ssd(descr1, descr2)
    distances = pdist2(descr1', descr2', 'squaredeuclidean');
end