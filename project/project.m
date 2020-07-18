% % load preferences.mat;
% % load data.mat;
% addpath('COSFIRE_Gender_recognition_1_0/Application');
% 
% regression = zeros(10697,5);
% 
% for i=2 : 10697
%     if strcmp(raw{i,1},'female')
%         regression(i,1) = 2;
%     else
%         regression(i,1) = 1;
%     end
% end
% 
% % [result ,data, kernel] = Gender_recognition_with_COSFIRE(90, './GENDER-FERET/', 1, 128);
% % imageprobs = getImageProbabilities(result.info.ErrorDistribution);
% regression(:,2) = imageprobs(:);
% 
% % linkcolorprob = getColorProbs(raw,5,colors,preferences);
% regression(:,3) = linkcolorprob(:);
% 
% % % sidecolorprob = getColorProbs(raw,11,colors,preferences);
% regression(:,4) = sidecolorprob(:);
% regression(1,:) = [];
% 
% % nameprob = getNameProb('nameprob.txt');
% regression(:,5) = nameprob(:);
% 
shuffled = regression(randperm(10696), :);
% 
B = mnrfit(shuffled(1:6000,5),shuffled(1:6000,1));
pihat = mnrval(B,shuffled(:,5));

truecount = 0;
falsecount = 0;
predict = zeros(1,10696);
for i = 6001 : 10696
    if pihat(i,1) > 0.5
        predict(i) = 1;
    else
        predict(i) = 2;
    end
    if predict(i) == shuffled(i,1)
        truecount = truecount + 1;
    else
        falsecount = falsecount + 1;
    end
end

disp(strcat('Prediction Rate: ', num2str(truecount/(truecount+falsecount))));

Y = [ truecount/(truecount+falsecount) , falsecount/(truecount+falsecount) ];
figure;
b = bar(Y);
set(gca,'XTickLabel',{'True Rate', 'False Rate'});
title('Prediction from names');
% results(count) = truecount/(truecount+falsecount);

% for i = 1 : 15
% scatter(i ,results(i),'filled','d')
% hold on
% end
% 
% legend('only image', 'only linkcolor', 'only sidecolor plot', 'only name',...
%     'image-linkcolor','image-sidebarcolor', 'image-name',...
%     'linkcolor-sidebarcolor','linkcolor-name','sidebarcolor-name',...
%     'image-linkcolor-sidebarcolor','image-linkcolor-name', 'image-sidebarcolor-name',...
%     'linkcolor-sidebarcolor-name', 'all features');
% xlabel('Features');
% ylabel('Recognition rate');
% xlim([0 20])
% 
% yy = smooth(results(1:15));
% plot(yy)
% hold on
% 
% % x = shuffled(:,2);
% % y = shuffled(:,4);
% % z = shuffled(:,5);
% % c = shuffled(:,1);
% % figure;scatter3(x,y,z,50,c);
% colormap(flag);

