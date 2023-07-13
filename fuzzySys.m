function outputImg = fuzzySys(individ, numberOfRules, imageResize, imageUrl)
    ruleList = createRuleList(individ, numberOfRules);
    geneticFuzzy = mamfis("Name", "geneticFuzzy");
    geneticFuzzy = addInputVariables(geneticFuzzy);
    geneticFuzzy = addOutputVariable(geneticFuzzy);
    geneticFuzzy = addRule(geneticFuzzy, ruleList);
    writeFIS(geneticFuzzy, 'Test');
    inputImage = readImage(imageResize, imageUrl);
    outputImg = applyFuzzyOnImage(geneticFuzzy, inputImage);
end

function ruleList = createRuleList(individ, numberOfRules)
    ruleProp = ones(numberOfRules, 2);
    ruleList = [individ ruleProp];
    ruleList = [ruleList ;[1 1 1 1 1 1 1 1 1 1 1]];
    ruleList = [ruleList ;[2 2 2 2 2 2 2 2 1 1 1]];
end

function fuzzySystem = addInputVariables(fuzzySystem)
    % Add Pixel 1 - 4 as input variables
    for i = 1 : 4
        fuzzySystem = addFuzzyVar(fuzzySystem, 'input', addIndexToName(i, "Pixel"));
        fuzzySystem = addMF(fuzzySystem, addIndexToName(i, "Pixel"), 'trapmf', [0 0 50 255],"Name","Black");
        fuzzySystem = addMF(fuzzySystem, addIndexToName(i, "Pixel"), 'trapmf', [0 200 255 255],"Name","White");
    end
    % Add Pixel 6 - 9 as input variables
    for i = 6 : 9
        fuzzySystem = addFuzzyVar(fuzzySystem, 'input', addIndexToName(i, "Pixel"));
        fuzzySystem = addMF(fuzzySystem, addIndexToName(i, "Pixel"), 'trapmf', [0 0 50 255],"Name","Black");
        fuzzySystem = addMF(fuzzySystem, addIndexToName(i, "Pixel"), 'trapmf', [0 200 255 255],"Name","White");
    end
end

function fuzzySystem = addOutputVariable(fuzzySystem)
    %Add Pixel 5 as output variable
    fuzzySystem = addFuzzyVar(fuzzySystem, 'output', addIndexToName(5, "Pixel"));
    fuzzySystem = addMF(fuzzySystem, addIndexToName(5, "Pixel"), 'trimf', [0 0 178], "Name", "notEdge");
    fuzzySystem = addMF(fuzzySystem, addIndexToName(5, "Pixel"), 'trimf', [26 255 255], "Name", "Edge");
end

function nameWithIndex = addIndexToName(index, name)
    indexToChar = char('0' + index);
    nameWithIndex = strcat(name, indexToChar);
end

function fuzzySystem = addFuzzyVar(fuzzySystem, varType, varName)
    if varType == "input"
        fuzzySystem = addInput(fuzzySystem, [0 255], Name = varName);
    else
        fuzzySystem = addOutput(fuzzySystem, [0 255], Name = varName);
    end
end

function Img = readImage(imageResize, imageUrl)
    A = imread(imageUrl);
    if ndims(A) == 3
        A = rgb2gray(A);
    end
    Img = imresize(A, imageResize);
end

function outputImg = applyFuzzyOnImage(fuzzySystem, inputImg)
    input = zeros(1,8);
    dimen = size(inputImg);
    rowleng = dimen(1, 1);
    colleng = dimen(1, 2);
    outputImg = uint8(zeros(rowleng, colleng));
    for i = 3 : rowleng
        for j = 3 : colleng
            input(1) = inputImg(i - 2, j - 2);
            input(2) = inputImg(i - 2, j - 1);
            input(3) = inputImg(i - 2, j);
            input(4) = inputImg(i - 1, j - 2);
            input(5) = inputImg(i - 1, j);
            input(6) = inputImg(i, j - 2);
            input(7) = inputImg(i, j - 1);
            input(8) = inputImg(i, j);
            % treat no rules fired warning as error in order to catch it
            warning('error', 'fuzzy:general:warnEvalfis_NoRuleFired');
            try
            outputImg(i - 1, j - 1) = evalfis(fuzzySystem ,double(input));
            catch
                error("No rules fired => output is 127.5");
            end
        end
    end
end


