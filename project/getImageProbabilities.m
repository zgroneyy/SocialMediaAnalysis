function imageProbs = getImageProbabilities(x)
% 0 female ,1 male
    gender = zeros(1,10697);
    gender(1) = -1;
    for i=1 : 5423
        if x(i) == 0
            gender(i+1) = 0;
        else 
            gender(i+1) = 1;
        end
    end

    for i=5424 : 10696
        if x(i) == 0
            gender(i+1) = 1;
        else 
            gender(i+1) = 0;
        end
    end
    imageProbs = gender';
end