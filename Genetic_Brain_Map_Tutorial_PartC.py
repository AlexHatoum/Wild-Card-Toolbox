#Hello World (Programming humor!), Anyway, yes this is a python script.  If you have your own vertexwise estimates from your own 
#pipeline, you can use this script and the next to get them into freesurfer file format to plot on the brain. 

##below I will use the ***** again to Show you what you need to change explicitly.   If something goes wrong, it will output a files with nothing in them, just so you know.


#Start by importing the appropriate Python Modules.  
import numpy as np
import pandas as pd

#Next you will need to load the data in two parts

#Part 1 involves loading a template for the vertexwise data coordinates
asc_head = ['vertex', 'x', 'y', 'z', 'anatomy']
#******There are two things you will need to change about the code below for your own research.  The first is the file path in "pd.read_table()".  That needs to be the file  location
# of the free  surfer fsaverage brain  in asc format. This usually comes with your download of freesurfer.  the second
#***** is that template needs to be changed to the hemisphere you plotted. So if it is the left hemisphere, (like it is now) 
#the extension is "lh". If it is the right hemisphere, change it to "rh". i.e. change rh to lh when appropriate
asc_dat = pd.read_table(".../vertexwise_thickness_resids_fsaverage5/thickness_asc_files/01321_lh_thickness_fsaverage.asc", names=asc_head, header=None, sep='\s+', dtype={'vertex':object})

#****This file is the input data you made in Tutioral B script. 
pipe_dat = pd.read_csv("BehaviorLeft.csv", index_col=0)

left_list = ['l_' + str(i) for i in asc_dat['vertex']]
right_list = ['r_' + str(i) for i in asc_dat['vertex']]


#*****below, change the measures in brackets to the name of the columns you want to (eventually) plot in freesurfer, in this case I am wanting to plot the rG between each vertex and my outcome and the Log P-value at each vertex. I usually plot the Log of the P values and the genetic correlation
#***** you can put any number of the columns made in Parts A and B into these brackets.  Make sure they are seperated by commas and are in
# 'quotation' marks. 

for measure in ['rG', 'LogPvalue']:
#****Specifiy the correct hemisphere here (i.e. change right_list to left_list and vice versa based on the hemisphere). 

	anatomy = pd.Series(pipe_dat.ix[left_list][measure].values).replace('', np.NaN).fillna(value=0)

	out_df = pd.DataFrame({
		'vertex':asc_dat['vertex'],
		'x':asc_dat['x'],
		'y':asc_dat['y'],
		'z':asc_dat['z'],
		'anatomy':anatomy
		})

	out_df = out_df[asc_head]#.replace(r'\s+', np.nan, regex=True)
  
  #**** Finally, this code produces spereate asc files for each column you specified, you will read these files into the next script.   The files will be "ColumnName" and then "YourName.asc"
  #For example, "rGMap.asc" and "LogPvalueMap.asc" would be made by the code below. 
	fname = measure + Map.asc'
	out_df.to_csv(fname, sep=' ', header=False, index=False)
