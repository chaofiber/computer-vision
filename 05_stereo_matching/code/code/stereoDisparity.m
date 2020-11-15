function disp = stereoDisparity(img1, img2, dispRange)

% dispRange: range of possible disparity values
% --> not all values need to be checked

% input: two images (gray value: 0-255), dispRange : a vector: possible disparity values
% output: disparity map: same size as img1. For each pixel, return its
% disparity between two images (in pixel unit)

windowsize = 7;
% change to double, because in RGB space, 255+255 = 255
img1 = double(img1);
img2 = double(img2);

box = fspecial('average', windowsize);
bestDiff = 10000*ones(size(img1)); % set a large number, but Don't set inf
disp = dispRange(1)*ones(size(img1));

for d = dispRange
    % shift images: the original part would be black (no compensentation)
    img_diff = (img1 - shiftImage(img2, d)).^2;  
    ssd = conv2(img_diff, box, 'same');
    
    % for each pixel, need to memorize the best disparity --> smallest ssd
    mask = ssd < bestDiff; % 0/1 matrix
    disp = d.* mask + disp.*(1-mask); % update disparity map
    bestDiff = ssd.*mask + bestDiff.*(1-mask);
end
end