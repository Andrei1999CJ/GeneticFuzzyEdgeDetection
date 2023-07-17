# Genetic Fuzzy Edge Detection

This repository contains the of Genetic Fuzzy Edge Detection Application written in Matlab.
The application should find the best rules for Edge Detection fuzzy system using a genetic algorithm.


Fuzzy Algorithm Description

Input Variables:

This fuzzy system contains 8 input variables: Pixel1, Pixel2, Pixel3, Pixel4, Pixel6, Pixel7, Pixel8 and Pixel 9 ( a 3 x 3 window).

Every input variable contains 2 membership functions:

Black:


f(x) = 1, x ϵ [0, 50)
f(x) =  , x ϵ [50, 255]



White:


f(x) =  , x ϵ [0, 200)
f(x) = 1, x ϵ [200, 255]

![fuzzy1](https://github.com/Andrei1999CJ/GeneticFuzzyEdgeDetection/assets/86969370/69f54ce1-a48d-4d9d-86d6-ef30c93009f8)

Output Variables

This fuzzy system contains 1 output variable : Pixel5 from 3x3 window.
This output variable contains 2 membership functions:

notEdge:


f(x) =  , x ϵ [0, 178)
f(x) = 0, x ϵ [178, 255]

Edge:

f(x) = 0, x ϵ [0, 26)
f(x) =  , x ϵ [26, 255]

![fuzzy2](https://github.com/Andrei1999CJ/GeneticFuzzyEdgeDetection/assets/86969370/fcd7f30c-c7f5-40ef-a125-9f65b13dae15)

Fuzzy Rules

The best fuzzy rules are searched using a genetic algorithm.

The fitness function used in the GA compares the values obtain by the fuzzy system with the edge detector algorithm from MathWorks.

Current number of rules: 20

Architecture

![fuzzy_arch](https://github.com/Andrei1999CJ/GeneticFuzzyEdgeDetection/assets/86969370/a223a122-a11a-4742-84cb-8f3d57a30913)


Results

Image used to find the rules

![imgorg](https://github.com/Andrei1999CJ/GeneticFuzzyEdgeDetection/assets/86969370/4f502c73-c5ed-413c-aa69-3f5a962927e1)

Image with fuzzy without threshold

![ffp](https://github.com/Andrei1999CJ/GeneticFuzzyEdgeDetection/assets/86969370/f5d63395-816c-4cba-a2b6-378e2a86fb72)

Image with fuzzy with threshold

![fcp](https://github.com/Andrei1999CJ/GeneticFuzzyEdgeDetection/assets/86969370/c5a22d9a-1bf3-4703-82d5-e64a050d60ee)

More images

![to](https://github.com/Andrei1999CJ/GeneticFuzzyEdgeDetection/assets/86969370/6cc2b535-17e4-456f-bfc9-ac103f334e37)

![tfp](https://github.com/Andrei1999CJ/GeneticFuzzyEdgeDetection/assets/86969370/ad3e1209-42ea-427d-a7b5-8fc2c3510191)

![tcp](https://github.com/Andrei1999CJ/GeneticFuzzyEdgeDetection/assets/86969370/22f6f49d-eb8c-4271-a441-0e5fb8e799c9)

![ao](https://github.com/Andrei1999CJ/GeneticFuzzyEdgeDetection/assets/86969370/a93aac26-e99f-4545-920f-95773e64942e)

![afp](https://github.com/Andrei1999CJ/GeneticFuzzyEdgeDetection/assets/86969370/225a7f9e-40a9-40fa-9242-5322fd6ed521)

![acp](https://github.com/Andrei1999CJ/GeneticFuzzyEdgeDetection/assets/86969370/6121b581-dcab-4653-be69-85672cd3f6b4)

NOTE:
This project is still on going








