# Wild-Card-Toolbox
This is the first iteration of the Wild Card Twin Modeling Package and toolbox.  WARNING: This is a work in progress and documentation is poor at this stage (with more to come!).  The package automates twin analyses over large datafiles. For now, downloading the "Functions.R" script and running it will put all the necessary functions in your environment.  

Many people interested in this package are likely looking at its neuroimaging genetics applications.  I refer you to the step-by-step tutorial (https://github.com/AlexHatoum/Wild-Card-Toolbox/blob/master/Genetic_Brain_Map_Tutorial_PartA.%20R is the first script) for a run through (and example scripts) of how to run a whole-brain genetic brain-map using twins.  The software is free and open source. 

The brain mapping pipeline has four scripts

Part A: Runs vertexwise twin analysis (in parallel)

Part B: post-processes the brain data

Part C: Organizes data from R into data that can be converted to Freesurfer formats

Part D: Takes results from part C and creates .mgh freesurfer files that can be plotted in Freeview

Each script is annotated to demonstrate the process and explains explicity what parts of the script you would need to add your own data. 
