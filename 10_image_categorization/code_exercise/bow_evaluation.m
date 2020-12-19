%
% BAG OF WORDS RECOGNITION EXERCISE
% Alex Mansfield and Bogdan Alexe, HS 2011
% Denys Rozumnyi, HS 2019

%training
disp('creating codebook');
sizeCodebook_list = [200];
% sizeCodebook_list = [10,25,50,75,100,125,150,175,200,225,250,275,300];
num_iter = 1;
matrix_acc_nn = zeros(length(sizeCodebook_list),num_iter);
matrix_acc_bay = zeros(length(sizeCodebook_list),num_iter);

for i = 1:length(sizeCodebook_list)
    disp(['processing: ',num2str(i),' out of ',num2str(length(sizeCodebook_list))]);
    for iter = 1:num_iter
        sizeCodebook = sizeCodebook_list(i);
        vCenters = create_codebook('../data/cars-training-pos','../data/cars-training-neg',sizeCodebook);
%         vCenters = create_codebook('../my_data/jump-training','../my_data/wave-training',sizeCodebook);
        %keyboard;
        disp('processing positve training images');
        vBoWPos = create_bow_histograms('../data/cars-training-pos',vCenters);
%         vBoWPos = create_bow_histograms('../my_data/jump-training',vCenters);
        disp('processing negative training images');
        vBoWNeg = create_bow_histograms('../data/cars-training-neg',vCenters);
%         vBoWNeg = create_bow_histograms('../my_data/wave-training',vCenters);
        %vBoWPos_test = vBoWPos;
        %vBoWNeg_test = vBoWNeg;
        %keyboard;
        disp('processing positve testing images');
        vBoWPos_test = create_bow_histograms('../data/cars-testing-pos',vCenters);
%         vBoWPos_test = create_bow_histograms('../my_data/jump-testing',vCenters);
        disp('processing negative testing images');
        vBoWNeg_test = create_bow_histograms('../data/cars-testing-neg',vCenters);
%         vBoWNeg_test = create_bow_histograms('../my_data/wave-testing',vCenters);

        nrPos = size(vBoWPos_test,1);
        nrNeg = size(vBoWNeg_test,1);

        test_histograms = [vBoWPos_test;vBoWNeg_test];
        labels = [ones(nrPos,1);zeros(nrNeg,1)];
    
        disp('______________________________________')
        disp('Nearest Neighbor classifier')
        acc_nn = bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_nearest);
        disp('______________________________________')
        disp('Bayesian classifier')
        acc_bay = bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_bayes);
        disp('______________________________________')

        matrix_acc_nn(i, iter) = acc_nn;
        matrix_acc_bay(i, iter) = acc_bay;
    end

end

%% plotting
% close all;
Myblue= 1/255*[102,102, 255];
Mygreen = 1/255*[76,153,0];
Myred = 1/255*[255,0,127];
figure(100);
boxplot(matrix_acc_nn','Label',{sizeCodebook_list},'boxstyle', 'filled', 'colors',Myred); hold on;
boxplot(matrix_acc_bay','Label',{sizeCodebook_list},'boxstyle', 'filled','colors',Mygreen); hold on;
plot(1:length(sizeCodebook_list),mean(matrix_acc_nn,2),'color',Myred,'linewidth',1); hold on;
plot(1:length(sizeCodebook_list),mean(matrix_acc_bay,2),'color',Mygreen,'linewidth',1); hold on;
xlabel('CodeBook size k');
ylabel('Accuracy [%]')
legend('Accuracy for Nearest Neighbor Classification',...
       'Accuracy for Bayes Classification', 'Location','southeast');