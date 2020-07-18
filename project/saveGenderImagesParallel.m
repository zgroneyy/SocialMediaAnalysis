function saveGenderImagesParallel( raw )
    tic
    parfor i = 2 : 10697
        try
           if mod(i,200)==0
               disp(i);
           end
           [X, map]=imread(strcat('https://twitter.com/',raw{i,6},'/profile_image?size=original'));
           if i<5425  %þu sayý dýþýnda doðru
               imwrite(X,strcat('female/',num2str(i),'.jpg'));
           else
               imwrite(X,strcat('male/',num2str(i),'.jpg'));
           end
        catch exception
           x = x + 1;
        end
    end
    toc
end