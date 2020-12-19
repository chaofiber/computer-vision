function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)


[muPos, sigmaPos] = computeMeanStd(vBoWPos);
[muNeg, sigmaNeg] = computeMeanStd(vBoWNeg);

% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words

% dimension of the histogram, need to compute probability for each element
% and multiply them according to iid assumption
K = length(histogram);
p_pos = 0;
p_neg = 0;
P_car = 0.5;
for k = 1:K
    if normpdf(histogram(k),muPos(k),sigmaPos(k))>0
        p_pos = p_pos + log(normpdf(histogram(k),muPos(k),sigmaPos(k)));
    end
    if normpdf(histogram(k),muNeg(k),sigmaNeg(k))>0
        p_neg = p_neg + log(normpdf(histogram(k),muNeg(k),sigmaNeg(k)));
    end
end
p_pos = p_pos + log(P_car);
p_neg = p_neg + log(1-P_car);
if p_pos>p_neg
    label = 1;
else
    label = 0;
end
end