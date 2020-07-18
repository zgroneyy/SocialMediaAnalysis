function colorchoices = getHexColumns(colorchoices)
    for i = 2 : 10697
        if isnumeric(colorchoices{i})
            colorchoices{i} = num2str(colorchoices{i});
        end

        [m,n] = size(colorchoices{i});
        str = colorchoices{i};
        while n<6
            str = strcat(num2str(0),str);
            [m,n] = size(str);
        end
        colorchoices{i} = strcat('#',str);
    end
end