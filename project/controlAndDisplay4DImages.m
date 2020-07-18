function controlAndDisplay4DImages(c)
    data = zeros(5422,1);
    for i = 1 : 5422
        X = strsplit(c{i},'.');
        data(i) = str2double(X{1});
    end
    fark = 1;
    for i = 1 : 5268
        if data(i) ~= i + fark
            fark = fark +1;
            disp(data(i)-1);
        end
    end
end