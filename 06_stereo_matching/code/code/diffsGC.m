function diffs = diffsGC(img1, img2, dispRange)

% get data costs for graph cut

diffs = zeros(size(img1,1),size(img1,2),size(dispRange,2));
windowsize = 3;
% change to double, because in RGB space, 255+255 = 255
img1 = double(img1);
img2 = double(img2);

box = fspecial('average', windowsize);

for d = 1:size(dispRange,2)
    img_diff = (img1 - shiftImage(img2, dispRange(d))).^2;  
    diffs(:,:,d) = conv2(img_diff, box, 'same');
end