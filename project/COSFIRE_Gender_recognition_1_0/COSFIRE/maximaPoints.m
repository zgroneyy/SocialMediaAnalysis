function detectionList = maximaPoints(inputImage,output,mindistance,show)

% Detect local maxima points
maxoutput = zeros(size(inputImage));
pointlocation = [];
for n = 1:length(output)
    if any(output{n}(:))
        [row col] = find(imregionalmax(output{n}));
        pointlocation = [pointlocation; [row col]];
        maxoutput = max(maxoutput,output{n});
    end
end

if size(pointlocation,1) == 1
    detectionList = pointlocation;
else
    d = pdist(pointlocation);
    z = linkage(d,'complete');
    c = cluster(z,'cutoff',mindistance,'criterion','distance');
    m = max(c(:));

    detectionList = zeros(m,2);
    for i = 1:m
        f = find(c == i);
        index = sub2ind(size(inputImage),pointlocation(f,1),pointlocation(f,2));
        [mx, ind] = max(maxoutput(index));
        detectionList(i,:) = pointlocation(f(ind),:);
    end
end

if show == 1
    imagesc(inputImage);colormap(gray);axis equal;axis off;hold on;
    plot(detectionList(:,2),detectionList(:,1),'r.','markersize',20);
end
