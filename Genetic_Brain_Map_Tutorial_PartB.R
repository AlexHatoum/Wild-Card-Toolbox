#After running the map, you may have your own pipeline for munging the vertexwise results into something that can be plotted.  If so, you can skip the 
#the rest of the tutorials and move to that.  

#For this script: When the brain is crushed in preprocessing, it can produce estimates that are not fit for the structural modeling 
#procedure.  This script will enter those vertices as missing.

#Run this code to get the function in your environment
VertexNames.Spades <- function(D, V){
  #length(unique(twi2$family))
  column_names <- colnames(D)
  Names1 <- column_names[grepl("1$", column_names)] #make 
  Names2 <- column_names[grepl("2$", column_names)]
  selDVs <- c(Names1, Names2)
  Names <- substr(Names1, 1, nchar(Names1)-1) 
  Names3 <- Names[!Names %in% V]
  DataF <- matrix(1:length(Names3))
  DataF[,1] <- Names3
  DataF <- as.data.frame(DataF)
  names(DataF)[names(DataF) == "V1"] <- 'Var1'
  return(DataF)
}


#The first argument is the Twinfile you ran in Genetic_Brain_Map_PartA (the previous script) and the second is the name of the variable
#you mapped (the exact name of the column, these are the same arguments you used in the first arguments of the "AceOfSpades.vertex()" function

FullNames <- VertexNames.Spades(Analysis, "Behavior")

#Cool, now merge this column with the full file.  If you named all your objects with the same names I have been using, you won't have
#to change any of this code.
#won't have to edit this code.  Both the Object created by "VertexNames.Spades()" and "AceOfSpades.vertex()" have a Var1 column. 
AnalysesFull  <- merge(FullNames, AnalysesOut, by = "Var1", all.x=TRUE)

#Awesome! Write it out and go to the python script for part C
write.csv(AnalysesFull, "LeftHemisphereBehavior.csv")


#Finally, if you want to transform the p-values (log transfrom for plotting for example or add FDR correction for example) it is good to do that before 
#running VertexNames.Spades and merging. 
