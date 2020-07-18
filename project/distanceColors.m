function distance = distanceColors(color1, color2)
    distance = sqrt( (color1(1) - color2(1)).^2 + ...
        (color1(2) - color2(2)).^2 + (color1(3) - color2(3)).^2);
end