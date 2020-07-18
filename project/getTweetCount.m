function data = getTweetCount(index, raw)

    tweetCount = raw( : , [1 2 index] );
    data = zeros(20051 , 2);
    for i = 2 : 10697
        C = strsplit(tweetCount{i,2},'/');
        x = strsplit(C{1,3},' ');
        date(1) = C(1,1);
        date(2) = C(1,2);
        date(3) = x(1,1);
        A = str2double(date);
        day = A(3)*365 + A(2) + A(1)*30;
        now = 16*365 + 11*30 + 26;
        

        if isequal(tweetCount{i,1},'male')
            data(i,1)=1;
        elseif isequal(tweetCount{i,1},'female')
            data(i,1)=2;
        else
            data(i,1)=3;
        end
        data(i,2) = tweetCount{i,3} /(now - day);
    end
end