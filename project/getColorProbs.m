function colorprobs = getColorProbs(raw, index, colors,preferences)
    hexColumns = getHexColumns(raw(:, index));

    raw(:,index) = hexColumns;
    colorprobs = zeros(1,10697);

    for i = 2 : 10697
        disp(i);
        try
            colorprobs(i) = probMaleChoosingColor(assignColor(raw{i,9},colors),preferences);
        catch exception
            raw{i,9} = '#00ACED';
            colorprobs(i) = probMaleChoosingColor(assignColor(raw{i,9},colors),preferences);
        end
    end
end