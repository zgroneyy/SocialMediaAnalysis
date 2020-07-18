function deleted = removeInvalidProfilesParallel(raw)
    deleted = zeros(1,12895);
    tic
    parfor i = 2 : 50
        try
           if mod(i,200)==0
               disp(i);
           end
           [X, map]=imread(strcat('https://twitter.com/',raw{i,6},'/profile_image?size=original'));
        catch exception
           deleted(i) = 1;
        end
    end
    toc
end