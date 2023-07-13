function edgeDetector()
    Pop = geneticAlgorithm(8, 18, 50, 'coins.png');
    outputImg = fuzzySys(Pop(:, :, 1), 18, 1, 'coins.png');
    imshow(outputImg);
end