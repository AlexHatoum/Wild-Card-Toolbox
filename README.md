# Wild-Card-Toolbox
This is the first iteration of the Wild Card Twin Modeling Package and toolbox.  The package automates twin analyses over large datafiles. For now, downloading the "Functions.R" script and running it will put all the necessary functions in your environment. 

Many people interested in this package are likely looking at its neuroimaging genetics applications.  If you follow along with the tutorial part part A through D you will get  a run through (and example scripts) of how to run a whole-brain high-resolution genetic brain-map using twins.  The software is free and open source and very much still in development. 

For issues email: alexander.hatoum@colorado.edu or ashatoum@wustl.edu. 

The brain mapping pipeline has four scripts. 

Part A: Runs vertexwise twin analysis (in parallel)

Part B: post-processes the brain data

Part C: Organizes data from R into data that is aligned with MNI coordinates

Part D: Takes results from part C and creates .mgh freesurfer files that can be plotted in Freeview and manipulated by freesurfer commands

Each Part has a single corresponding script and that script is annotated to demonstrate the process. Looking at the comments will explain explicity what parts of the script you would need to add your own data or change the line. 

The script largely uses base R. Please use R version 3.0 or < and the latest installation of OpenMx and umx packages from CRAN. Please do not use the developer version of OpenMx on github. 
