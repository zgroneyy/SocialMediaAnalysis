function nameprob = getNameProb(name)
    count = 1;
    fid = fopen(strcat('C:\Users\ckaan\Desktop\cs551\project\',name,'.txt'));
    tline = fgets(fid);
    while ischar(tline)
    nameprob(count) = str2num(tline);
    disp(tline)
    tline = fgets(fid); count = count + 1;
    end
    fclose(fid);
end