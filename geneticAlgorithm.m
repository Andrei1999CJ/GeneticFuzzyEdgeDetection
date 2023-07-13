function Pop = geneticAlgorithm(populationSize, numberOfRules, numberOfGenerations, imageUrl)
    numberOfGenesAndOutput = 9;
    imageResize = 0.1;
    newPop = zeros(numberOfRules, numberOfGenesAndOutput, populationSize);
    resetCounter = 0;
    oldScor = 0;
    crossovers = 9;
    Pop = generatePopulation(numberOfRules, numberOfGenesAndOutput, populationSize);
    for generation = 1 : numberOfGenerations
        fprintf(1, 'Generatia: %d\n', generation);
        imageResize = resizeImageAtEveryXGenerations(generation, 10, imageResize);
        [score, dimensiune] = fitness(Pop, populationSize, numberOfRules, imageResize, imageUrl);
        [score, position] = sort(score, 'descend');
        Pop = sortPopByPosition(Pop, position);
        fprintf(1, 'Best individual score: %d\n', score(1));
        fprintf(1, 'The individual: \n');
        consolePrintBestIndividual(Pop, numberOfRules, numberOfGenesAndOutput);
        writeBestIndividualToFile('Best Individual.txt', Pop, numberOfRules, numberOfGenesAndOutput);
        sumScor = sumMatr(score);
        newPop(:, :, 1) = Pop(:, :, 1);
        newPop = applyCrossoverOperations(Pop, newPop, crossovers, score, sumScor);
        newPop = applyMutationOperations(Pop, newPop, crossovers + 1, populationSize, score, sumScor);
        Pop = newPop;
        resetPopulation(Pop, 50, oldScor, score(1), resetCounter, populationSize);
        oldScor = score(1);
        valMax = dimensiune(1, 1) * dimensiune(1,2);
        fprintf(1, 'Rata success: %g%%\n', (score(1) / valMax) * 100 );
    end
end

function individ = genIndivid(numberOfRules, numberOfGenesAndOutput)
    individ = zeros(numberOfRules, numberOfGenesAndOutput);
    individ(1, :) = genRule();
    for i = 2 : numberOfRules
        isDif = false;
        while(~isDif)
            individ(i, :) = genRule();
            for j = 1 : i - 1
                isDif = compareRules(individ(i, :), individ(j, :));
            end
        end
    end
end

function imageResize = resizeImageAtEveryXGenerations(generation, numberOfGenerations, imageResize)
    if mod(generation, numberOfGenerations) == 0
            imageResize = imageResize + 0.05;
            fprintf(1, "imageResize: %g\n",imageResize );
    end
end

function writeBestIndividualToFile(filename, Pop, numberOfRules, numberOfGenesAndOutput)
    fileID = fopen(filename,'w');
    for l = 1 : numberOfRules
        for k = 1 : numberOfGenesAndOutput
            fprintf(fileID, '%d ', Pop(l, k, 1));
        end
        fprintf(fileID, '\n');
    end
end

function Pop = generatePopulation(numberOfRules, numberOfGenesAndOutput, populationSize)
    Pop(:, :, 1) = genIndivid(numberOfRules, numberOfGenesAndOutput);
    for i = 2 : populationSize
        isDif = false;
        while(~isDif)
            Pop(:, :, i) = genIndivid(numberOfRules, numberOfGenesAndOutput);
            for j = 1 : i - 1
                isDif = compareIndivid(Pop(:, : ,i), Pop(:, :, j));
            end
        end
        Pop(:, :, i) = verifyIndivid(Pop(:, :, i));

    end
end

function newIndivid = verifyIndivid(individ)
    dimen = size(individ);
    for j = 1 : dimen(1, 2)
        for i = 1 : dimen(1, 1) - 1
            if individ(i, j) == individ(i + 1, j)
                same = 1;
            else
                same = 0;
            end
        end
        if same == 1
            individ(dimen(1, 1), j) = (~(individ(dimen(1, 1), j) - 1)) + 1;
        end
    end
    newIndivid = individ;
end

function rule = genRule()
    rule = [rand rand rand rand rand rand rand rand randi([1 2])];
    for i = 1 : 8
        if rule(i) <= 0.5
           rule(i) = 1;
        else
            if rule(i) > 0.5
                rule(i) = 2;
            end
        end
    end
end

function isDif = compareRules(vect1, vect2)
    isDif = true;
    if vect1(:) == vect2(:)
        isDif = false;
    end
end

function isDif = compareIndivid(vect1, vect2)
    isDif = true;
    if vect1(:,:) == vect2(:,:)
        isDif = false;
    end
end

function [scor, dimen] = fitness(Pop, numberOfPop, numberOfRules, imageResize, imageUrl)
    A = imread(imageUrl);
    if ndims(A) == 3
        A = rgb2gray(A);
    end
    Img = imresize(A, imageResize);
    dimen = size(Img);
    Img = im2double(Img);
     scor = zeros(1, numberOfPop);
    Gx = [-1 1];
    Gy = Gx';
    Ix = conv2(double(Img),Gx,'same');
    Iy = conv2(double(Img),Gy,'same');
    for i = 1 : numberOfPop
        z = 0;
        try
        outImg = fuzzySys(Pop(:, :, i), numberOfRules, imageResize, imageUrl);
        outImg2 = im2double(outImg);
        for j = 1: dimen(1, 1)
            for k = 1 : dimen(1, 2)
                if (Ix(j, k) <= -0.1 || Ix(j, k) >= 0.1) && (Iy(j, k) <= -0.1 || Iy(j, k) >=0.1)
                    if outImg2(j , k) >= 0.5
                        scor(i) = scor(i)+ 1;
                    end
                else
                    if (Ix(j, k) >= -0.1 && Ix(j, k) <= 0.1) && (Iy(j, k) >= -0.1 && Iy(j, k) <=0.1)
                        if outImg2(j, k) < 0.5
                        scor(i) = scor(i)+ 1;
                        end
                    end
                end
            end
        end
        catch
            z = z + 1;
            scor(i) = 1;
        end
     end
    
end

function suma = sumMatr(mat)
    dimen = size(mat);
    suma = 0;
    suma = double(suma);
    rowleng = dimen(1, 1);
    colleng = dimen(1, 2);
    for i = 1 : rowleng
        for j = 1 : colleng
            suma = suma + double(abs(mat(i, j)));
        end
    end
end

function consolePrintBestIndividual(Pop, numberOfRules, numberOfGenesAndOutput)
    for l = 1 : numberOfRules
        for k = 1 : numberOfGenesAndOutput
            fprintf(1, '%d ', Pop(l, k, 1));
        end
        fprintf(1, '\n');
    end
end

function newPop = sortPopByPosition(Pop, poz)
    newPop = Pop;
    dimen = size(poz);
    leng = dimen(1, 2);
    for i = 1 : leng
        newPop(:, :, i) = Pop(:, :, poz(i));
    end
end


function index = ruleta(scor, sumScor)
    rnd = rand();
    dimen = size(scor);
    idx = randi([2 dimen(1, 2)],1,1);
    if (abs(scor(idx)) / sumScor) >= rnd
        index = idx;
    else
        index = -1;
    end
end

function c = mutation(p)
    dimen = size(p);
    c = p;
    rowleng = dimen(1, 1);
    colleng = dimen(1, 2);
    for i = 1 : randi([1 rowleng])
        poz = randi([1 colleng]);
        c(i, poz) = (abs((c(i, poz) - 1) - 1)) + 1;
    end
end

function newPop = applyCrossoverOperations(Pop, newPop, numberOfCrossOvers, score, sumScor)
    for i = 2 : 2 : numberOfCrossOvers
        index1 = ruleta(score, sumScor);
        while(index1 == -1)
            index1 = ruleta(score, sumScor);
        end
        index2 = ruleta(score, sumScor);
        while(index2 == -1)
            index2 = ruleta(score, sumScor);
        end
        [newPop(:, :, i), newPop(:, :, i + 1)] = crossover(Pop(:, :, index1), Pop(:, :, index2));
    end
end

function newPop = applyMutationOperations(Pop, newPop, startIndex, lastIndex, score, sumScor)
    for i = startIndex : lastIndex
        index = ruleta(score, sumScor);
        while(index == -1)
            index = ruleta(score, sumScor);
        end
        newPop(:, :, i) = mutation(Pop(:, :, index));
    end
end

function [Pop, resetCounter] = resetPopulation(Pop, resetThreshold, oldScore, bestScore, resetCounter, populationSize)
    if(oldScore == bestScore)
        resetCounter = resetCounter + 1;
    else
        resetCounter = 0;
    end
    if resetCounter >= resetThreshold
        for i = 2 : populationSize
            isDif = false;
            while(~isDif)
                Pop(:, :, i) = genIndivid(numberOfRules);
                for j = 1 : i - 1
                    isDif = compareIndivid(Pop(:, : ,i), Pop(:, :, j));
                end
            end
        end
        resetCounter = 0;
    end
end


function [c1, c2] = crossover(p1, p2)
    c1 = p2;
    c2 = p1;
    dimen = size(p1);
    poz = randi([2 (dimen(1, 1) - 1)]);
    c1(1 : poz, :) = p1(1 : poz, :);
    c2((poz + 1) : dimen(1, 1), :) = p2((poz + 1) : dimen(1, 1), :);
end