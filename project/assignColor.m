function assignIndex = assignColor(hex,colors)
    dist = zeros(1,12);
    
    for t = 1 : 12
        dist(1,t) = distanceColors(colors(t,:), hex2lab(hex));
    end
    [~, assignIndex] = min(dist);
end