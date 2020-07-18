function lab = hex2lab(hex)
    rgb = hex2rgb(hex,256);
    lab = rgb2lab(rgb);
end